
import haxe.io.Input;
import haxe.io.Output;

@:include('Sys.h')
@:coreApi
extern class Sys {

    /**
        Print any value on the standard output.
    **/
    static public function print( v : Dynamic ) : Void ;

    /**
        Print any value on the standard output, followed by a newline.
    **/
    static public function println( v : Dynamic ) : Void ;

    /**
        Returns all the arguments that were passed by the commandline.
    **/
    static public function args() : Array<String> ;

    /**
        Returns the value of the given environment variable.
    **/
    static public function getEnv( s : String ) : String ;

    /**
        Set the value of the given environment variable.
    **/
    static public function putEnv( s : String, v : String ) : Void ;

    /**
        Returns the whole environement variables.
    **/
    static public function environment() : Map<String,String> ;

    /**
        Suspend the current execution for the given time (in seconds).
    **/
    static public function sleep( seconds : Float ) : Void ;

    /**
        Change the current time locale, which will affect `DateTools.format` date formating.
        Returns true if the locale was successfully changed
    **/
    static public function setTimeLocale( loc : String ) : Bool ;

    /**
        Get the current working directory (usually the one in which the program was started)
    **/
    static public function getCwd() : String ;

    /**
        Change the current working directory.
    **/
    static public function setCwd( s : String ) : Void ;

    /**
        Returns the name of the system you are running on. For instance :
            "Windows", "Linux", "BSD" and "Mac" depending on your desktop OS.
    **/
    static public function systemName() : String ;

    /**
        Run the given command. The command output will be printed on the same output as the current process.
        The current process will block until the command terminates and it will return the command result (0 if there was no error).
        Command arguments can be passed in two ways: 1. using `args`, 2. appending to `cmd` and leaving `args` as `null`.
         1. When using `args` to pass command arguments, each argument will be automatically quoted, and shell meta-characters will be escaped if needed.
        `cmd` should be an executable name that can be located in the `PATH` environment variable, or a path to an executable.
         2. When `args` is not given or is `null`, command arguments can be appended to `cmd`. No automatic quoting/escaping will be performed. `cmd` should be formatted exactly as it would be when typed at the command line.
        It can run executables, as well as shell commands that are not executables (e.g. on Windows: `dir`, `cd`, `echo` etc).
        Read the `sys.io.Process` api for a more complete way to start background processes.
    **/
    static public function command( cmd : String, ?args : Array<String> ) : Int ;

    /**
        Exit the current process with the given error code.
    **/
    static public function exit( code : Int ) : Void ;

    /**
        Gives the most precise timestamp value (in seconds).
    **/
    static public function time() : Float ;

    /**
        Gives the most precise timestamp value (in seconds) but only account for the actual time spent running on the CPU for the current thread/process.
    **/
    static public function cpuTime() : Float ;

    /**
        Returns the path to the current executable that we are running.
    **/
    static public function executablePath() : String ;

    //  Public field programPath is not part of core type

    /**
        Returns the absolute path to the current program file that we are running.
        Concretely, for an executable binary, it returns the path to the binary.
        For a script (e.g. a PHP file), it returns the path to the script.
    **/
    static public function programPath() : String;
    // Required by Haxe Compiler v3.3.0

    /**
        Read a single input character from the standard input (without blocking) and returns it. Setting `echo` to true will also display it on the output.
    **/
    static public function getChar( echo : Bool ) : Int ;

    /**
        Returns the process standard input, from which you can read what user enters. Usually it will block until the user send a full input line. See `getChar` for an alternative.
    **/
    static public function stdin() : haxe.io.Input ;

    /**
        Returns the process standard output on which you can write.
    **/
    static public function stdout() : haxe.io.Output ;

    /**
        Returns the process standard error on which you can write.
    **/
    static public function stderr() : haxe.io.Output ;
}
