# Univeristy of Tennessee Center for Environmental Biotechnology, Bioinformatics Resource Center 2018
# MG-RAST: Exploring and Comparing samples using the GUI

General goals for this tutorial: 

Part 1: Find samples and studies and make sample sets 

Part 2: Construct analyses 

Part 3: Observe general trends 

Part 4: Fish for interesting differences 

Part 5: Test hypotheses 

The format of this tutorial varies a bit from classical "programming" format

    text in these nests represent specific actions for the reader to perform


## Part 1: Finding samples and making sets

Go to the magnifying glass to start a search.  Initially, you will see all public samples in the system.  This includes amplicon libraries, shotgun metagenomes, and metatranscriptomes.  We are only going to focus on aquatic shotgun metagenomes for now, so let’s start to narrow down the available samples. 

    Refine Search > Field:seqtype > "shotgun" 

We now have access to 14,000 samples representing shotgun metagenome sets. 

    Refine Search > Environmental_package > "water" 

Now we are down to 412 samples, all of which should be aquatic shotgun metagenomes 

#### Exercise 1: learn how to filter data sets.  
1. Filter the list down to amplicon libraries from water 
2. Find a sample that represents a "metatranscriptome" from Antarctica 
3. Find a sample that represents an "amplicon library" from a termite gut 

Now we can see that samples are grouped under "studies". Unfortunately, the majority of public studies have not included much in the way of metadata aside from sample location and some general information. I know of a particular sample which is compact and has depth recorded; study name "PavinOme" 

    Search (using the general search at the top or via the "study_ID filter" for "pavinome" 
    
#### Exercise 2: locating studies by their name
1. Find the "pavinome" data set using the general search feature instead of by applying a filter
2. Open the "PavinOme" study page 

General description of PavinOme: What is this dataset? There is no clear information on the study description page. We can search via the PI for publications or we can contact the PI directly with questions.  Note that the PI/subitter did have the option of fully explaining their study here.

Let's explore information at the study page 

    Click "pavinome" 

We can search the map to see where the samples came via the googlemaps plugin at the upper right.

Examine the currently visible metadata; There are 4 depths with two samples from each, one assembled and one unassembled.  For our exploration, we are going to look at what the differences between surface and deepest samples are. 

    Click the "create collection" button.  
    
We'll need this set later! This will save this study to your account so you can pull it up easily later without going throught the search pipeline again.

#### Exercise 3: creating sets 
1. Find another study that interests you and create a set of your own. 

Let's explore the sample information page. 

    Click on the "4m_reads" sample name from the PavinOme study page 

On this page we have a great deal of QC information. We can also directly download certain classes of information (although this is not the ideal place to do it).  This is a potential exit point if you plan to analyze data with your own pipelines; The heavy computational lifting has been done, the QC and annotation.  For example if you're curious only about sequences predicted to be of a particular phylogenetic group (Mycoplasma), you can pull it out here as long as it is one of the major groups (we can get at this data more efficiently elsewhere though). 

We can also save these overview figures via the cloud-shaped icon. 

This is also an easy way to see the metadata that the author provided (scroll to the bottom of the page). This one has a coded depth field, which is very nice for us. 

#### Exercise 4: Examining sample information 
First, open up a sample from your own study of interest 
1. How many sequences failed QC? 
2. What percentage of samples were labelled as "unknown" in sequence breakdown? 
3. What do you think these "unknown" sequences could represent?   
4. Download a pie chart representing phylum-level phylogeny breakdown for your sample. 
5. Download a species rarefaction curve for your sample 
6. Why would a rarefaction curve matter in this context?

## Part 2: Creating an Analysis

Now lets start doing some comparisons via the Analysis page.  This is the real meat of the MG-RAST GUI; there is a lot more there than you might realize!

    Go to the "analysis" button at the top. 

Under "available databases" you can see all the annotation databases that are available. Consider what your goals are.  Large-scale comparisons?  Function or phylogeny?  Interested in particular genes, pathways, or organisms?  Just fishing?

MG-RAST uses many different databases. All of the data is there, i.e. annotations at different confidence values.  The two "default" databases are RefSeq and Subsystems.  RefSeq is a phylogeny database, especially useful for shotgun metagemics, while subsystems is a very highly curated functional database (which I'm not so familiar with).  I'm familiar with the KO database, so I'm going to swap out subsystems for KO (i.e. KEGG, another functional database)

    From the "collections" dropdown menu, select PavinOme 

We will be making a request from the MG-RAST system to retrieve certain databases for certain samples.  From there on out, analysis will be performed using your own computer.  These are enormous databases; for the sake of time, we are just going to look at two samples: unassembled 4m and 80m samples. 

    Remove the un-needed samples. 

    Click the green check mark. 

    Open the analysis page via the big bar chart icon at the bottom once you recieve the "Ready" notification

## Part 3: Observing General Trends

RefSeq is a way to get at phylogeny. The stacked bar chart will reflect what database you select from the dropdown menu on the right.

    Pick RefSeq (if nothing is displayed, switch between KO and RefSeq a couple of times, it will wake up).

Now you'll see that you probably cannot see the full sample names; they are cut off.  What you view is locally customizable; change the X-axis value until you can see the names.  Feel free to play around here.   

Next, we don't care about sample names, we care about depth. We are lucky that owners coded the depth in! 

    Adjust graph data > data label > depth

We are currenlty looking at Domain level phylogeny as annotated by RefSeq.  Right away we can see that the deeper sample has much more Archaea. 

    Pick "phylum" from the dropdown menu 

Obvious differences; 

* Three groups far more dominant at surface: Actinobacteria, verrucomicrobia, cyanobacteria

* Two are enhanced in the deep sample: Proteobacteria and firmicutes 

Quickly we get overwhelmed!  Lets switch to a Matrix view instead of stacked bar chart. Here we can look for any more subtle differences 

    Select the "matrix" icon from the lower right

#### Exercise 5: Create a Matrix view of phylum level RefSeq 
Make sure that you can see the entire chart with depth as the sample label 
Work with the "layout" and "adjust graph label" settings 

## Part 4: Fishing for Interesting Differences

"Filtering" is the main tool here for digging down an focusing your searches. Let's take a closer look at the Archaea; to do this, we want to "filter" out everything else 

    Click the little filter icon on the right beneath the database dropdown menus (reads "filter" on hover) 

    Select RefSeq > Domain from the dropdown and type "archaea" in the search field

    On the upper left under "adjust graph data" click off normalization 

Now we have only the Archaea.  Lets dig down deeper to see which groups are enriched at depth.  Visualize at Class level, Order, and so on. It is quite diverse! Lets focus down on the dominant Order, Methanomicrobiales.

    Make a new filter just for that Order (Methanomicrobiales), as detected by RefSeq 

Note that the Archaea filter is still allowing all Archaea through!   

    Delete the Archaea filter. 

Now we ONLY see samples from Order Methanomicrobiales.  Why does this matter?  Now we can take a look at what these guys are doing! 

### Exploring function via the Kegg Mapper plugin 

Lets see what Methanomicrobialies, a drastically enriched group at 80m, are doing down there.   

    Switch the general view to KO (leave the RefSeq filter in place) 

At this stage, it can be difficult to just fish/browse, but let's try. 

    Go to the Plugin – Kegg maps feature via the "plugins" tab at the lower right

We see right away that they have a central glycolysis pathway. Let's check some other general biological pathways to see if the usual suspects are there:

    Take a look at Ribosome map (03010). LSU and many SSU proteins are there. 

    Find the oxidative phosphorylation map:  F-type ATPase is in there (as usual) 
    
Now lets fish around among some pathways that might be relevant in deep water (is it anaerobic?  who knows!?  Maybe we can deduce that from the genes present)

Lets look at some particular fuctions/pathways (it can take some time to locate the maps, be patient);  

* Sulfur metabolsm map?  Not much there. 

* Nitrogen map: We can see N2 fixation and ammonia assimilation 

* Carbon fixation map?  Reductive acetyl-CoA pathway is present. 

* Methanogenesis:  Open the "folate biosynthesis" map.  Fairly complete pathway for methanogenesis is present! (lower left)

We can download the results on a per-sample annotation basis from here also. Essentially this is a filtered database, give it a try!

#### Exercise 6: Basic question, do the Methanomicrobiales make their own corrinoid proteins? These are required cofactors for methanogenic metabolism. 

1. Check the "Porphyrin and Chlorophyll metabolism" map. )Corrinoid biosynthesis includes many enzymes, can be found on the left side of the map). 
2. Mouse over the colored boxes: which sample has more predicted features within this map?   
3. Try downloading this data. 

