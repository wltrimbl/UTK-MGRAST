# So you want to get some sequencing data out of NCBI?

Requirements:  You'll need an ubuntu linux environment with python (and biopython) or root access and an internet connection (to install python and biopython...)   The first part of this tutorial will be in the browser and then we'll go to linux in python.  

Your linux environment could be an amazon EC2 instance or a docker container running on your local computer.  Also, this tutorial assumes that someone has talked to you about paths and you know how to change directories and execute programs on the command line.  If you get an error that a program or file does not exist, make sure you are in the right path.

NCBI maintains databases for many different types of biological data.  You may be familiar with 
* Genbank ( sequence database of researcher-submitted nucleotide & protein sequences)
* SRA ( Sequence Read Archive -- raw NGS datasets)
* GEO  (Genome expression omnibus -- database for expression datasets)
* Pubmed (bibliographic database of biology-relevant abstracts)

For each of these databases, NCBI provides a *search engine*, *data downloads*, and  *related records in other databases*, as well as other functionality.

Everything that you can get from NCBI's websites you can also get via a program. If you've ever spent thirty minutes looking at search results on NCBI's
website you might be longing for a faster way to get lists of relevant datasets and download them.

## The challenge
My colleague is studying snakes, and for comparative genomic reasons wants all the available snake genomes. 

To do this we will need to
1.  Query NCBI for a list of the relevant genomes
2.  Get enough details about each item on the list to decide whether it's relevant, and
3.  Download the genomes already

