# WARNING:

**APT REPOSITORIES HAVE CHANGED!** Check the new URLs down there.

# apt-current: don't need an 'apt-get update' ever again! 

Forget about ```apt-get update```: just run your ```apt-get-current install``` or ```apt-current full-upgrade``` commands,
and let **apt-current** perform the update if your lists are outdated, or your sources or configuration has changed since
the latest update was executed!

# reasoning

While I like apt-based distros, there's something I really love about yum/dnf;
when I issue a command like

```
yum -y install foobar
```

yum already knows whether it needs to reach out the internet to update its sources.
It does so if its configured repos have changed, or if the so called 'metadata' has 
expired.

apt doesn't have this feature. An ```apt-get update``` is required before properly
installing the latest version of a package, or before upgrading the system. 

Periodic updaters do exist, and this is not a great issue for servers, workstations,
or often-on laptops: but it can be tedious to manage for not-so-often used virtual machines, and,
mostly, **for container systems like Docker**. I've seen many Dockerfiles resorting
to lists deletion/forced updates every know an then, since an image can be very long-lived
and the installations inside it are often automated.

# what does apt-current do, precisely?

It adds two new commands, ```apt-get-current```, which is a wrapper for ```apt-get```. 
and ```apt-current```, which wraps ```apt```

```apt-get-current``` can be used just like plain ```apt-get```, but it is got
a small superpower. When performing **install**, **upgrade**, or **dist-upgrade** 
(or **full-upgrade** for ```apt```)
commands, it will automatically perform an ```apt-get -y update``` (or ```apt -y update```)
 before launching those commands, if any of the following conditions occurs:

 * too much time has passed since last ```apt-get update``` invocation. By default
   such time is three hours, but can be configured in ```/etc/apt-current.conf```
 * the content of ```/etc/apt/sources.list``` or of any relevant file in 
   ```/etc/apt/sources.list.d``` has changed since last ```apt-get update```
   invocation.
 * the configuration of ```apt-get```, as shown by ```apt-config dump```, has
   changed since last ```apt-get update``` invocation.
 * there are no apt lists at all


So, unless you need a package which has just been released, you'll never need
to ```apt-get update``` again. Just

```apt-get-current -y dist-upgrade```

or

```apt-get-current -y install foobar```

and let it do the dirty part of the job.

Since it's a separate executable, if it's buggy you can always resort to the standard apt-get. No disruption of your
user experience.

Also, by default, it will perform an ```apt-get clean``` or ```apt clean``` after modification commands, although
such behaviour can be configured - see next section.

# goodies

There're two additional, optional functions as well: apt-current can delete downloaded deb cache after a command is run,
and apt lists after a dist-upgrade/full-upgrade command is run.

Configuration can be found in ```/etc/apt-current.conf``` - see the default at [apt-current.conf](apt-current.conf)

also, a new ```clean-lists```command is enabled; it manually removes currently cached APT lists.

# Installation

If you just want a quick glance, or you want to download the .deb to include somewhere, head straight to the [Releases](https://github.com/alanfranz/apt-current/releases) page.


There're repositories for various Ubuntu and Debian versions. 64-bit only, currently. Open a ticket if you're
still using a 32-bit system and would like a packaged version.

First, you should make sure that you've got Bintray's package signing key properly installed and configured for apt, and that apt supports https:

```sudo apt-get -y install apt-transport-https curl```

```curl https://www.franzoni.eu/keys/D401AB61.txt | sudo apt-key add -```

Then, pick the repo for your distribution - see below - and save it as ```/etc/apt/sources.list.d/apt-current-v1.list```

Once the repo file is in place:

```
sudo apt-get update
sudo apt-get -y install apt-current
```

## Ubuntu Trusty

```
deb https://dl.bintray.com/alanfranz/apt-current-v1-ubuntu-trusty trusty main
```

## Ubuntu Xenial

```
deb https://dl.bintray.com/alanfranz/apt-current-v1-ubuntu-xenial xenial main
```

## Ubuntu Yakkety

```
deb https://dl.bintray.com/alanfranz/apt-current-v1-ubuntu-yakkety yakkety main
```

## Ubuntu Zesty

```
deb https://dl.bintray.com/alanfranz/apt-current-v1-ubuntu-zesty zesty main
```


## Debian Jessie

```
deb https://dl.bintray.com/alanfranz/apt-current-v1-debian-jessie jessie main
```

## TODO

 * gracefully handle ```apt-get update``` errors

## Contacts

Feel free to open an issue for anything you'd like to discuss.

## FAQ
 * please note that at the first run a priming ```apt-get update``` will be launched, even though
   you'd just have launched one.

