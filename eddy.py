#!/usr/bin/env python3
import sys
import re

def main():
    filenames = []
    muteSourceData = False
    curr_argv_index = 1

    if sys.argv[curr_argv_index] == '-n':
        #  eddy -n - prevent default print
        muteSourceData = True
        curr_argv_index += 1
        if sys.argv[curr_argv_index] == '-f':
            #  eddy -n -f '[arg]' - read commands from file
            try:
                curr_argv_index += 1
                with open(sys.argv[curr_argv_index]) as file:
                    arg = file.read().strip()
            except Exception: 
                print(f'eddy: error')
                sys.exit(1)
        else:
            arg = sys.argv[curr_argv_index]
    elif sys.argv[curr_argv_index] == '-f':
        # eddy -f '[arg]' - read commands from file
        try:
            curr_argv_index += 1
            with open(sys.argv[curr_argv_index]) as file:
                arg = file.read().strip()
        except Exception: 
            print(f'eddy: error')
            sys.exit(1)
    else:
        # no optional argument
        arg = sys.argv[curr_argv_index]
    
    # handle file input
    curr_argv_index += 1
    if curr_argv_index <= len(sys.argv):
        # if has following file input, try open it
        for filename in sys.argv[curr_argv_index:]:
            filenames.append(filename)

    # handle multiple command
    # substitute the comment
    commands = re.sub(r'#.*?(\n|$)', '\n', arg)
    # delete white spaces
    commands = commands.replace(" ", "")
    # split
    commands = re.split('\n|;', commands)

    # read input from file
    if filenames != []:
        line_num = 1
        isEnd = False
        isQuit = False
        # initialize isInRange array to keep track of each command's range status
        isInRange = []
        for _ in range(len(commands)):
            isInRange.append(False)
        for filename in filenames:
            try:
                with open(filename) as file:
                    line = file.readline()
                    while line != '':
                        if line[-1] == '\n':
                            line = line[:-1]
                        data = line
                        next_line = file.readline()
                        if next_line == '':
                            isEnd = True
                        
                       # process data
                        command_index = 0
                        for command in commands:
                            if command:
                                if data and not isQuit:
                                    new_data, new_isInRange, new_isQuit = process_line(command, command_index, data, line_num, isInRange, isEnd, isQuit)
                                    data = new_data
                                    isInRange = new_isInRange
                                    isQuit = new_isQuit
                                command_index += 1

                        # increment
                        line = next_line
                        line_num+=1

                        # print the processed data
                        if data and not muteSourceData:
                            print(data)
                        if isQuit:
                            sys.exit(0)
            except Exception:
                print(f'eddy: error')
                sys.exit(1)
        
        sys.exit(0)
    # read input from stdin
    else:
        #initial state
        line = sys.stdin.readline()
        line_num = 1
        isEnd = False
        isQuit = False
        # initialize isInRange array to keep track of each command's range status
        isInRange = []
        for _ in range(len(commands)):
            isInRange.append(False)
        # loop through each line in sys.stdin
        while line != '':
            # handle new line character at the end
            if line[-1] == '\n':
                line = line[:-1]
            data = line
            # read one line ahead
            next_line = sys.stdin.readline()
            if next_line == '':
                isEnd = True

            # process data
            command_index = 0
            for command in commands:
                if command:
                    if data and not isQuit:
                        new_data, new_isInRange, new_isQuit = process_line(command, command_index, data, line_num, isInRange, isEnd, isQuit)
                        data = new_data
                        isInRange = new_isInRange
                        isQuit = new_isQuit
                    command_index += 1

            # increment
            line = next_line
            line_num+=1

            # print the processed data
            if data and not muteSourceData:
                print(data)
            if isQuit:
                sys.exit(0)
        sys.exit(0)


