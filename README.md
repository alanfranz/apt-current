# apt-current: don't need an 'apt-get update' ever again! 

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

# what does apt-current do?

It adds a new command, ```apt-get-current```, which is a wrapper for ```apt-get```. 
I'll add ```apt-current``` as well later on.

```apt-get-current``` can be used just like plain ```apt-get```, but it is got
a small superpower. When performing **install**, **upgrade**, or **dist-upgrade**
commands, it will automatically perform an ```apt-get -y update``` before launching
those commands, if any of those three conditions occur:

 * too much time has passed since last ```apt-get update``` invocation. By default
   such time is three hours, but can be configured in ```/etc/apt-current.conf```
 * the content of ```/etc/apt/sources.list``` or of any relevant file in 
   ```/etc/apt/sources.list.d``` has changed since last ```apt-get update```
   invocation.
 * the configuration of ```apt-get```, as shown by ```apt-config dump```, has
   changed since last ```apt-get update``` invocation.


So, unless you need a package which has just been released, you'll never need
to ```apt-get update``` again. Just

```apt-get-current -y dist-upgrade```

or

```apt-get-current -y install foobar```

and let it do the dirty part of the job.

Since it's a separate executable, if it's buggy you can always resort to the standard apt-get. No disruption of your
user experience.

# installation


There're repositories for various Ubuntu and Debian versions. 64-bit only, currently. Open a ticket if you're
still using a 32-bit system and would like a packaged version.

First, you should make sure that you've got my package signing key properly installed and configured for apt:

```curl https://www.franzoni.eu/keys/D1270819.txt | sudo apt-key add -```

Then, pick the repo for your distribution - see below - and save it as ```/etc/apt/sources.list.d/apt-current-v1.list```

Once the repo file is in place:

```
apt-get update
apt-get -y install apt-current
```

## Ubuntu Trusty

```
deb http://www.a9f.eu/apt/apt-current-v1/ubuntu trusty main
```

## Ubuntu Xenial

```
deb http://www.a9f.eu/apt/apt-current-v1/ubuntu xenial main
```

## Debian Jessie

```
deb http://www.a9f.eu/apt/apt-current-v1/debian jessie main
```

## TODO

 * gracefully handle ```apt-get update``` errors
 * add ```apt-current``` executable to wrap ```apt```

## Contacts

Feel free to open an issue for anything you'd like to discuss.

## FAQ
 * please note that at the first run a priming ```apt-get update``` will be launched, even though
   you'd just have launched one.

