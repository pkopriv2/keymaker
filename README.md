# Keymaker

Keymaker is a tool to manage ssh key creation and connections.  Think knife, but without the chef server.  It makes key creation and exchanging trivial.

# Commands

* *km key create [\<name\>]* - Create a new named ssh key.  If none is provided, it is defaulted to "default".
* *km host bootsrap \<login\> [\<key\>]* - Perform a key exchange with the given host (of the form: user@host) and key.
* *km login \<login\>* - Start an ssh session with the given login.
* *km run \<regexp\> \<cmd\>* - Run the given command on all the hosts matched by the given regular expression.

# Installation

Head on over to https://github.com/pkopriv2/bashum and install the latest version of bashum. 

* Install the current version.
    
```
bashum install keymaker 
```

# Usage

* Create the "default" key

```
km key create
```

* Exchange the key with a host

```
km host bootstrap pkopriv2@localhost
```

* Run a command

```
km run pkopriv2@localhost "ls ~"
```

# Future Versions

* Add the password protected keys to ssh-agent via ssh-add.  