def process_line(arg, command_index, data, line_num, isInRange, isEnd, isQuit):
    # other command
    if re.match(r'\/\S+\/[qpd]$', arg) or re.match(r'[0-9$]*[qpd]$', arg) or re.match(r'.+,.+[pd]$', arg):
        command = arg[-1]
        match command:
            case "q":
                return q_case(arg, data, line_num, isInRange, isEnd, isQuit)
            case "p":
                return p_case(arg, command_index, data, line_num, isInRange, isEnd, isQuit)
            case "d":
                return d_case(arg, command_index, data, line_num, isInRange, isEnd, isQuit)
    # substitute command
    elif re.match(r'.*s\S.*\S.*\S', arg):  
        # go to s_case
        # demiter is the character following the s
        delimiter = arg[arg.find('s') + 1]
        return s_case(arg, command_index, data, delimiter, line_num, isInRange, isEnd, isQuit)
    else:
        print(f'eddy: error')
        sys.exit(1)

def q_case(arg, data, line_num, isInRange, isEnd, isQuit):
    address = arg[:-1]
    try:
        address = int(address)
    except ValueError:
        # regex object
        regex = re.compile(address[1:-1])
    if isinstance(address, int):
        # line number
        if line_num == address:
            isQuit = True
    elif address == '$':
        if isEnd:
            isQuit = True
    else:
        # regex
        if regex.search(data):
            isQuit = True
    return data, isInRange, isQuit

def p_case(arg, command_index, data, line_num, isInRange, isEnd, isQuit):
    address = arg[:-1]
    comma_index = address.find(',')
    try:
        address = int(address)
    except ValueError:
        # regex object
        regex = re.compile(address[1:-1])

    if isinstance(address, int):
        # line number
        if line_num == address:
            print(data)
    elif address == '$':
        # address last line
        if isEnd:
            print(data)
    elif comma_index != -1:
        # address: range
        # check range_low
        range_low = address[:comma_index]
        try:
            range_low = int(range_low)
        except ValueError:
            regex_low = re.compile(range_low[1:-1])
         # check range_high
        range_high = address[comma_index + 1:]
        try:
            range_high = int(range_high)
        except ValueError:
            regex_high = re.compile(range_high[1:-1])
        if isInRange[command_index]:
            if isinstance(range_high, int):
                # line number
                if line_num == range_high:
                    isInRange[command_index] = False
                elif line_num > range_high:
                    isInRange[command_index] = False
                    # already out of range, and regex is not match
                    # early return
                    if isinstance(range_low, int):
                        return data, isInRange, isQuit
                    if not isinstance(range_low, int):
                        if not regex_low.search(data):
                            return data, isInRange, isQuit
            else:
                # regex
                if regex_high.search(data):
                    isInRange[command_index] = False
            print(data)
        else:
            # if not in range, check if range start
            if isinstance(range_low, int):
                # line number
                if line_num == range_low:
                    print(data)
                    isInRange[command_index] = True
                if line_num > range_low:
                    # check if in range
                    if isinstance(range_high, int) and line_num <= range_high:
                        print(data)
                        isInRange[command_index] = True
            else:
                # regex
                if regex_low.search(data):
                    print(data)
                    isInRange[command_index] = True
    else:
        # regex
        if regex.search(data):
            print(data)
    return data, isInRange, isQuit

def d_case(arg, command_index, data, line_num, isInRange, isEnd, isQuit):
    address = arg[:-1]
    comma_index = address.find(',')
    try:
        address = int(address)
    except ValueError:
        # regex object
        regex = re.compile(address[1:-1])

    if isinstance(address, int):
        # address: line number
        if line_num == address:
            data = ''
            return data, isInRange, isQuit
    elif address == '$':
        # address last line
        if isEnd:
            data = ''
            return data, isInRange, isQuit
    elif comma_index != -1:
        # address: range
        # check range_low
        range_low = address[:comma_index]
        try:
            range_low = int(range_low)
        except ValueError:
            regex_low = re.compile(range_low[1:-1])
         # check range_high
        range_high = address[comma_index + 1:]
        try:
            range_high = int(range_high)
        except ValueError:
            regex_high = re.compile(range_high[1:-1])
        if isInRange[command_index]:
            if isinstance(range_high, int):
                # line number
                if line_num == range_high:
                    isInRange[command_index] = False
                elif line_num > range_high:
                    isInRange[command_index] = False
                    # already out of range, and regex is not match
                    # early return
                    if isinstance(range_low, int):
                        return data, isInRange, isQuit
                    if not isinstance(range_low, int):
                        if not regex_low.search(data):
                            return data, isInRange, isQuit
            else:
                # regex
                if regex_high.search(data):
                    isInRange[command_index] = False
            data = ''
        else:
            # if not in range, check if range start
            if isinstance(range_low, int):
                # line number
                if line_num == range_low:
                    isInRange[command_index] = True
                    data = ''
                    return data, isInRange, isQuit
                if line_num > range_low:
                    # check if in range
                    if isinstance(range_high, int) and line_num <= range_high:
                        isInRange[command_index] = True
                        data = ''
                        return data, isInRange, isQuit
            else:
                # regex
                if regex_low.search(data):
                    isInRange[command_index] = True
                    data = ''
                    return data, isInRange, isQuit
    else:
        # adress: regex
        if regex.search(data):
            data = ''
            return data, isInRange, isQuit
    return data, isInRange, isQuit

