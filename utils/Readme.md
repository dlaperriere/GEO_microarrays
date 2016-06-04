# cmd: Utility methods used to run commands 


### can_run
Test a command 



### find_shell
Find current command shell  



### on_windows
Is the current operating system windows? 



### run
Run a command and return output,status (0 ok, -1 error) 

-----

# r : Utility methods used to run R scripts


### findR
Find path to R scripting front-end(Rscript) 


Try Rscript, $R_HOME and HKLM\SOFTWARE\R-core\R*\InstallPath


### runR
Run R script 


    parameters
     - r: path to R scripting front-end  (Rscript)
     - script: R script filename
     - args: script parameters

    return
     - output,status (0=ok -1=error)
-----