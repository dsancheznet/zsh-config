# ZSH RC File written by D.Sanchez
# Version 1.0 Tested on MacOSX Catalina

# Are we in a ssh connection?
if [[ -n "$SSH_CONNECTION" ]]; then
  # Exit with code 1
  return 1
fi


#Executed whenever the current working directory is changed.
chpwd () {
  # Do nothing in here - for now
  :
}



# List of commands to ignore
IGNORE_CMD="vi ed man"



#Executed just after a command has been read and is about to be executed. If the history mechanism is active (regardless of whether the line was discarded from the history buffer), the string that the user typed is passed as the first argument, otherwise it is an empty string. The actual command that will be executed (including expanded aliases) is passed in two different forms: the second argument is a single-line, size-limited version of the command (with things like function bodies elided); the third argument contains the full text that is being executed.
preexec () {
    # Note the date when the command started, in unix time.
    CMD_START_DATE=$(date +%s)
    # Store the command that we're running.
    CMD_NAME=$1
    CMD_BASENAME=${1/ */} #TODO: Eliminate sudo in front of any command
}



#Executed before each prompt. Note that precommand functions are not re-executed simply because the command line is redrawn, as happens, for example, when a notification about an exiting job is displayed.
precmd () {

    # Proceed only if we've run a command in the current shell.
    if ! [[ -z $CMD_START_DATE ]]; then

        # Note current date in unix time
        CMD_END_DATE=$(date +%s)

        # Store the difference between the last command start date vs. current date.
        CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))

        # Store an arbitrary threshold, in seconds.
        CMD_NOTIFY_THRESHOLD=30

        if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then

            if [[ ! ${IGNORE_CMD[*]} =~ "$CMD_BASENAME" ]]; then #Check the programs here...

                # Trigger a terminal sound
                afplay /System/Library/Sounds/Ping.aiff

                # Do your thing
                osascript \
                  -e 'tell application "System Events"' \
                  -e 'set frontApp to name of first application process whose frontmost is true' \
                  -e 'end tell' \
                  -e 'if ((frontApp as string) is not equal to "Terminal") then' \
                  -e 'display notification "El proceso \"'$CMD_BASENAME'\" ha terminado" with title "Terminal" subtitle "Estado"' \
                  -e 'end if'

            fi

        fi

    fi

}



#Adjust Prompt
PS1="%K{17} %K{18} %K{19} %K{20} %K{21} %B%F{255}%n%f %F{0}%m%f %F{11}%~%f %K{20} %K{19} %K{18} %K{17} %f%k%b "
RPROMPT="%(?.%F{10}✓%f.%F{9}⚠%f%?) 🕒 %T"



#Define aliases
alias cls="clear && ls -lG"
alias clsh="clear && ls -lahG"
alias ip="curl icanhazip.com"



#Define LS Colors
#Color order
#  1.   directory
#  2.   symbolic link
#  3.   socket
#  4.   pipe
#  5.   executable
#  6.   block special
#  7.   character special
#  8.   executable with setuid bit set
#  9.   executable with setgid bit set
#  10.  directory writable to others, with sticky bit
#  11.  directory writable to others, without sticky bit
#Color codes
#  a     black
#  b     red
#  c     green
#  d     brown
#  e     blue
#  f     magenta
#  g     cyan
#  h     light grey
#  A     bold black, usually shows up as dark grey
#  B     bold red
#  C     bold green
#  D     bold brown, usually shows up as yellow
#  E     bold blue
#  F     bold magenta
#  G     bold cyan
#  H     bold light grey; looks like bright white
#  x     default foreground or background
export LSCOLORS="gxdxexexHxbxfxHxHxHxHx"