def replaceHelper(input_line, str_to_replace, replace, has_g):
    if (has_g):
        result = re.sub(str_to_replace, replace, input_line)
    else:
        result = re.sub(str_to_replace, replace, input_line, count=1)
    return result

def s_case(arg, command_index, data, delimiter, line_num, isInRange, isEnd, isQuit):
    line_num_pattern = re.compile(rf'^[0-9]*s{delimiter}')
    regex_pattern = re.compile(rf'^/.+/s{delimiter}')
    range_pattern = re.compile(rf'^.+,.+s{delimiter}')
    s_index = arg.find('s')
    address = arg[:s_index]
    substitute = arg[s_index+2:]
    # handle escaped symbol
    if re.match(r'^[a-zA-Z]$', delimiter):
        parts = re.split(rf'{delimiter}', substitute)
    else:
        parts = re.split(rf'\{delimiter}', substitute)
    str_to_replace = parts[0]
    replace = parts[1]
    if len(parts) != 3:
        print(f'eddy: command line: invalid command')
        sys.exit(1)
    optional_modifier = parts[2]
    has_g = True if optional_modifier == 'g' else False

    if line_num_pattern.match(arg):
        # address: line_num
        if address == '':
            data = replaceHelper(data, str_to_replace, replace, has_g)
        elif line_num == int(address):
            data = replaceHelper(data, str_to_replace, replace, has_g)
    elif address == '$':
        # address last line
        if isEnd:
            data = replaceHelper(data, str_to_replace, replace, has_g)
    elif range_pattern.match(arg):
        # address: range
        comma_index = address.find(',')
        # check range_low
        range_low = address[:comma_index]
        try:
            range_low = int(range_low)
        except ValueError:
            regex_low = re.compile(range_low[1:-1])
         # check range_high
        range_high = address[comma_index + 1:]
        try:
            range_high = int(range_high)
        except ValueError:
            regex_high = re.compile(range_high[1:-1])
        if isInRange[command_index]:
            if isinstance(range_high, int):
                # line number
                if line_num == range_high:
                    isInRange[command_index] = False
                elif line_num > range_high:
                    isInRange[command_index] = False
                    # already out of range, and regex is not match
                    # early return
                    if isinstance(range_low, int):
                        return data, isInRange, isQuit
                    if not isinstance(range_low, int):
                        if not regex_low.search(data):
                            return data, isInRange, isQuit
            else:
                # regex
                if regex_high.search(data):
                    isInRange[command_index] = False
            data = replaceHelper(data, str_to_replace, replace, has_g)
        else:
            # if not in range, check if range start
            if isinstance(range_low, int):
                # line number
                if line_num == range_low:
                    data = replaceHelper(data, str_to_replace, replace, has_g)
                    isInRange[command_index] = True
                if line_num > range_low:
                    # check if in range
                    if isinstance(range_high, int) and line_num <= range_high:
                        data = replaceHelper(data, str_to_replace, replace, has_g)
                    isInRange[command_index] = True
            else:
                # regex
                if regex_low.search(data):
                    data = replaceHelper(data, str_to_replace, replace, has_g)
                    isInRange[command_index] = True
    elif regex_pattern.match(arg):
        # address: regex
        regex = re.compile(address[1:-1])
        if regex.search(data):
            data = replaceHelper(data, str_to_replace, replace, has_g)
    else: 
        print(f'eddy: command line: invalid command')
        sys.exit(1)
    return data, isInRange, isQuit

if __name__ == "__main__":
    main()