The first step is to open your terminal and make sure that you are in the root
of the healthlocker Repo. Once here run the following...

```
cat healthlocker.service
```

This will print the contents of the file into your terminal. Highlight the
contents and copy them to your clipboard with `cmd/control + c`

The next step is to `ssh` onto the server with
```
ssh root@'ip_address'
```

Once on the server create a file called `'app_name'.service` in the
`/lib/systemd/system/` directory. For example

```
touch /lib/systemd/system/healthlocker.service
```

Now that the file is created you will need to paste the code you have copied
to your clipboard into the file. To do this you will need to...

- vim `/lib/systemd/system/'app_name'.service`
- type `:set paste` and then press return
- type `i` to enter insert mode
- paste the contents you copied earlier
- press the escape key

You will need to update the `Description` and `WorkingDirectory` lines with the
necessary information. To do so

- use the arrow keys to go to the end of the line you want to edit
- press `i` to enter insert mode
- delete the example text using backspace
- then type in your description or file path
- press the escape key
- type `:wq` to save and exit your file
- press enter

Now that you have created and added to your file, the next step is to add in
any environment variables you will need.

You will need to know the environment variables that you need to add, as they
will be specific to your application. For healthlocker we needed
- appsignal_push_api_key
- ses_server
- ses_port
- smtp_username
- smtp_password
- segment_write_key
- read_only_hostname
- read_only_username
- read_only_password
- read_only_database
- port
- secret_key_base
- timeout_interval
- to_email
- from_email
- mpass
- session_timeout

To add an environment variable you will need to...

- vim `/lib/systemd/system/'app_name'.service`
- use the down arrow and put your curser on the line that says `RESTART=on-failure`
- press `o` which enter insert mode on a new line
- then type Environment="variable_key=variable_value"

Repeat this process until you have entered all of your environment variables,
- press the escape key
- type `:wq` to save and exit

To check to see if your service is working as you would expect it to by starting
it with the command (provided your application is not running already. If it is
then turn if off however you would normally)
```
systemctl start 'app_name'.service
```

This should start your application and allow you to be able to navigate to it in
the browser as you normally would.

If you want to check the status of the application use
```
systemctl status 'app_name'.service
```

Once you have confirmed your site is running as expected stop the application
using
```
systemctl stop 'app_name'.service
```

The last command to run is
```
systemctl enable app_name.service
```

This will allow your application to start automatically when
the server boots :+1:

All thats left is to reboot the server to test that it works. (SLaM currently
do this for us)
