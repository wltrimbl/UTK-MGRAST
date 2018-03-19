# MG-RAST-Tools

MG-RAST-Tools is a collection of python scripts and python module to talk to the [MG-RAST API](http://api.mg-rast.org/)

It is hosted at  http://github.com/MG-RAST/MG-RAST-Tools

## A synchronous API queries

While some requests start providing data immediately, some requests (like http://api.mg-rast.org/darkmatter and http://api.mg-rast.org/matrix) do not have the results ready in time to respond to an HTTP GET request.

These give us URLs that we need to check later when the results are ready.

This query

    curl http://api.mg-rast.org/darkmatter/mgm4441680.3 

gives me this response

	url	"http://shock.metagenomics.anl.gov/preauth/QWng8pZ4UEfHGWdPTapZ"
	id	"mgm4441680.3"
	timestamp	"2018-03-15T22:16:11"
	status	"submitted"

Which means, in essence, "please check back later".

If I make the query a few minutes later, it includes a field with the URL of the answer to my earlier query:
	
	name	"mgm4441681.3.750.darkmatter.faa"
	id	"mgm4441681.3"
	timestamp	"2018-03-15T22:18:32"
	size	9445796
	status	"done"
	md5	"15baa92ab0351969d2714bab73797f8c"
	url	"http://shock.metagenomics.anl.gov/preauth/eZmBpBum5n6dPDuA2xfm"

We have a tool that will make repeated (not too frequent) requests to the API to ask if our calculation is done.  

    mg-query.py  <URL>  # ask repeatedly for slow-to-be-delivered data

## Authentication

To access private data in MG-RAST, we need some kind of way to login to MG-RAST.   For the API tools you need a webkey.

You can get a webkey from the upload page of MG-RAST.  Click on the cloud with the up arrow or go to the [upload page](http://www.mg-rast.org/mgmain.html?mgpage=upload)  and there is the sentence 

   To view your webkey required for using the API, click here.

Click there, and you can copy and paste your webkey.
The webkey can be added to any of the API calls as 

    auth=MyMgRastWebkeyfromuploadpage

for example 

    curl http://api.mg-rast.org/darkmatter/mgm4441680.3?auth=MyMgRastWebkey

might let you into mgm4441680.3 if it weren't already public.  However, you can set the shell environment variable MGRKEY to the value you got from the webpage

    export MGRKEY=MyMgRastWebkeyfromuploadpage

and the MG-RAST-Tools will automatically recognize it and add it to the requests.    If you want this to persist on your system, you need to add this to .bash_profile or .bashrc.  If this doesn't make sense, ask the nearest nerd. 

## Docker!

One of the ways out of the "grumpy sysadmin who won't install the tools you need / the tools you want / the tools in the last tabloid scientific spectacular" problem is to rent a server from Amazon.

Another, applicable if your compute is cheap, is to use docker containers.  These are linux filesystems/operating systems that can run on your laptop, on a server, or on an EC2 instance.  They are big to download and store  (100Mbytes - few Gbytes, if you don't try to install sequence databases on them) but they provide an environment where scientific tools for linux work--without breaking and without breaking anything in the host sytem.

## Let's go

This command starts a docker "container" that has been pre-loaded 
with python, MG-RAST-Tools, R, and matR.   Run

    docker run -it wltrimbl/mgrclient

And you get greeted with a prompt 

    root@960d98f0328b:/#

This is the bash shell prompt.  This is linux, running on your laptop.

We can poke around and see that we are running linux:

    uname -a

    ls / 

And we can run some of the tools in the MG-RAST-Tools suite:

    mg-query.py -h

    mg-inbox.py -h

As long as we see the # prompt, we are in the docker-provided
linux environment.  This environment doesn't have access to 
files on your laptop, so we can't hurt anything for now. :)

## The scripts

**mg-query.py**  : submit URL to API, handling authorization and asynchronous querying 
**mg-inbox.py** :  **upload data** 
**mg-submit.py**  : **start jobs**
**mg-project.py**  : list metagenomes in project, show project metadata
**mg-correlate-metadata.py**  : dump metagenome metadata as tab-delimited key-value 
**mg-download.py**  : show raw data files for download, download one or more at a time 
**mg-search-metagenomes.py** :  command-line interface for search
**mg-display-statistics.py**  : dump calculated basepairs and other automatically calculated numbers as tab-delimited key-value pairs
**mg-abundant-functions.py** : list most abundant few functions
**mg-abundant-taxa.py**  : list most abundant few taxa
**mg-get-sequences-for-function.py** : self explanatory
**mg-get-sequences-for-taxon.py** : self explanatory
**mg-get-similarity-for-function.py**  : return similarity table (which maps reads-and-clusters to database-protein-md5)  for rows that match a chosen function
**mg-get-similarity-for-taxon.py** : similarity table subset 

##  The challenge

Our task is to find an interesting gene (your favorite gene) in a 
set of (shotgun) datasets
in MG-RAST, and download all of the protein fragments that match that 
gene from all of the shotgun datasets in (your favorite environment).

1.  Find a list of suitable shotgun datasets
2.  Choose a database and an annotation to target
3.  Find the API call that delivers sequences that have a particular annotation
4.  Issue the API call once for each dataset in the list from step 1