We could of course do this by hand.  Via the web, we could go to NCBI's [Entrez](http://www.ncbi.nlm.nih.gov/gquery), selecting genomes, we can construct the following query:

    [http://www.ncbi.nlm.nih.gov/genome?term=Serpentes[Organism]    ](http://www.ncbi.nlm.nih.gov/genome?term=Serpentes[Organism])

By FTP, we could go to NCBI's [FTP site](ftp://ftp.ncbi.nlm.nih.gov/refseq/), find each genome, and download it manually 

We will show you how to find and download the genomes with the NCBI Web Services API.

### What is an API and how does it relate to NCBI?

API stands for *application programming interface*; you can consult [stackoverflow](http://stackoverflow.com/questions/7440379/what-exactly-is-the-meaning-of-an-api) and [wikipedia](https://en.wikipedia.org/wiki/Application_programming_interface) for definitions, which include "an interface through which you access someone else's code or through which someone else's code accesses yours -- in effect the public methods and properties."

The NCBI toolkit is called *Entrez Programming Utilities* or *eutils* for short.  It is described at length in a series of e-books 
[Entrez Programming Utilities Help](http://www.ncbi.nlm.nih.gov/books/NBK25501/), [E-utilities Quick Start](http://www.ncbi.nlm.nih.gov/books/NBK25500/), and [The E-utilities in-depth: parameters, syntax, and more](http://www.ncbi.nlm.nih.gov/books/NBK25499/). 

To do this, you're going to be using one tool in *eutils*, called *efetch*.  There is a whole chapter devoted to [efetch](http://www.ncbi.nlm.nih.gov/books/NBK25499/#chapter4.EFetch) -- When Adina first started doing this kind of work, this documentation always broke her heart.   From detailed, highly functional documentation it is very difficult to learn what the API can do.  It seems that a handful of examples explain much better than volumes of documentation. 

The NCBI functionality is provided by these methods:

1. *search engine*,   (esearch)
2. *lists of search results*,  (esummary)
3. *data downloads*  (efetch)
4. *related records in other databases* (elinks)

And these methods can be accessed by placing http GET requests to NCBI's eutils server.  You send a carefully crafted URL, and NCBI sends you back data.

The following URL, for instance, returns a file called sequence.fa that contains the bare-bones Hodgkinia cicadicola Dsem genome (an insect endosymbiont 
with unusual GC content) in fasta format::

    [http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP001226.1&rettype=fasta](http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP001226.1&rettype=fasta)

Take a look at it.  You can see the genbank formatted genome [here](http://www.ncbi.nlm.nih.gov/nuccore/CP001226.1).

Other data formats of the same data are available.  The following URL will give you a genbank file::

   http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=CP001226.1&rettype=gb

Do you notice the difference in these two commands?  Let's breakdown the command here:

*  `http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?`  This is is the name of the server and the path to the API script on the server.  Efetch, esummary, esearch are different API scripts here.
*  `db=nuccore`  This command tells the NCBI API which **database** to search.  NCBI's databases are listed [here](http://www.ncbi.nlm.nih.gov/books/NBK25497/table/chapter2.T._entrez_unique_identifiers_ui/?report=objectonly)  and include bioproject, genome, nuccore, pubmed, pmc, and sra.  
*  `id=CP000962`  This fields specifies the ID of the genome you want.
*  `rettype=gb`  This field specifies the format of data to be returned.  You'll note that this changed between the two URLs above.  In the first, we asked for only the FASTA sequence, while in the second, we asked for the Genbank file.  What you can put here depends on which database you use, and the documentation is elusive but useful: 

    [valid values of retmode and rettype](http://www.ncbi.nlm.nih.gov/books/NBK25499/table/chapter4.T._valid_values_of__retmode_and/?report=objectonly]])

`retmode` can be xml or text; rettype can be fatsta, gb, gbwithparts, and some others formats for things like paper abstracts in the the non-sequence databases.

NCBI's database objects can be updated, and when they are, the version number is incremented: see the discussion [here](http://www.ncbi.nlm.nih.gov/Class/MLACourse/Modules/Format/exercises/qa_accession_vs_gi.html).  Specifying the version number of the sequence can assure repeatability if obsolescence.

[Table of retmode and rettype fields](http://www.ncbi.nlm.nih.gov/books/NBK25499/table/chapter4.T._valid_values_of__retmode_and/?report=objectonly)
[Table of NCBI database ids](http://www.ncbi.nlm.nih.gov/books/NBK25497/table/chapter2.T._entrez_unique_identifiers_ui/?report=objectonly)


.. Note:: 

   The "?" between the script name and the "&"s between the field name=value pairs is part of the HTTP GET protocol, and is essential.

Knowing that we can get anything that NCBI has to offer from carefully constructed URLs is the most important step here. 

Since different databases and different API scripts have very different types of response, I'm going to suggest using python to fetch and process the
results.

### Automating with an API

So, to get all the snake genomes, I first need a list of all the snake genomes.  
I first construct a query on NCBI's website

    http://www.ncbi.nlm.nih.gov/genome/?term=Serpentes

And translate this into an ESEARCH URL

    http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=genome&term=Serpentes

So first, I need to make HTTP requests in python.  

I'll use the [requests](http://www.python-requests.org/en/latest/) library to make HTTP requests from python. 
The wltrimbl/mgrclient  docker image has this already, so we can start docker and dive into python.  

This should get the page via requests:

    import requests
    # send HTTP request to NCBI
    result = requests.get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=nuccore&term=Serpentes[Organism]")
    # dump the result to the screen
    dir(result)
    print(result.text)

Here result is a requests object whose attributes include `result.status_code` and `result.text`  

This should show us the results of the search -- an XML-encoded data structure which has id numbers in it.  I didn't ask for ID numbers, I asked for Serpentes, so we're not finished yet.

I follow this link in my browser and.. oh.  The response is in XML.  Ok.  Let's cope with XML.

Chrome and Firefox seem to show XML ok by default, but Safari does not.  (To get Safari to render XML follow [these instrucitons](http://arstechnica.com/civis/viewtopic.php?f=19&t=118896)  or just use firefox or chrome.)

So examining the XML tree, we a list called IdList with tags Id that contain five digit numbers.
	
    <eSearchResult>
    <Count>5</Count>
    <RetMax>5</RetMax>
    <RetStart>0</RetStart>
    <IdList>
    <Id>32656</Id>
    <Id>17893</Id>
    <Id>16688</Id>
    <Id>14467</Id>
    <Id>10842</Id>
    </IdList>

These five digit numbers are identifier numbers specific to the nuccore database, and we care about them only until we get our data, then we can forget about them.

What's the fastest way to get the Id tags out of this list?

Well, we search the Python documentation for how to parse XML:  [XML Processing modules](https://docs.python.org/2/library/xml.html)

There are several options; the first one is ElementTree, and it is sufficient for our purposes.

    import xml.etree.ElementTree as ET


So first we call ET.fromstring to parse the XML--load it into a data structure that we can access with ET's subroutines (called methods):

    root = ET.fromstring(result.text)

The canonical approach is to iterate over all of the child nodes of the "root" in the XML data structure:

    for child in root.getchildren():
        print(child)

This gives us all the top level tags. 
However, there is a method that just finds the tags of type that we want (where the name of the tag = "Id") and only loops over them.

    for idtag in root.iter("Id"):
        print(idtag)

The ET child elements have the data stashed in three places, all attributes of idtag: *tag* (the string defining the name of the tag),  *attrib* (a dict of key-value pairs defined inside the <>), and *text* (the stuff between the tags)

    for idtag in root.iter("Id"):
        print idtag.tag, idtag.attrib, idtag.text

From this we see everything we want is in idtag.text.  We can make a list of these 
    idlist = []
    for idtag in root.iter("Id"):
        idlist.append(idtag.text)

or with a list comprehension::

    idlist = [idtag.text for idtag in root.iter("Id")]

This makes idlist a list of strings of the nuccore ids of the sequences we want.  

To turn these id numbers into something useful, we need ESUMMARY.  The following URL gives us the sequence name, the organism name, and some human-readable accession numbers for a nuccore id number 17893::

    http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=nuccore&id=17893

NCBI, aware that people don't usually want only one summary at a time, lets us query all of them at once:

    summary = requests.get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=nuccore&id=32656,17893,16688,14467,10842")

So we can build the summary url from the idlist using ",".join():

     print("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=nuccore&id=" + ",".join(idlist))

And get it from NCBI

     summary = requests.get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=nuccore&id=" + ",".join(idlist)) 


Let us examine this in our browser:

    http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi?db=nuccore&id=32656,17893,16688,14467,10842

There is valuable data in there, but it's tied up in XML.    We can get it out.

    <eSummaryResult>
    <ERROR>Otherdb uid="16688" db="nucest" term="16688"</ERROR>
    /<DocSum>
    <Id>32656</Id>
    <Item Name="Caption" Type="String">X02955</Item>
    <Item Name="Title" Type="String">Human interferon alpha gene IFN-alpha 4b</Item>
    <Item Name="Extra" Type="String">gi|32656|emb|X02955.1|[32656]</Item>
    <Item Name="Gi" Type="Integer">32656</Item>
    <Item Name="CreateDate" Type="String">1986/01/28</Item>
    <Item Name="UpdateDate" Type="String">2005/04/18</Item>
    <Item Name="Flags" Type="Integer">0</Item>
    <Item Name="TaxId" Type="Integer">9606</Item>
    <Item Name="Length" Type="Integer">2022</Item>
    <Item Name="Status" Type="String">live</Item>
    <Item Name="ReplacedBy" Type="String"/>
    <Item Name="Comment" Type="String">  </Item>
    </DocSum>
    <DocSum>
    <Id>17893</Id>
    <Item Name="Caption" Type="String">X55275</Item>
    <Item Name="Title" Type="String">B.oleracea SLG-13 gene for S-locus glycoprotein</Item>
    <Item Name="Extra" Type="String">gi|17893|emb|X55275.1|[17893]</Item>

Look at the structure of the data.  There are DocSum tags that contain an Id tag and a bunch of Item tags.  
The text of the item tags has the data and the attributes of the item tags have the field names.

So to go at this we want to iterate through the DocSums, then for each DocSum iterate through all the item tags.

First, parse the summary XML with ET:

     sumroot = ET.fromstring(summary.text)

Now iterate over the DocSum elements:

    for docsum in sumroot.iter("DocSum"):
         print(docsum)

This iterates over five Docsum elements, so far so good.

So now docsum is defined -- as the last docsum in the XML--so I can try iterating over its Item tags:

    for item in docsum.iter("Item"):
         print(item.tag, item.attrib, item.text)

This shows us what we saw in the browser--the field names are in the Name element of the attributes and the data is in the .text attribute.
Let us turn this into a dict:

    itemdict = {}
    for item in docsum.iter("Item"):
       itemdict[item.attrib["Name"]] = item.text

And now we have a dict that contains all the data fields the for one of the DocSums.
To get all the docsums, let us create a hash of hashes::

    docsumdata = {}
    for docsum in sumroot.iter("DocSum"):
        docsumid = docsum.iter("Id").next().text
        docsumdata[docsumid] ={}
        for item in docsum.iter("Item"):
            if item.text != None:
                docsumdata[docsumid][item.attrib["Name"]] = item.text

Now all the data is in a hash of hashes.  Let us construct a list of all the keys to all the fields:

    keylist = set()
    for docsumid in docsumdata.keys():
        for key in docsumdata[docsumid].keys():
            keylist.add(key)
   print("\t".join(keylist))

And now I can get all the fields for each of the docsumids:

    for docsumid in docsumdata.keys():
        fields = [docsumdata[docsumid][k] for k in keylist] 
        print(docsumid + "\t" + "\t".join(fields))

Now we have accession numbers, time to download the datasets.

    for docsumid in docsumdata.keys():
        print(docsumdata[docsumid]["AccessionVersion"] + "\t" + docsumdata[docsumid]["Title"])

I'll look at the last four, partial 16S genes apparently from snakes.

targets = [ "MG012885.1", "MG012884.1", "MG012887.1", "MG012886.1"]

I can download the sequences with a query like 

http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&rettype=fasta&id=CP001226.1

This snippet makes a query like this for every one of the IDs in targets and saves the NCBI API's response to a file 
with name ACCESSION.fna

    for target in targets:
        fastasequence = requests.get("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&rettype=fasta&id=" + target).text
        print("Retrieving " + target + ".fna")
        with open(target + ".fna", "w") as fh:
            fh.write(fastasequence)

## Comment on Genbank files

Genbank files have a special structure to them.  You can look at it and figure it out for the most part, or read about it in detail [here](http://www.ncbi.nlm.nih.gov/Sitemap/samplerecord.html).  To find out if your downloaded Genbank files contain 16S rRNA genes, I like to run the following command::

    grep 16S *gbk

This should look somewhat familiar from your shell lesson, but basically we're looking for any lines that contain the character "16S" in any Genbank file we've downloaded.  Note that you'll have to run this in the directory where you downloaded these files.

The structure of the Genbank file allows you to identify 16S genes.  For example, ::

         rRNA        9258..10759
                     /gene="rrs"
                     /locus_tag="CLK_3816"
                     /product="16S ribosomal RNA"
                     /db_xref="Pathema:CLK_3816"

You could write code to find text like 'rRNA' and '/product="16S ribosomal RNA"', grab the location of the gene, and then go to the FASTA file and grab these sequences.  To make things easy, there are existing packages to parse Genbank files.  I have the most experience with BioPython.  To begin with, let's just use BioPython to help us with our program.  

First, we'll have to install BioPython in your container if it didn't come already installed.  It's two commands in ubuntu: 

    apt-get update
    apt-get install -y python-biopython

Fan Yang (Iowa State University) and Adina Howe  wrote a script to extract 16S rRNA sequences from Genbank files, [here](https://github.com/adina/scripts-for-ngs/blob/master/parse-genbank.py).  It basically searches for text strings in the Genbank structure that is appropriate for these particular genes.  You can read more about BioPython [here](http://biopython.org/DIST/docs/tutorial/Tutorial.html) and its Genbank parser [here](http://biopython.org/DIST/docs/api/Bio.GenBank-module.html).  In this script, we are looking for an "rRNA" feature and looking for specific text in its "/product" line.  If this is true, we go through the genome sequence and extract the coordinates of these genes, providing the specific gene sequence.

To run this script on the Genbank file for CP000962.  Note make sure you are in the right directory for both the program and the files::

    python parse-genbank.py genbank-files/CP000962.gbk > genbank-files/CP000962.gbk.16S.fa

The resulting output file contains all 16S rRNA genes from the given Genbank file.

To run this for multiple files, I use a shell for loop::

    for x in genbank-files/*; do python parse-genbank.py $x > $x.16S.fa; done

There are multiple ways to get this done -- but this is how I like to do it.  Now, you can figure out how you like to do it.

And there you have it, you can now pretty much automatically grab 16S rRNA genes from any number of genomes in NCBI databases.

