# Keymaker

Keymaker is a tool to manage ssh key creation and connections.  Think knife, but without the chef server.  It makes key creation and exchanging trivial.

# Commands

* *keymaker key create [\<name\>]* - Create a new named ssh key.  If none is provided, it is defaulted to "default".
* *keymaker host bootsrap \<login\> [\<key\>]* - Perform a key exchange with the given host (of the form: user@host) and key.
* *keymaker login \<login\>* - Start an ssh session with the given login.
* *keymaker run \<regexp\> \<cmd\>* - Run the given command on all the hosts matched by the given regular expression.

# Installation

Head on over to https://github.com/pkopriv2/bashum and install the latest version of bashum. 

* Install the current version.
    
```
bashum install keymaker 
```

# Usage

* Create the "default" key

```
keymaker key create
```

* Exchange the key with a host

```
keymaker host bootstrap pkopriv2@localhost
```

* Run a command

```
keymaker run pkopriv2@localhost "ls ~"
```

# Future Versions

* Add the password protected keys to ssh-agent via ssh-add.  