So it looks like we have a general description of what the Methanomicrobales are doing.  They can fix nitrogen, fix their own carbon, and perform methanogenesis. 

### Exploring community-wide functions 

Let's see if this methanogenesis scheme holds up for the general community (more methanognesis-related functions in the deep sample; are they found only in Methanomicrobiales or in other organisms as well?). 

    First, go back to a high level view first (RefSeq Domain level) 

    Then delete your filters (we want to look at everything!) 

Let's focus on one central aspect of methanogenesis, the final (and unique) step of Methyl-CoM reductase. This is a highly conserved enzyme which catalyzes the final release of methane (if my memory serves correct, I didn't check the literature so let's wing it!)

    Make a new filter, KO function > "methyl coenzyme M reductase system" (it should autocomplete for you)

At this step you can easily export the sequences if you want to work with them elsewhere.  Simlpy click on the Export tab at the lower right and export as fasta (I found that when I use Safari, I get a nonsensical file here, but it works fine in Chrome).

We can see right away that there are 64 hits at 80m and 0 hits at 4m! Let's get an idea of who else is responsible for the methanogenesis 

    Make sure your "methyl coenzyme M reductase system" filter is in place. 

At this point you should see only the CoM reductase.

    Now switch the view to RefSeq and explore the different taxonomic levels 

Remember that these are only "guesses"; the taxonomy represents the best matches in the refseq database, which is limited by... what? 


## Part 5: Testing Hypotheses

This is just an exercise to simulate how to address a very focused hypotheiss.  Let's say I have a general hypothesis that since this is a deep and very still lake, there will be few photosynthesizers at 80m as compared to the surface.  How to address this?  Well, I have to decide which annotations (genes or phylogenies) will best represent "photosynthesizers".  I dug a bit into the literature to locate a widely conserved gene for chlorophyll synthesis and found that KEGG has a single KO group that represents it.  Is this the ultimate solution?  No, but its a start!

#### Exercise 7: Filtering out subsets of data 
1. Remove all existing filters and create a new filter (KO function) for "ChlB", a widely-distributed chlorophyll synthesis gene. 
2. Click off "normalize" at the top; is there a vertical trend?
3. Download the gene fragments! (why did I say "gene fragments" and not "genes"?) 
4. With the filter in place, examine the phylogenetic distrubution of the chlB gene fragments. 
5. View with and without normalization 
6. Download some figures (stacked bar charts for example)
