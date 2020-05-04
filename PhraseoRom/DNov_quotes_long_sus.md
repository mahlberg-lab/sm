-   [Data](#data)
    -   [Get the corp\_text objects](#get-the-corp_text-objects)
    -   [Create a data.table where each column is a set of types for the
        tokens](#create-a-data.table-where-each-column-is-a-set-of-types-for-the-tokens)
    -   [Corpus size](#corpus-size)
-   [Unmatched tokens](#unmatched-tokens)
-   [Analysis: 1. Comparing manually chosen, specific body part terms +
    “lexical” collocates in DNov quotes vs. long
    suspensions](#analysis-1.-comparing-manually-chosen-specific-body-part-terms-lexical-collocates-in-dnov-quotes-vs.-long-suspensions)
    -   [Figure 1: Plot of specific, manually chosen body part terms
        +“lexical” collocates in DNov quotes vs. long
        suspensions](#figure-1-plot-of-specific-manually-chosen-body-part-terms-lexical-collocates-in-dnov-quotes-vs.-long-suspensions)
        -   [Concordances: Quotes](#concordances-quotes)
        -   [Concordances: Long
            suspensions](#concordances-long-suspensions)
-   [Analysis: 2. Comparing B1 + all “lexical” collocates in DNov quotes
    vs. long
    suspensions](#analysis-2.-comparing-b1-all-lexical-collocates-in-dnov-quotes-vs.-long-suspensions)
    -   [Number of (lexical) types & tokens in B1 &
        examples](#number-of-lexical-types-tokens-in-b1-examples)
        -   [Quotes](#quotes)
        -   [Long suspensions](#long-suspensions)
    -   [Concordances of “lexical”
        collocates](#concordances-of-lexical-collocates)
        -   [Concordances: Quotes](#concordances-quotes-1)
        -   [Concordances: Long
            suspensions](#concordances-long-suspensions-1)
        -   [Figure 2: Plot of B1 +“lexical” collocates in DNov quotes
            vs. long
            suspensions](#figure-2-plot-of-b1-lexical-collocates-in-dnov-quotes-vs.-long-suspensions)
-   [Analysis: 3. Comparing B1 + all semantic types in DNov quotes
    vs. long
    suspensions](#analysis-3.-comparing-b1-all-semantic-types-in-dnov-quotes-vs.-long-suspensions)
    -   [Figure 3: Plot of B1 + “semantic tag collocates” in DNov quotes
        vs. long
        suspensions](#figure-3-plot-of-b1-semantic-tag-collocates-in-dnov-quotes-vs.-long-suspensions)
    -   [Concordances of semantic tag
        collocates](#concordances-of-semantic-tag-collocates)
        -   [Concordances: Long
            suspensions](#concordances-long-suspensions-2)
-   [How this document was generated](#how-this-document-was-generated)

Data
====

Libraries

``` r
library(CorporaCoCo)
library(data.table)
library(stringi)
```

Get the corp\_text objects
--------------------------

``` r
quotes_files <- list.files("./api-output-sem-tagged/DNov/quote_corp_text_objects/", full.names = TRUE)
quotes_objects <- lapply(quotes_files, readRDS)
quotes_text <- corp_text_rbindlist(quotes_objects)

long_sus_files <- list.files("./api-output-sem-tagged/DNov/longsus_corp_text_objects/", full.names = TRUE)
long_sus_objects <- lapply(long_sus_files, readRDS)
long_sus_text <- corp_text_rbindlist(long_sus_objects)
```

Create a data.table where each column is a set of types for the tokens
----------------------------------------------------------------------

The loaded `corp_text` objects have the full semantic tags as the types

semantic\_tags  
keep whole of first tag, but not multipart or lowercase bits
e.g. `A1.1.1+`. Remove \[+-\]? to not keep the plus or minus.

lc\_tokens  
lowercased tokens

``` r
quotes_type_store <- data.frame(
    lc_tokens = tolower(quotes_text$tokens$token),
    semantic_tags = stri_extract_first(quotes_text$tokens$type, regex = "^([A-Z]\\d+(?:\\.\\d+)*[+-]?)"),
    stringsAsFactors = FALSE
)
long_sus_type_store <- data.frame(
    lc_tokens = tolower(long_sus_text$tokens$token),
    semantic_tags = stri_extract_first(long_sus_text$tokens$type, regex = "^([A-Z]\\d+(?:\\.\\d+)*[+-]?)"),
    stringsAsFactors = FALSE
)
```

Corpus size
-----------

Quotes

``` r
#Count tokens without the co-occurrence barriers (i.e. ssubset boundaries) _b_ (NA)
sum(quotes_text$tokens$token!="_b_", na.rm = TRUE)
```

    ## [1] 1424857

Long suspensions

``` r
#Count tokens without the co-occurrence barriers (i.e. ssubset boundaries) _b_ (NA)
sum(long_sus_text$tokens$token!="_b_", na.rm = TRUE)
```

    ## [1] 84536

Unmatched tokens
================

The Z99 tag contains “unmatched” tokens. These can be looked up like
this for the quotes (but take up a lot of space):

``` r
#a <- corp_type_lookup(quotes_text)
#a[type == "Z99"]$tokens
```

And like this for the long suspensions

``` r
#b <- corp_type_lookup(long_sus_text)
# b[type == "Z99"]$tokens
```

Analysis: 1. Comparing manually chosen, specific body part terms + “lexical” collocates in DNov quotes vs. long suspensions
===========================================================================================================================

``` r
quotes_text$tokens$type <- with(quotes_type_store, lc_tokens)
quotes_text$tokens$type[is.na(quotes_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers
long_sus_text$tokens$type <- with(long_sus_type_store, lc_tokens)
long_sus_text$tokens$type[is.na(long_sus_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers

head(quotes_text$tokens, 20)
```

    ##     idx   type start end  token
    ##  1:   1   <NA>    13  15    _b_
    ##  2:   2   <NA>    17  19    _b_
    ##  3:   3   <NA>    21  23    _b_
    ##  4:   4   <NA>    25  27    _b_
    ##  5:   5   <NA>    29  31    _b_
    ##  6:   6 suffer    33  38 Suffer
    ##  7:   7    any    40  42    any
    ##  8:   8  wrong    44  48  wrong
    ##  9:   9   that    50  53   that
    ## 10:  10    can    55  57    can
    ## 11:  11     be    59  60     be
    ## 12:  12   done    62  65   done
    ## 13:  13    you    67  69    you
    ## 14:  14 rather    71  76 rather
    ## 15:  15   than    78  81   than
    ## 16:  16   come    83  86   come
    ## 17:  17   here    88  91   here
    ## 18:  18   <NA>    93  95    _b_
    ## 19:  19   <NA>    97  99    _b_
    ## 20:  20   <NA>   101 103    _b_

``` r
head(long_sus_text$tokens, 20)
```

    ##     idx       type start end      token
    ##  1:   1       <NA>    13  15        _b_
    ##  2:   2       <NA>    17  19        _b_
    ##  3:   3       <NA>    21  23        _b_
    ##  4:   4       <NA>    25  27        _b_
    ##  5:   5       <NA>    29  31        _b_
    ##  6:   6   proceeds    33  40   proceeds
    ##  7:   7        the    42  44        the
    ##  8:   8 chancellor    46  55 Chancellor
    ##  9:   9      still    58  62      still
    ## 10:  10         on    64  65         on
    ## 11:  11   jarndyce    67  74   Jarndyce
    ## 12:  12        and    76  78        and
    ## 13:  13   jarndyce    80  87   Jarndyce
    ## 14:  14       <NA>    89  91        _b_
    ## 15:  15       <NA>    93  95        _b_
    ## 16:  16       <NA>    97  99        _b_
    ## 17:  17       <NA>   101 103        _b_
    ## 18:  18       <NA>   105 107        _b_
    ## 19:  19   proceeds   109 116   proceeds
    ## 20:  20        the   118 120        the

``` r
# the set of nodes and collocates we are interested in
nodes <- c('eye', 'eyes', 'forehead', 'hand', 'hands', 'head', 'shoulder')
nodes
```

    ## [1] "eye"      "eyes"     "forehead" "hand"     "hands"    "head"     "shoulder"

``` r
#co-occurrences
quotes_surface <- corp_surface(quotes_text, span = "5LR", nodes = nodes)
long_sus_surface <- corp_surface(long_sus_text, span = "5LR", nodes = nodes)

# compare quotes vs. long suspensions
results <- corp_coco(quotes_surface, long_sus_surface, nodes = nodes)
```

Figure 1: Plot of specific, manually chosen body part terms +“lexical” collocates in DNov quotes vs. long suspensions
---------------------------------------------------------------------------------------------------------------------

``` r
plot(results)
```

![](DNov_quotes_long_sus_files/figure-markdown_github/body_parts_DNov_quotes_vs_long_sus_lexical-1.png)

### Concordances: Quotes

``` r
# your
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("your"), context = 0)
y
```

    ## [  1]               --- be not visited upon *your*   head  , according to what is written. ---       
    ## [  2]           --- myself, and entirely in *your*   hands  ! I only ask to be ---                   
    ## [  3]               --- of life. Blest with *your*   hand  , what means might I not ---              
    ## [  4]           --- fifty times over ! Open *your*   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [  5]            --- graciously let me kiss *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [  6]              --- *your* remedy in *your* own   hands . Ada, it is better for ---               
    ## [  7]                 --- very glad to take *your*   hand  , sir. You are a good ---                 
    ## [  8]                  --- _b_ Do n't shake *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [  9]         --- suppose you never clapped *your*   eyes   on the country, Phil _b_ ---             
    ## [ 10]              --- So you never clapped *your*   eyes   upon the country -- marshes ---          
    ## [ 11]           --- entirely in *your* ladyship 's   hands . If *your* ladyship was to ---           
    ## [ 12]                 --- and touch me with *your*   hand  . For I can not see ---                   
    ## [ 13]             --- whoever you are, with *your*   head   tied up in a bundle. ---                 
    ## [ 14]               --- be not visited upon *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 15]             --- *your* interests with a cool   head  , and I can quite understand ---          
    ## [ 16]             --- long have appeared in *your*   eyes   the natural person to make ---           
    ## [ 17]                   --- _b_ _b_ give me *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 18]                    --- Let me look at *your* forehead _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 19]                  --- me catch hold of *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 20]                --- _b_ _b_ just throw *your*    eye   across here at *your* present ---        
    ## [ 21]                 --- sake, and can put *your*   hand   upon the plough and never ---            
    ## [ 22]                --- do n't you trouble *your*   head   about the murder. That 's ---            
    ## [ 23]            --- moment has passed over *your*   head  , to go and sit down ---                  
    ## [ 24]                 --- quiet a tongue in *your*   head  . In short, the less you ---              
    ## [ 25]               --- that looks bad. Run *your*    eye   over it. Here it is ---                  
    ## [ 26]                 --- crown in *your* t' other   hand  . One, two, three, and there ---          
    ## [ 27]                   --- two or three in *your*    eye  , Mr. Jones, and you have ---             
    ## [ 28] --- possessing *your* attractions, shuts her   eyes   (and sparklers too), and goes ---        
    ## [ 29]             --- Varden. You may shake *your*   head  , father, but I say no ---                
    ## [ 30]             --- have rendered them in *your*   eyes   visible objects for my suit. ---         
    ## [ 31]                     --- You had it in *your*   hand   at the door. Give it ---                 
    ## [ 32]                --- the sake of *your* bright   eyes  . Strike again, mistress. Do. Ha ---      
    ## [ 33]                  --- take that in *your* own   hand  , sir, and cast *your* eye ---            
    ## [ 34]               --- hand, sir, and cast *your*    eye   on the right-hand corner _b_ ---         
    ## [ 35]             --- pursue his claim upon *your*   hand  ; in which he offers, voluntarily ---     
    ## [ 36]                 --- second I 'll have *your*   head   under the biler. How dare ---            
    ## [ 37]              --- lantern, and give me *your*   hand  . The stairs are crooked and ---          
    ## [ 38]         --- while Englishmen have hearts and   hands  " -- and waved *your* own ---            
    ## [ 39]            --- not a-going to trouble *your*   head   to-night, or my lord 's ---              
    ## [ 40]                 --- his ? Do but cast *your*    eye   upon it. There 's a ---                  
    ## [ 41]                  --- _b_ _b_ Is *your* other   hand   at all cleaner ? Much the ---            
    ## [ 42]             --- n't hate anybody. Dry *your*   eyes   and make yourself agreeable, in ---      
    ## [ 43]                --- you need n't shake *your*   head  , sir. It was a wild- ---                 
    ## [ 44]                         --- Here is a man to   head   *your* No-Popery cry ! For shame. ---    
    ## [ 45]               --- *your* deed, if not *your*   hand   -- I know you _b_ ---                    
    ## [ 46]           --- misery and suffering on *your*   head   and mine as few have ---                 
    ## [ 47]                   --- _b_ _b_ _b_ Put *your*   hand   in mine. You 're blind ---               
    ## [ 48]                   --- had a roof over *your*   head  ; he has always been an ---               
    ## [ 49]                   --- _b_ _b_ _b_ Lay *your*   hand   upon my sleeve _b_ _b_ ---               
    ## [ 50]                 --- manifest in my having no   eyes  , than in *your* having two ? ---         
    ## [ 51]                --- recruit -- give me *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 52]                 --- where you can lay *your*   hand   upon it in an instant. ---               
    ## [ 53]                  --- ay, you may toss *your*   head   -- you would ! Kill the ---              
    ## [ 54]                  --- pick it with *your* own   hands  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 55]                   --- _b_ _b_ Give me *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 56]               --- you mean by rolling *your*   eyes   and shaking *your* fist at ---           
    ## [ 57]          --- Hush ! " and turned away *your*   head  . Why did you do so ? ---                 
    ## [ 58]                 --- I 'd have crushed *your*   head   against it; I would _b_ ---              
    ## [ 59]           --- Barnaby, what care we ? *Your*   hand   ! They do well to put ---                
    ## [ 60]                --- this morning -- is *your*   hand   in ? How does the breakfast ---          
    ## [ 61]                 --- 'll suit you. Try *your*   hand   upon him _b_ _b_ _b_ ---                 
    ## [ 62]                --- 's put marriage in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 63]              --- what put marriage in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 64]              --- that in *your* silly little   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 65]                  --- such a person in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 66]                   --- _b_ _b_ give me *your*   hand  , for *your* common sense is ---          
    ## [ 67]                       --- sure as you have a   head   upon *your* shoulders, I 'll ---         
    ## [ 68]                     --- on the top of *your*   head   in twelve months, but for ---            
    ## [ 69]        --- journey rather fast. - Put *your*   hand   into the breast pocket of ---            
    ## [ 70]                    --- be able to get *your*   eyes   back _b_ _b_ _b_ _b_ ---                 
    ## [ 71]                      --- in this world by my   eyes   again ! 'Dear, if *your* heart ---       
    ## [ 72]            --- that another letter in *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 73]              --- that you should lift *your*   hand   against a person that you ---            
    ## [ 74]                     --- _b_ may be in *your*   hands . I trust it confidently to ---           
    ## [ 75]                 --- water from *your* son 's   hand   now, you cherish a terrible ---          
    ## [ 76]               --- all speed, and hide *your*   head   among those excellent people who ---     
    ## [ 77]                  --- to the favour of *your*   hand  , I am sanguine as to ---                 
    ## [ 78]                    --- _b_ _b_ and if *your*   head   is human, I 'll break ---                
    ## [ 79]     --- into danger, through carrying *your*   head   so high. Better be umble, ---            
    ## [ 80]                       --- I could n't lay my   hand   upon *your* name, really _b_ ---         
    ## [ 81]                  --- at me. Only open *your*   eyes   to show me that you ---                  
    ## [ 82]                   --- you do n't shut *your*   eyes   this minute, I 'll call ---              
    ## [ 83]           --- to Captain Cuttle. Keep *your*    eye   upon my Uncle, will you, ---             
    ## [ 84]                   --- _b_ _b_ _b_ Lay *your*   head   well to the wind, and ---                
    ## [ 85]                     --- _b_ is to lay *your*   head   well to the wind, and ---                
    ## [ 86]                  --- But you only lay *your*   head   well to the wind _b_ ---                 
    ## [ 87]              --- burst some vessel in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 88]            --- strike me sharply; and *your*   hand   is steady, and *your* thrust ---         
    ## [ 89]                --- you may have heard *your*   head   Governor mention my name ? -- ---        
    ## [ 90]      --- own private reckoning, 'till *your*   head   Governor has wore round a ---            
    ## [ 91]                --- And with regard to *your*   head   Governor _b_ _b_ _b_ _b_ ---             
    ## [ 92]    --- beautiful productions are from *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 93]                   --- _b_ or Ill tear *your*   eyes   out _b_ _b_ _b_ _b_ ---                  
    ## [ 94]                       --- that he was at the   head   of all *your* Pa 's ---                  
    ## [ 95]                  --- _b_ _b_ To which *your*   eyes   have been opened, my dear ---            
    ## [ 96]                   --- you -- with *your* own   eyes   -- as you sit there ---                  
    ## [ 97]                  --- and I come here, *your*   head   governor being absent, to ask ---        
    ## [ 98]                    --- to be as *your* right   hand  . My name shall then be ---               
    ## [ 99]               --- dropped a tear upon *your*   hand  , may it wither it up ! ---               
    ## [100]             --- Sorrow and shame upon *your*   head   ! Ruin upon all belonging to ---         
    ## [101]           --- these words, or gladden *your*   eyes   with the sight of his ---                
    ## [102]                   --- which is in *your* own   hands , of giving me no cause ---               
    ## [103]                  --- have you done to *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [104]     --- contaminate the key-hole with *your*    eye  , I 'm packing up and ---                 
    ## [105]                    --- my own -- take *your*   hand   before I go _b_ _b_ ---                  
    ## [106]              --- sake, and lay *your* pretty   head   to the wind _b_ _b_ ---                  
    ## [107]              --- name, and touch this gentle   hand   in token of *your* sisterly ---          
    ## [108]               --- shall put myself in *your*   hands  when the time comes. The ---             
    ## [109]                --- shall see with *your* own   eyes   and hear with *your* own ---             
    ## [110]                   --- so good as cast *your*    eye   over it, Sir _b_ _b_ ---                 
    ## [111]             --- unhappiness, have left us no   head   but *your* brother for this ---          
    ## [112]                --- _b_ _b_ _b_ Remove *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [113]             --- the lightest touch of *your*   hand   makes my blood cold with ---             
    ## [114]                 --- A moment yet. Lay *your*   head   so, dear, that as you ---                
    ## [115]            --- entreating a favour at *your*   hands ; and that I have the ---                 
    ## [116]                 --- for a blessing on *your*   head   ! My own dear Florence, my ---           
    ## [117]            --- strange film come over *your*   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [118]               --- kissed. But give me *your*   hand  , and I 'll blow a ---                    
    ## [119]                    --- Take it in *your* own   hand  . The setting out of the ---              
    ## [120]                --- me those stones in *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [121]                   --- _b_ I 'll smash *your*    eye  , if you do n't look ---                  
    ## [122]                  --- _b_ _b_ _b_ Hold *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [123]                 --- glass to me. Open *your*   hand  , sir. I WILL have it ---                 
    ## [124]                     --- copy of it in *your*   hands . And although Mr. Edwin is ---           
    ## [125]    --- brings tears into *your* affectionate   eyes   even to picture to yourself ---          
    ## [126]             --- that former action of *your*   hands , which I so much dislike ---             
    ## [127]                 --- when you give him *your*   hand  , can only be known to ---                
    ## [128]                      --- _b_ _b_ _b_ _b_ _b_   hand   *your* bundle to me; I ---               
    ## [129]                    --- _b_ _b_ I wish *your*   eyes   were not quite so large ---              
    ## [130]             --- emphasise is, that under the   head   of Pride *your* sister is ---            
    ## [131]               --- room, and will cast *your*    eye   at the second-floor landing window ---   
    ## [132]               --- come ! Used to drop *your*   head  , and sing yourself off like ---          
    ## [133]           --- service, will you throw *your*    eye   over them _b_ _b_ _b_ ---                
    ## [134]              --- _b_ Much higher than *your*   head  , my love _b_ _b_ _b_ ---                 
    ## [135]                  --- which you brought up by   hand  . Hold up *your* head, boy, ---           
    ## [136]                  --- by hand. Hold up *your*   head  , boy, and be for ever ---                
    ## [137]                  --- What put that in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [138]                 --- paper you hold in *your*   hand  . What is it _b_ _b_ ---                  
    ## [139]          --- follow that passage with *your*    eye  , and tell me whether it ---              
    ## [140]                    --- or I 'll knock *your*   head   off ! Do me the favour ---               
    ## [141]                   --- *your* Bill 's in good   hands , I know it. And if ---                   
    ## [142]           --- Jaggers 's powers. Keep *your*    eye   on it _b_ _b_ _b_ ---                    
    ## [143]                  --- you come and put *your*   head   in at the forge window ---               
    ## [144]                 --- Page, and give me *your* shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [145]     --- gradually open *your* round childish   eyes   wider and wider to the ---               
    ## [146]           --- sake, give me *your* blackened   hand   ! - I shall be down soon, ---            
    ## [147]                 --- piece of paper in *your*   hand  . You have got it ? Very ---              
    ## [148]         --- affairs entirely into *your* own   hands , and you will draw from ---              
    ## [149]                  --- Take it in *your* right   hand  . Lord strike you dead on ---             
    ## [150]              --- side, two persons as *your*   eyes   can separate wide; one, the ---          
    ## [151]                --- to be displaced by *your*   hands , than *your* presence and influence ---  
    ## [152]              --- _b_ _b_ Ahoy ! Bless *your*   eyes  , here 's old Bill Barley. ---            
    ## [153]            --- old Bill Barley, bless *your*   eyes  . Here 's old Bill Barley ---             
    ## [154]            --- old Bill Barley, bless *your*   eyes  . Ahoy ! Bless you _b_ _b_ ---            
    ## [155]                    --- I saw him over *your* shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [156]                   --- _b_ _b_ _b_ _b_ *Your*   head   is cool _b_ _b_ _b_ ---                  
    ## [157]              --- chop off that bandaged left   hand   of yours with *your* bandaged ---        
    ## [158]         --- yours with *your* bandaged right   hand  , and then pass the chopper ---           
    ## [159]             --- Please to turn *your* humble    eye   in My direction _b_ _b_ ---              
    ## [160]                   --- _b_ _b_ _b_ _b_ *Your*   hands  are rather cold, Louisa. Are ---         
    ## [161]              --- good, Louisa; for if *your*   head   begins to split as soon ---              
    ## [162]            --- rather receive it from *your*   hand  , than from any other. Therefore, ---     
    ## [163]                  --- _b_ You may hang *your*   head  , to make yourself the more ---           
    ## [164]                --- of you and cooling *your*   head  . Will you see father ? Sissy ---         
    ## [165]         --- hurried now, Rachael, and *your*   hand   is cooler _b_ _b_ _b_ ---                
    ## [166]                  --- has led. Give me *your*   hand  , my poor boy, and may ---                
    ## [167]            --- it. Knowing that *your* clear   head   would propose that alternative, I ---    
    ## [168]               --- ever what came into *your*   head  , Mother ? " " O dear, dear ! " cried --- 
    ## [169]           --- *your* time in clasping *your*   hands  and biting *your* fingers _b_ ---        
    ## [170]      --- Cavalletto ! Wake, boy ! Rub *your*   eyes   and look at me. Not ---                  
    ## [171]          --- _b_ Cavalletto ! Give me *your*   hand  . You know Lagnier, the gentleman. ---    
    ## [172]            --- *your* kind offices at second   hand  , but on the best authority; ---          
    ## [173]                   --- to be better in *your*   eyes   than in anybody 's. And ---              
    ## [174]             --- under the cushion for *your*   head  . Here 's a burial volume. ---            
    ## [175]                  --- _b_ _b_ _b_ take *your*   hands  away. I feel as if ---                   
    ## [176]                    --- to place it in *your*   hands , you will much oblige me ---             
    ## [177]           --- mind *your* glove, John. Shake   hands  with it on. You are ---                  
    ## [178]                  --- means. It 's all *your*    eye  , that is ! Look at *your* ---            
    ## [179]                    --- me the palm of *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [180]              --- _b_ _b_ Putting both *your*   hands  afore *your* face too _b_ ---            
    ## [181]                   --- you cry to ease *your*   head  , Little Mother, let me cry ---           
    ## [182]            --- along o' hearing about *your*   head  , Little Mother. Oh my ! Ai ---           
    ## [183]           --- consequences are on *your* own   head  ), I will say this much: ---              
    ## [184]                   --- bring a tear to *your*   eyes  , dear love _b_ _b_ _b_ ---               
    ## [185]  --- establishment with confidence in *your*   hands , and perhaps you may do ---              
    ## [186]                 --- matter I place in *your*   hands . I authorize you now to ---              
    ## [187]             --- leave. Dear Amy, open *your*   eyes  , that 's a love ! Oh, ---                
    ## [188]         --- put something into *your* little   head  . You wo n't guess what ---               
    ## [189]                   --- _b_ _b_ None of *your*   eyes   at me _b_ _b_ _b_ ---                    
    ## [190]                  --- to assert that you have   eyes   in *your* head, and yet ---              
    ## [191]                  --- you have eyes in *your*   head  , and yet ask me what ---                 
    ## [192]                 --- You make one bite *your*   head   off, when one wants to ---               
    ## [193]                 --- that. Ha. Give me *your*   hand  , Young John, give me *your* ---          
    ## [194]               --- Young John, give me *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [195]            --- *your* pardon. It gladdens my   eyes   to see you again; that ---               
    ## [196]               --- success now. I kiss *your*   hands . Madame, I am a gentleman (---           
    ## [197]                --- with the candle in *your*   hand  , and hitched my apron off ---            
    ## [198]              --- n't care for *your* present   eyes  . Now, I am coming to ---                 
    ## [199]                  --- _b_ _b_ _b_ keep *your*   eyes   open at somebody else, for ---           
    ## [200]                --- my sweet nurse, in *your*   hands , and I well know they ---                
    ## [201]                 --- the fire with *your* own   hand  , just as it is, my ---                   
    ## [202]                 --- now saw -- what ! *your*    eye   lightens when I talk of ---              
    ## [203]                  --- -- you shall try *your*   hand   on these proposals for a ---             
    ## [204]               --- None. Give me *your* other   hand  , Mrs Todgers _b_ _b_ _b_ ---             
    ## [205]                   --- _b_ I am afraid *your*   head   is turned, you silly thing ---           
    ## [206]             --- HE renounce ME ! Cast *your*   eyes   on the Renouncer, Pinch, and ---         
    ## [207]                  --- do not hang down *your*   head  , my dear, for I need ---                 
    ## [208]              --- upon the ground with *your*   head   to leeward then _b_ _b_ ---              
    ## [209]               --- with yellow soap in *your*    eye  , young man _b_ _b_ _b_ ---               
    ## [210]                   --- _b_ _b_ Give me *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [211]                 --- What do you think *your*   eyes   was made for -- eh ? ---                 
    ## [212]              --- You need n't trouble *your*   head   about ME _b_ _b_ _b_ ---                 
    ## [213]           --- out, a-catching cold in *your*   head  . I 'll wake him _b_ ---                  
    ## [214]                  --- you 're wrong in *your*   head   and when you 're in ---                  
    ## [215]                   --- in. Let me kiss *your*   hand   for all *your* goodness to ---           
    ## [216]       --- objection to *your* kissing *your*   hand   to him, my dear _b_ ---                  
    ## [217]                   --- _b_ You held up *your*   head   last night. You 're coming ---           
    ## [218]              --- a companion. Hold up *your*   head  . There ! Now we go out ---               
    ## [219]                    --- what put it in *your*   head  . I never had much in ---                 
    ## [220]                 --- *your* being such a good   hand   at a secret _b_ _b_ ---                  
    ## [221]               --- knock. Will you put *your*   head   out of window, and tell ---              
    ## [222]                      --- it is all in *your*   hands . Ecod ! what with one of ---             
    ## [223]           --- take it into *your* honourable   head   to go abroad with the ---                
    ## [224]                --- _b_ Where you have *your*   hand   now, hey _b_ _b_ _b_ ---                 
    ## [225]                 --- well have *your* note of   hand   for that extra capital. That ---         
    ## [226]                 --- you can, and wash *your*   hands  of it by a plain ---                     
    ## [227]                   --- _b_ _b_ _b_ Put *your*   hand   in my pocket. Here ! The ---             
    ## [228]                  --- _b_ _b_ _b_ Keep *your*    eye   upon the back, one of ---                
    ## [229]                   --- _b_ _b_ give me *your*   hand  . We are brothers, Tom _b_ ---            
    ## [230]             --- heart burst, and *your* very   eyes   come out of *your* head ---              
    ## [231]                  --- eyes come out of *your*   head   with crying, what is it ? ---            
    ## [232]                   --- _b_ You 'll cry *your*   eyes   out, when I 'm gone; ---                 
    ## [233]                   --- _b_ Do you want *your*   head   broke in a fresh place, ---              
    ## [234]             --- fall heavily upon *your* own   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [235]                   --- _b_ _b_ Give me *your*   hand  , my worthy friend _b_ _b_ ---            
    ## [236]                  --- But you must dry *your*   eyes   first, and compose yourself. Let ---     
    ## [237]            --- yourself. Let me raise *your*   head  . There -- there _b_ _b_ ---              
    ## [238]               --- cheek is paler, and *your*    eye   more sunk. Indeed I can ---              
    ## [239]             --- such trouble. Give me *your*   hand  . My heart is linked to ---               
    ## [240]               --- some deep scheme in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [241]       --- manner, juvenile tragedy in *your*    eye  , and touch-and-go farce in *your* ---    
    ## [242]             --- raising the pistol to *your*   head  , a clock strikes -- ten ---              
    ## [243]             --- The pistol falls from *your*   hand   -- you are overcome -- ---               
    ## [244]                --- bran, and sit with *your*   head   in it for twenty minutes ---             
    ## [245]                     --- I do n't mean *your*   head   -- *your* feet. It 's ---                
    ## [246]              --- _b_ Will you unclasp *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [247]            --- to bring misfortune on *your*   head  ; that it was a trial ---                 
    ## [248]                 --- I could heap upon *your*   head   which would carry with them ---          
    ## [249]                 --- _b_ _b_ Then take *your*   hands  out of *your* pockets, and ---           
    ## [250]                   --- old man; and if *your*   hand   placed me in the grave, ---              
    ## [251]                   --- _b_ _b_ give me *your*   hand  , sir. This is *your* birthday. ---       
    ## [252]                   --- the very top of *your*   head   like a blue-coat boy. You ---            
    ## [253]                 --- you bless me with *your*   hand   and heart, you can apply ---             
    ## [254]                    --- hurt a hair of *your*   head  , or the boy 's head, ---                 
    ## [255]                      --- head, or the boy 's   head  , or *your* mother 's head, ---           
    ## [256]                --- head, or *your* mother 's   head  , or *your* sister 's head. ---           
    ## [257]                --- head, or *your* sister 's   head  . I have said it, brother ---             
    ## [258]             --- Miss Madeline, I kiss *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [259]         --- fault. Madeline, my love, *your*   hand   here _b_ _b_ _b_ _b_ ---                 
    ## [260]                 --- are about to give *your*   hand  , some of his deeds you ---               
    ## [261]              --- *your* back, or with *your*   head   hanging over the bedside, or ---         
    ## [262]                  --- _b_ If you value *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [263]    --- discovery are thickening about *your*   head  ; that the structures you have ---        
    ## [264]                   --- HE ask mercy at *your*   hands  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [265]                --- 's the matter with *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [266]               --- had them bellows on *your*   head  . It 's all owing to ---                  
    ## [267]              --- IS occupied. Give me *your*   hand  , sir; it is occupied by ---              
    ## [268]             --- have *your* sister 's little   hand  , sir, if she had refused ---             
    ## [269]                    --- _b_ I 'll tear *your*   eyes   out _b_ _b_ _b_ _b_ ---                  
    ## [270]                 --- nail, I 'll pinch *your*   eyes  , if you talk to me ---                   
    ## [271]             --- the wharf. Stand upon *your*   head   agin, and I 'll cut ---                  
    ## [272]                 --- on *your* simple note of   hand  , if I had n't unexpectedly ---           
    ## [273]               --- *your* way. Give me *your*   hand   -- jump up, master _b_ ---               
    ## [274]                  --- back. If you let *your*   hand   tremble so, we can never ---             
    ## [275]              --- wink, and choke, and *your*   eyes   water, and *your* breath come ---        
    ## [276]               --- brought about. There 's my   hand   upon it; I am *your* ---                 
    ## [277]              --- been putting that in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [278]                --- *your* side. Let 's shake   hands  again, Fred _b_ _b_ _b_ ---              
    ## [279]                --- snap him up before *your*   eyes  , he will _b_ _b_ _b_ ---                 
    ## [280]                 --- _b_ _b_ _b_ Bless *your*   eyes  , how I love you _b_ ---                  
    ## [281]                  --- _b_ Then give me *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [282]                  --- they the work of *your*   hands  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [283]                 --- nay, do n't shake *your*   head   and smile so sadly _b_ ---               
    ## [284]                   --- _b_ _b_ Give me *your*   hand   while you throw back the ---             
    ## [285]              --- particular and should go by   hand  . Charge the office with *your* ---       
    ## [286]                 --- little face that ever my   eyes   beheld. I remember *your* coming ---     
    ## [287]             --- have you been cooling *your*    eye   there _b_ _b_ _b_ _b_ ---                
    ## [288]          --- constant habit of airing *your*    eye   at keyholes, to know all ---             
    ## [289]           --- n't stand there shaking *your*   head   and showing *your* teeth. Come ---       
    ## [290]               --- *your* clay, wet the other    eye  , drink, man _b_ _b_ _b_ ---              
    ## [291]                 --- know. If you shut *your*   eyes  , perhaps you 'll go to ---               
    ## [292]                    --- way. I 'm glad *your*   eyes   are red with crying. It ---              
    ## [293]                   --- to be, at *your* right   hand  , what he has never ceased ---            
    ## [294]                    --- take a pick at *your*   head   with the boat-hook. Cast off ! ---       
    ## [295]                  --- and tell us what *your*   eyes   make of it _b_ _b_ ---                   
    ## [296]                  --- then, R. W., lay *your*   head   upon *your* pillow and say, " ---        
    ## [297]             --- you might be glancing *your*    eye   down the street _b_ _b_ ---              
    ## [298]                  --- _b_ _b_ _b_ Cast *your*    eye   along the shelves, and, if ---           
    ## [299]            --- blow ! You 're casting *your*    eye   round the shop, Mr Wegg. ---             
    ## [300]        --- Everything within reach of *your*   hand  , in good preservation. The mouldy ---    
    ## [301]                    --- _b_ _b_ _b_ Is *your*   hand   out at all _b_ _b_ ---                   
    ## [302]              --- take the trouble off *your*   hands  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [303]                --- have taken it into *your*   head   that I mean to pension ---               
    ## [304]                 --- he is, by running *your*    eye   along his heighth _b_ _b_ ---            
    ## [305]                     --- or take it in *your*   head   that people are *your* puppets ---       
    ## [306]              --- house ? Do you stick *your*   head   out of a chimney-pot _b_ ---             
    ## [307]            --- look out. Keep *your* weather    eye   awake and do n't make ---                
    ## [308]            --- given that packet into *your*   hand   without being paid my price ---          
    ## [309]           --- sure, that accounts for *your*   hands  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [310]                  --- him, tapping him on the shoulder and beginning, " I beg *your* ---        
    ## [311]          --- my sudden degradation in *your*   eyes  ; familiar as I am with ---               
    ## [312]          --- next, sitting there with *your*   eyes   shut ? You ai n't asleep. ---            
    ## [313]               --- Fork out *your* balance in   hand  , and prove by figures how ---            
    ## [314]                --- in *your* pocket, and now   hand   it over _b_ _b_ _b_ ---                  
    ## [315]                    --- I had not bestowed my   hand   upon R. W., *your* father, ---           
    ## [316]                --- read at sight, and *your*   eyes   are as sharp as they ---                 
    ## [317]                 --- devil put that in *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [318]                 --- _b_ Not even lift *your*   head   to get it on my ---                      
    ## [319]            --- *your* lips again, and *your* forehead. There. O poor thing, poor ---           
    ## [320]     --- consequences you brought upon *your*   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [321]                      --- I fold it over this shoulder without injuring *your* dress ? Now, --- 
    ## [322]            --- _b_ _b_ *your* washing *your*   hands  of Mr Dolls, morally, Eugene ---         
    ## [323]                 --- _b_ _b_ _b_ throw *your*    eye   on this here bundle under ---            
    ## [324]               --- very bad sign. Keep *your*    eye   upon him when he comes ---               
    ## [325]                  --- of his tail. Get *your*   head   well behind his smile, Mr ---            
    ## [326]                       --- Look at this in my   hand  . This is *your* pay, on ---              
    ## [327]                   --- I knew which of *your*   hands  was the least spoilt, I ---              
    ## [328]                  --- draw my arm over *your* shoulder like this, Pa _b_ _b_ ---                
    ## [329]                   --- _b_ _b_ _b_ put *your*   hand   in mine, and we 'll ---                  
    ## [330]               --- darling Pa, give me *your*   hands  that I may fold them ---                 
    ## [331]                  --- me leave to kiss *your*   hand  , my Lovely, and it 's ---                
    ## [332]             --- the light, John. Shut *your*   eyes  , sir, and let me take ---                
    ## [333]              --- doubt have come into *your*   head   about it, governor _b_ _b_ ---           
    ## [334]                   --- _b_ you 'll cut *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [335]                    --- So you put *your* two   hands  between my two hands again ---           
    ## [336]                   --- I mean to knock *your*   head   against the wall _b_ _b_ ---             
    ## [337]             --- paper now rattling in *your*   hand   as I shake you -- ---                    
    ## [338]                  --- n't try to twist *your*   head   off, and fling THAT out ---              
    ## [339]            --- afore you tried *your* clumsy   hand   at it; in days when ---                  
    ## [340]                      --- see you with my own   eyes   take *your* own clothes from ---         
    ## [341]                   --- _b_ Do n't make *your*   eyes   red, Oliver, but eat *your* ---          
    ## [342]           --- _b_ Come, Oliver ! Wipe *your*   eyes   with the cuffs of *your* ---             
    ## [343]                 --- Pull that cap off *your*   eyes  , and hold up *your* head, ---            
    ## [344]                 --- eyes, and hold up *your*   head  , sir _b_ _b_ _b_ _b_ ---                 
    ## [345]                --- and save us ! Wash *your*   hands , and let me part *your* ---              
    ## [346]                    --- or I 'll split *your*   head   against the wall _b_ _b_ ---             
    ## [347]               --- make *your* fortun' out of   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [348]                   --- for me. Give me *your*   hand  . Make haste ! *Your* hand _b_ ---        
    ## [349]         --- *your* hand. Make haste ! *Your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [350]                --- loading will be in *your*   head   without notice. So, if you ---           
    ## [351]              --- by shooting him through the   head  , and will take *your* chance ---         
    ## [352]                 --- have a telescope at each    eye  , and a opera-glass between *your* ---    
    ## [353]            --- course not ! Bless the bright   eyes   of *your* sex ! They never ---           
    ## [354]                   --- you do n't take *your*   hands  off. Do you hear me ---                  
    ## [355]                --- a night. Curses on *your*   head  , and black death on *your* ---           
    ## [356]            --- peace and happiness in *your*   hands , and cast them to the ---                
    ## [357]          --- 's attachment, and claim *your*   hand  , as in redemption of some ---            
    ## [358]                    --- _b_ You have the same    eye   to *your* own interest, that ---         
    ## [359]                 --- a quiet tongue in *your*   head  , will you _b_ _b_ _b_ ---                
    ## [360]                   --- have you got in *your*   head   now _b_ _b_ _b_ _b_ ---                  
    ## [361]                --- lives of others in *your*   hands . I am the girl that ---                  
    ## [362]           --- Oliver should come into *your*   hands , he laughed, and said there ---          
    ## [363]              --- as much happiness on *your*   head   as I have brought shame ---              
    ## [364]                   --- _b_ _b_ _b_ Put *your*   head   out of the winder _b_ ---                
    ## [365]                --- that I could smash *your*   head   as if a loaded waggon ---                
    ## [366]                 --- blood be upon *your* own   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [367]                   --- _b_ _b_ _b_ Set *your*   hand   to a statement of truth ---              
    ## [368]                   --- _b_ _b_ give me *your*   hand  . Do not tremble. You need ---            
    ## [369]              --- which were placed in *your*   hands , for better security, by a ---           
    ## [370]                --- half an hour, with *your*    eye   against a lamp-post -- eh, ---           
    ## [371]                  --- I shall place in *your*   hands  a note for my -- ---                     
    ## [372]                --- tie round *your* dear old   head   -- you really should take ---            
    ## [373]          --- waters have closed above *your*   head  , and the world has closed ---            
    ## [374]                     --- 's -- give me *your*   hand  , sir _b_ _b_ _b_ _b_ ---                 
    ## [375]                  --- who lives but in *your*   eyes   -- who breathes but in ---               
    ## [376]              --- _b_ Mr. Winkle, take *your*   hands  off. Mr. Pickwick, let me ---            
    ## [377]            --- the honour of grasping *your*   hand  . Permit me, Sir, to shake ---            
    ## [378]           --- _b_ very hasty. Tupman; *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [379]                   --- _b_ _b_ Give us *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [380]                  --- _b_ _b_ _b_ Keep *your*   eyes   open _b_ _b_ _b_ _b_ ---                 
    ## [381]                    --- 's it; give us *your*   hand  , Sir. Up with you. You ---               
    ## [382]                  --- knock 'em out of *your*   head  . D'ye hear _b_ _b_ _b_ ---               
    ## [383]                 --- me, afore I knock *your*   head   off _b_ _b_ _b_ _b_ ---                  
    ## [384]                   --- _b_ Do you want *your*   head   knocked up against that wall, ---        
    ## [385]               --- *your* master 's a knowin'   hand  , and has just sent me ---                
    ## [386]             --- I have experienced at *your*   hands , and that of *your* hypocritical ---     
    ## [387]                 --- You need n't take *your*   hand   away to do that. I ---                   
    ## [388]           --- *your* affairs into *your* own   hands  after entrusting them to *your* ---      
    ## [389]        --- they please me. Gentlemen, *your*   hands  and names. Know me _b_ ---               
    ## [390]               --- leans very heavy on *your* shoulder when she gets in and ---                 
    ## [391]               --- my fine fellow, put *your*   hand   into the cupboard, and bring ---         
    ## [392]                    --- _b_ I 'd knock *your*   head   off for half-a-crown _b_ _b_ ---         
    ## [393]                 --- the book in *your* right   hand   this is *your* name and ---              
    ## [394]           --- are you a-reachin' out, *your*   hand   for the tumbler in that ---              
    ## [395]                   --- _b_ _b_ _b_ _b_ *Your*   hand  , my boy ! Why have I ---                 
    ## [396]           --- it convenient to reduce *your*   eyes   to their usual size again, ---           
    ## [397]                 --- _b_ _b_ Just keep *your*    eye   upon him for a few ---                   
    ## [398]               --- n't deserve this at *your*   hands , Emily, indeed _b_ _b_ _b_ ---           
    ## [399]              --- a coach, and puttin' *your*   hand   in his pocket, vile you ---              
    ## [400]                   --- _b_ _b_ Give me *your*   hand  , Nat _b_ _b_ _b_ _b_ ---                 
    ## [401]                    --- n't let me see *your*   hand   go nigh 'em. For I ---                   
    ## [402]                    --- _b_ _b_ I kiss *your*   hand  , miss _b_ _b_ _b_ _b_ ---                
    ## [403]          --- anything that recalls a beloved   head   that lay on *your* breast ---            
    ## [404]                    --- clean my boots keep a    eye   upon *your* mother now and ---           
    ## [405]          --- _b_ Willingly. " Give me *your*   hand  . She will be home directly, ---          
    ## [406]                  --- you see with *your* own   eyes   that he was a young ---                  
    ## [407]        --- should be proscribed under *your*   hand   at this moment, by the ---               
    ## [408]                   --- What is that in *your*   hand   ? A crowbar ? Give it me ---             
    ## [409]                 --- see. You may kiss *your*   hand   towards that highest shelving roof ---   
    ## [410]                --- do n't move *your* pretty   head   from his shoulder as you ---             
    ## [411]              --- *your* pretty head from his shoulder as you have it now, ---                  
    ## [412]      --- Section Committee. Look over *your*   hand  , Mr. Barsad, and see what ---            
    ## [413]                 --- _b_ _b_ Look over *your*   hand   carefully, Mr. Barsad. Take time ---     
    ## [414]             --- scarcely seem to like *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [415]                    --- may take it in *your*   hand  ; it 's no forgery _b_ ---                
    ## [416]             --- _b_ Never you trouble *your*   head   about this man _b_ _b_ ---               
    ## [417]             --- *your* heels is where *your*   head   is, if such should be ---                
    ## [418]            --- have my certificate in *your*   hand   with the rest, you know, ---             
    ## [419]                --- boots of mine. Put *your*   hands  to them; put *your* will ---             
    ## [420]                 --- on this table. Is *your*   hand   steady enough to write _b_ ---           
    ## [421]                  --- that a weapon in *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [422]                     --- What is it in *your*   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [423]                    --- life is in *your* own   hands . Quick ! Call assistance _b_ _b_ ---     
    ## [424]                   --- you let me hold *your*   hand   ? I am not afraid, but ---               
    ## [425]                 --- let me hold *your* brave   hand  , stranger _b_ _b_ _b_ _b_ ---            
    ## [426]               --- that dark hair upon *your*   head  , if you lay a finger ---                 
    ## [427]                  --- _b_ _b_ _b_ Keep *your*   eyes   upon me, dear child, and ---             
    ## [428]              --- nothing while I hold *your*   hand  . I shall mind nothing when ---

``` r
# you
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("you"), context = 0)
y
```

    ## [  1]       --- was acquired after the original   hand   was formed. Why do *you* ---             
    ## [  2]                --- of taking *you* by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [  3]            --- brimstone pig. *You* 're a   head   of swine _b_ _b_ _b_ ---                 
    ## [  4]                --- *You* must ever be the   head   and master here, father; and ---         
    ## [  5]                --- very glad to take your   hand  , sir. *You* are a good ---               
    ## [  6]               --- stood up with my single   hand   against them all, *you* know ---         
    ## [  7]              --- *you* lend Mr. Gridley a   hand  , and let 's see now ---                  
    ## [  8]      --- suppose *you* never clapped your   eyes   on the country, Phil _b_ ---             
    ## [  9]           --- So *you* never clapped your   eyes   upon the country -- marshes ---          
    ## [ 10]         --- dear friend. WILL *you* shake   hands  ? So glad *you* came that ---            
    ## [ 11]          --- whoever *you* are, with your   head   tied up in a bundle. ---                 
    ## [ 12]               --- *you* placed them in my   hands  -- a legal friend of ---                 
    ## [ 13]          --- little flighty. On the other   hand  , *you* ca n't admit but ---              
    ## [ 14]                --- there 's a good loving forehead for *you* ! All bright with ---          
    ## [ 15]         --- *you* have, and the confiding    eye   of affection is not the ---              
    ## [ 16]         --- *You* brought them with clean   hands , sir, and I accepted them ---            
    ## [ 17]         --- keep her from these dangerous   hands . *You* might show her what ---           
    ## [ 18]            --- *you* should come into her   head  . She merely proposed herself for ---     
    ## [ 19]                --- do ? Do *you* see this   hand  , and do *you* think that ---             
    ## [ 20]             --- do n't *you* trouble your   head   about the murder. That 's ---            
    ## [ 21]            --- affair. *You* keep half an    eye   on the newspapers, and I ---             
    ## [ 22]                --- quiet a tongue in your   head  . In short, the less *you* ---            
    ## [ 23]                  --- two or three in your    eye  , Mr. Jones, and *you* have ---           
    ## [ 24]                --- _b_ _b_ *You* know the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 25]            --- I should think *you* might   hand   my mother out of the ---                 
    ## [ 26]              --- _b_ _b_ *You* have sharp   eyes   and a sharp tongue, I ---                
    ## [ 27]             --- _b_ _b_ *You* have better   eyes   for that than *you* had ---              
    ## [ 28]          --- Varden. *You* may shake your   head  , father, but I say no ---                
    ## [ 29]              --- night, *you* may see his   eyes   in my dark room, shining ---             
    ## [ 30]               --- he, he ! *You* 'll have   eyes   for somebody besides Miss Dolly ---      
    ## [ 31]             --- Have *you* a messenger at   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 32]               --- sleep -- not *you*. Nor   eyes   in the knotted panes of ---              
    ## [ 33]                --- _b_ _b_ *you* have the   head   and heart of an evil ---                 
    ## [ 34]                  --- *You* had it in your   hand   at the door. Give it ---                 
    ## [ 35]              --- upon him, if *you* stand    eye   to eye. My blighted boy ! ---            
    ## [ 36]                 --- if *you* stand eye to    eye  . My blighted boy ! Oh ! all ---          
    ## [ 37]                 --- _b_ Do *you* see this   hand  , master _b_ _b_ _b_ _b_ ---              
    ## [ 38]            --- *you* trust yourself in my   hands  on so short an acquaintance, ---         
    ## [ 39]                --- *you* that with my own   eyes   -- broad awake -- I ---                  
    ## [ 40]             --- master. It fell into good   hands , *you* see _b_ _b_ _b_ ---               
    ## [ 41]                   --- _b_ and I 'll shake   hands  with *you* _b_ _b_ _b_ ---               
    ## [ 42]                --- *you* is good for sore   eyes  , sir _b_ _b_ _b_ _b_ ---                 
    ## [ 43]             --- *you* need n't shake your   head  , sir. It was a wild- ---                 
    ## [ 44]                --- your deed, if not your   hand   -- I know *you* _b_ ---                  
    ## [ 45]                  --- _b_ _b_ _b_ Put your   hand   in mine. *You* 're blind ---             
    ## [ 46]                  --- or can. If *you* had   eyes  , and could look around *you* ---         
    ## [ 47]             --- why should *you* ? Is the   hand   of Heaven more manifest in ---           
    ## [ 48]                   --- have put it in good   hands . *You* know me, Hugh. Nobody ---         
    ## [ 49]              --- where *you* can lay your   hand   upon it in an instant. ---               
    ## [ 50]                  --- do n't mean with his   hands , for that *you* know, but ---            
    ## [ 51]              --- *you* know, but with his   head   -- as *you* or any ---                   
    ## [ 52]               --- are going to tie *you*,   hand   and foot, but otherwise *you* ---        
    ## [ 53]           --- of something to drink here.   Hand   over, one of *you* _b_ ---               
    ## [ 54]            --- I have *you*. *You*, whose   hands  are red with my brother ---              
    ## [ 55]           --- has delivered *you* into my   hands . No. Though *you* had the ---            
    ## [ 56]             --- do with him ? Would *you*   hand   him over to a pack ---                   
    ## [ 57]               --- ay, *you* may toss your   head   -- *you* would ! Kill the ---            
    ## [ 58]              --- that *you* were close at   hand   (which I, of course, urged ---           
    ## [ 59]               --- and sound. On the other   hand  , if *you* decline to do ---              
    ## [ 60]              --- little door on the right   hand   when *you* think *you* 've ---           
    ## [ 61]          --- _b_ Barnaby -- *you* ! Whose   hand   was that, that struck me ---             
    ## [ 62]                     --- me go. Do not lay   hands  upon me. *You* have told ---             
    ## [ 63]            --- *you* mean by rolling your   eyes   and shaking your fist at ---             
    ## [ 64]                    --- _b_ _b_ _b_ And to   hand   *you* over to somebody else ---          
    ## [ 65]                 --- my way here, sword in   hand  , *you* see _b_ _b_ _b_ ---               
    ## [ 66]                  --- with my bundle on my shoulder before running away. -- *You* ---        
    ## [ 67]         --- Hush ! " and turned away your   head  . Why did *you* do so ? ---               
    ## [ 68]              --- 'll suit *you*. Try your   hand   upon him _b_ _b_ _b_ ---                 
    ## [ 69]            --- *you* were in everybody 's   eyes   but mine the wreck and ---               
    ## [ 70]             --- *you* please, with a good   head   to it _b_ _b_ _b_ ---                    
    ## [ 71]                    --- _b_ _b_ _b_ Oh, my   eyes   and limbs, what do *you* ---             
    ## [ 72]                --- do *you* want ? Oh, my   eyes   and limbs, what do *you* ---             
    ## [ 73]                  --- sure as *you* have a   head   upon your shoulders, I 'll ---           
    ## [ 74]                 --- seem to want my right   hand  , when I miss *you*. Though ---           
    ## [ 75]               --- _b_ _b_ *You* can shake   hands  with me, Mr. Omer, if ---                
    ## [ 76]        --- Missis Gummidge, she claps her   hands  like a play, and *you* ---               
    ## [ 77]              --- as *you* are tonight. My   hand   upon it ! Ham, I give ---                
    ## [ 78]                 --- *you* joy, my boy. My   hand   upon that, too ! Daisy, stir ---         
    ## [ 79]                     --- and let me lay my   head   upon *you*. Oh, I am ---                 
    ## [ 80]       --- an inscrutable falsehood in his   eyes   ? If *you* are honourable and ---        
    ## [ 81]             --- brings the tears into her   eyes  ; and if *you* was to ---                 
    ## [ 82]            --- and warm those mortal cold   hands . *You* doe n't need to ---               
    ## [ 83]       --- clouds about himself, with both   hands : 'Splendid, *you* know _b_ _b_ ---       
    ## [ 84]             --- have any knockings on the   head   in THIS family, if *you* ---             
    ## [ 85]           --- that *you* should lift your   hand   against a person that *you* ---          
    ## [ 86]        --- trouble out of you-know-who 's   head  , and put it *you* know ---               
    ## [ 87]                --- water from your son 's   hand   now, *you* cherish a terrible ---        
    ## [ 88]              --- have raised *you* in the   eyes   of everything that wears the ---         
    ## [ 89]              --- weak and helpless in his   hands  as to pay *you*, afterwards, ---         
    ## [ 90]         --- between *you* both; having no   eyes  , no ears, no feelings, no ---            
    ## [ 91]                --- _b_ _b_ _b_ 'Among the   eyes   elevated towards *you* from this ---     
    ## [ 92]                 --- at me. Only open your   eyes   to show me that *you* ---                
    ## [ 93]                --- *you* do n't shut your   eyes   this minute, I 'll call ---              
    ## [ 94]                   --- than he is), is our   head   Manager, *you* would be as ---           
    ## [ 95]                --- _b_ Paul being in such   hands  as Mrs Pipchin 's, *you* ---             
    ## [ 96]          --- to Captain Cuttle. Keep your    eye   upon my Uncle, will *you*, ---           
    ## [ 97]               --- But *you* only lay your   head   well to the wind _b_ ---                 
    ## [ 98]             --- *you* may have heard your   head   Governor mention my name ? -- ---        
    ## [ 99]                --- would make me to shake   hands  with *you*, once, before going ---       
    ## [100]                    --- _b_ _b_ _b_ and my   hand   's destroyed. *You* are fond ---         
    ## [101]                  --- can tell how she 'll   head  , *you* see. She 's full ---              
    ## [102]                 --- see *you* with my own   eyes  , and to hear *you* with ---              
    ## [103]           --- to her. *You* bind yourself   hand   and foot on her account. ---             
    ## [104]                   --- enable me to take a   hand   with *you* _b_ _b_ _b_ ---               
    ## [105]           --- the earth. Lucretia Tox, my   eyes   are opened to *you* all ---              
    ## [106]        --- feelings even before me, whose   eyes   *you* had so completely closed ---       
    ## [107]                --- *you* -- with your own   eyes   -- as *you* sit there ---                
    ## [108]         --- broach, and down *you* pitch,   head   foremost _b_ _b_ _b_ _b_ ---             
    ## [109]        --- establishment *you* are at the   head   of _b_ _b_ _b_ _b_ ---                   
    ## [110]                  --- crown of a Briton 's   head  , for which *you* 'll overhaul ---        
    ## [111]                --- tempt *you* to seek my   hand   ? Did I ever use any ---                 
    ## [112]             --- _b_ _b_ _b_ There ! Shake   hands  with me. *You* 're a ---                 
    ## [113]         --- Grangeby. I must really shake   hands  with *you* again. And now ---            
    ## [114]               --- have *you* done to your   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [115]                  --- *You* who are at the   head   of this household, and bound ---         
    ## [116]                --- have hold of this true   hand  . Do *you* _b_ _b_ _b_ ---                
    ## [117]              --- Joseph Bagstock is a bad   hand   at a counterfeit. If *you* ---           
    ## [118]                 --- of the birdcage in my   hand  , will *you* _b_ _b_ _b_ ---              
    ## [119]             --- of serving *you* with the   head   of the House; but the ---                
    ## [120]             --- such things are. By whose   hand   do *you* think _b_ _b_ ---               
    ## [121]                --- I have fingers on this   hand  . Who was it, do *you* ---                
    ## [122]                  --- into a blaze when my   eyes   rested on him. *You* know ---            
    ## [123]          --- have the pleasure of shaking   hands  *You* 've a way of ---                   
    ## [124]                --- every right to bend my   head   before what *you* confide to ---         
    ## [125]                --- A moment yet. Lay your   head   so, dear, that as *you* ---              
    ## [126]            --- love and trust *you*. Both   hands , Jack _b_ _b_ _b_ _b_ ---                
    ## [127]  --- *you* uncover that ridiculous little   head   of yours and give me ---                 
    ## [128]                  --- _b_ I 'll smash your    eye  , if *you* do n't look ---                
    ## [129]           --- me with that clenched right   hand  . Unclench it, if *you* please ---        
    ## [130]          --- _b_ *You* have clenched that   hand   again _b_ _b_ _b_ _b_ ---                
    ## [131]               --- *you* are. Permit me to   hand   *you* a chair, my dear ---               
    ## [132]           --- which *you* are the eminent   head  , the young ladies might gain ---         
    ## [133]              --- when *you* give him your   hand  , can only be known to ---                
    ## [134]               --- for having HIM under my    eye   to-night, do *you* know _b_ ---          
    ## [135]           --- afraid to open his generous   eyes  , and that *you* forced me, ---           
    ## [136]                 --- _b_ Being alone in my   eyes  , I wish *you* good-evening with ---      
    ## [137]               --- Who brought *you* up by   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [138]                 --- n't bring *you* up by   hand   to badger people 's lives ---            
    ## [139]             --- which brought *you* up by   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [140]        --- service, will *you* throw your    eye   over them _b_ _b_ _b_ ---                
    ## [141]              --- was bringing *you* up by   hand  . Very kind of her too, ---               
    ## [142]                 --- when *you* take me in   hand   in my learning, Pip (and ---             
    ## [143]             --- which brought *you* up by   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [144]             --- which brought *you* up by   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [145]             --- which *you* brought up by   hand  . Hold up your head, boy, ---             
    ## [146]              --- paper *you* hold in your   hand  . What is it _b_ _b_ ---                  
    ## [147]               --- of bringing *you* up by   hand   ! It 's a sad picter, ---                
    ## [148]                  --- _b_ _b_ _b_ _b_ Soft   Head   ! Need *you* say it face ---             
    ## [149]                  --- or *you* 'll get its   head   under the table _b_ _b_ ---              
    ## [150]                  --- with my hammer in my   hand  , or even my pipe. *You* ---              
    ## [151]               --- *you* come and put your   head   in at the forge window ---               
    ## [152]                --- Pip ? so *you* kiss my   hand   as if I were a ---                       
    ## [153]                   --- Or do *you* kiss my   hand   in the same spirit in ---                
    ## [154]        --- asked before *you* touched the   hand  . But, yes, if *you* like ---             
    ## [155]                --- piece of paper in your   hand  . *You* have got it ? Very ---            
    ## [156]        --- affairs entirely into your own   hands , and *you* will draw from ---            
    ## [157]              --- eh ? Is n't there bright   eyes   somewheres, wot *you* love the ---       
    ## [158]                 --- Take it in your right   hand  . Lord strike *you* dead on ---           
    ## [159]             --- 'and Magwitch, lend her a   hand  , will *you* ? ' But he never ---         
    ## [160]           --- old Bill Barley, bless your   eyes  . Ahoy ! Bless *you* _b_ _b_ ---          
    ## [161]            --- her may have scratched her   hands . What then ? *You* are not ---           
    ## [162]            --- evening, with tears in her   eyes  , to say to *you* that ---                
    ## [163]      --- faults and disappointments on my   head  , if *you* can receive me ---             
    ## [164]              --- what *you* want. With my   head   in its present state, I ---              
    ## [165]                --- _b_ *You* 're a steady   Hand  , and I was not mistaken. ---             
    ## [166]             --- he should offer *you* his   hand   in marriage. That time, to ---           
    ## [167]               --- *you* grow up under his   eyes  , to very little purpose, if ---          
    ## [168]                 --- _b_ _b_ *You* are the   Hand   they have sent to Coventry, ---          
    ## [169]       --- moment. Something comes into my   head  . If *you* 'll step out ---               
    ## [170]          --- what. Show me a dissatisfied   Hand  , and I 'll show *you* ---                
    ## [171]                     --- _b_ _b_ _b_ Try a   hand   at backgammon, sir, as *you* ---         
    ## [172]               --- _b_ *You* may hang your   head  , to make yourself the more ---           
    ## [173]         --- think, my dearest love, whose   eyes   are on *you* _b_ _b_ ---                 
    ## [174]             --- of *you* and cooling your   head  . Will *you* see father ? Sissy ---       
    ## [175]                 --- *you* 'll allow me to   hand   *you* down to it, and ---                
    ## [176]         --- _b_ Cavalletto ! Give me your   hand  . *You* know Lagnier, the gentleman. ---  
    ## [177]               --- as this ? Have *you* no   eyes  , that *you* do n't see ---               
    ## [178]                    --- It 's put into his   head   to be made useful. *You* ---             
    ## [179]                   --- to place it in your   hands , *you* will much oblige me ---           
    ## [180]          --- mind your glove, John. Shake   hands  with it on. *You* are ---                
    ## [181]                 --- *you* will be a right   hand   to the other. Here 's ---                
    ## [182]                   --- *You* ca n't make a   head   and brains out of a ---                  
    ## [183]              --- behind me on that little   hand  . I have told *you* *you* ---             
    ## [184]                --- *you* cry to ease your   head  , Little Mother, let me cry ---           
    ## [185]                 --- not with that lady 's   eyes   so intent upon *you*, Tattycoram ---     
    ## [186]                --- _b_ _b_ *You* have the   head   of two men _b_ _b_ ---                   
    ## [187] --- establishment with confidence in your   hands , and perhaps *you* may do ---            
    ## [188]              --- behind us on that little   hand   of yours. And so *you* ---               
    ## [189]                --- matter I place in your   hands . I authorize *you* now to ---            
    ## [190]        --- put something into your little   head  . *You* wo n't guess what ---             
    ## [191]                  --- *You* have as good a   head   for understanding such things as ---     
    ## [192]                 --- wall there had a kind    eye   upon them sometimes. *You* so ---        
    ## [193]             --- to assert that *you* have   eyes   in your head, and yet ---                
    ## [194]               --- *you* have eyes in your   head  , and yet ask me what ---                 
    ## [195]              --- *You* make one bite your   head   off, when one wants to ---               
    ## [196]           --- your pardon. It gladdens my   eyes   to see *you* again; that ---             
    ## [197]                 --- _b_ _b_ *You* make my   head   ache by remaining in that ---            
    ## [198]           --- has honoured *you* with her   hand  , when she finds herself in ---           
    ## [199]                     --- as a lever in the   hands  of counsel. Will *you* excuse ---        
    ## [200]            --- the feelings with which my   eyes   behold *you* at the present ---          
    ## [201]               --- hitched my apron off my   head  . When *you* told me I ---                
    ## [202]                  --- he confided it to my   hands  for *you*, perhaps it was ---            
    ## [203]           --- *you* what I consider those   eyes   of hers, that were here ---              
    ## [204]             --- _b_ Then *you* will shake   hands , sir _b_ _b_ _b_ _b_ ---                 
    ## [205]              --- _b_ _b_ *You* will shake   hands , sir _b_ _b_ _b_ _b_ ---                 
    ## [206]                  --- no, I will not shake   hands , John. I have forgiven *you*. ---        
    ## [207]           --- at all, will *you* ? Change   hands  first, for the box is ---                
    ## [208]               --- -- *you* shall try your   hand   on these proposals for a ---             
    ## [209]            --- to my knowledge, opened my   eyes  . *You* spoke to me, disinterestedly, --- 
    ## [210]                  --- _b_ I am afraid your   head   is turned, *you* silly thing ---         
    ## [211]                  --- words ? I 've had my    eye   upon *you* any time this ---             
    ## [212]                   --- and glad to hide my   head   in the what *you* may ---                
    ## [213]                     --- of oil, have I no   eyes   to see how *you* have ---                
    ## [214]                   --- 's not right in his   head  , *you* know _b_ _b_ _b_ ---              
    ## [215]               --- *you* have the stock in   hand   to go upon for the ---                   
    ## [216]              --- What do *you* think your   eyes   was made for -- eh ? ---                 
    ## [217]                   --- _b_ _b_ What an old   hand   *you* are, Mr Chuzzlewit _b_ ---         
    ## [218]                   --- to take it into her   head  , if *you* talk to her ---                
    ## [219]           --- *You* need n't trouble your   head   about ME _b_ _b_ _b_ ---                 
    ## [220]             --- the tears a-fillin in her   eyes  , " *you* knows much betterer than ---    
    ## [221]               --- *you* 're wrong in your   head   and when *you* 're in ---                
    ## [222]                --- _b_ *You* held up your   head   last night. *You* 're coming ---         
    ## [223]            --- knock. Will *you* put your   head   out of window, and tell ---              
    ## [224]              --- Mark Tapley. I opened my   eyes  , I can tell *you*, when ---              
    ## [225]             --- _b_ Where *you* have your   hand   now, hey _b_ _b_ _b_ ---                 
    ## [226]          --- to know *you*. That towering forehead, my dear Jonas _b_ _b_ ---               
    ## [227]               --- have taken *you* by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [228]              --- *you* can, and wash your   hands  of it by a plain ---                     
    ## [229]                    --- looks on me with a    eye   of -- with what *you* ---                
    ## [230]                    --- hurt a hair of her   head  , *you* shall answer it. Poor ---         
    ## [231]             --- better way of opening his   eyes   than by presenting *you* before ---      
    ## [232]                  --- in an instant on the   hand   *you* had licked and beslavered, ---     
    ## [233]             --- seen them flowing from my   eyes   -- did *you* not, yourself, ---          
    ## [234]                --- _b_ _b_ This caught my    eye   this morning, and *you* may ---          
    ## [235]             --- schoolroom; and lend me a   hand   with my school-coat, will *you* ---      
    ## [236]                   --- up a Latin one, and   hand   that over to *you*. Now, ---             
    ## [237]              --- died at last lifting his   head   to kiss them. Do *you* ---               
    ## [238]                --- _b_ *You* 'll cry your   eyes   out, when I 'm gone; ---                 
    ## [239]                --- _b_ Do *you* want your   head   broke in a fresh place, ---              
    ## [240]      --- it, afterwards. Will *you* shake   hands  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [241]                  --- not hope to close my   eyes   all night, unless *you* tell ---         
    ## [242]                      --- _b_ _b_ I had my    eye   upon *you* all the time ---              
    ## [243]                --- _b_ _b_ *you* 'll soon   hand   over _b_ _b_ _b_ _b_ ---                 
    ## [244]             --- youth *you* have taken in   hand   and are lending good help ---            
    ## [245]                 --- brutality of so old a   hand   as *you*. And now we ---                 
    ## [246]               --- But *you* must dry your   eyes   first, and compose yourself. Let ---     
    ## [247]          --- wrong, and indignity upon my   head  . *You*, who sent me to ---               
    ## [248]              --- mortar takes it into his   head   to do it himself, *you* ---              
    ## [249]           --- Canterbury had n't the same   eyes   as *you* -- *you* 'll ---                
    ## [250]            --- The pistol falls from your   hand   -- *you* are overcome -- ---             
    ## [251]          --- after night, never getting a   hand  , and *you* getting a couple ---          
    ## [252]           --- _b_ Will *you* unclasp your   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [253]        --- *You* are the demdest, knowing   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [254]                  --- the very top of your   head   like a blue-coat boy. *You* ---          
    ## [255]            --- *you* suppose we have laid   hands  on, Wackford and me _b_ ---              
    ## [256]            --- off the stoutest beadle 's   head  , *you* will find my card ---             
    ## [257]              --- *you* bless me with your   hand   and heart, *you* can apply ---           
    ## [258]              --- to this gentleman -- and   hand   it round, will *you*, waiter ? ---       
    ## [259]            --- put over Peg Sliderskew 's   head  , after so many years; *you* ---          
    ## [260]           --- time he tampers with *you*,   hand   him over to the police, ---              
    ## [261]                --- are about to give your   hand  , some of his deeds *you* ---             
    ## [262]                  --- is to give *you* her   hand   hates and despises *you*. Her ---        
    ## [263]               --- _b_ If *you* value your   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [264]   --- discovery are thickening about your   head  ; that the structures *you* have ---      
    ## [265]                 --- -- fill it again, and   hand   it over to *you* _b_ ---                 
    ## [266]             --- little child had laid her   head  . *You* see his wish was ---              
    ## [267]              --- fool and fallen into the   hands  of *you* and others who ---              
    ## [268]              --- he has offered *you* his   hand  , perhaps, since I have been ---          
    ## [269]             --- all. He offered *you* his   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [270]                --- nail, I 'll pinch your   eyes  , if *you* talk to me ---                 
    ## [271]               --- an atom from anybody 's   hand   but mine if *you* please. ---            
    ## [272]               --- back. If *you* let your   hand   tremble so, we can never ---             
    ## [273]                 --- saw *you* with my own   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [274]              --- this lightning in one 's   eyes  , by-the-by. *You* had better stand ---   
    ## [275]                --- _b_ _b_ _b_ Bless your   eyes  , how I love *you* _b_ ---                
    ## [276]                  --- _b_ _b_ Give me your   hand   while *you* throw back the ---           
    ## [277]                --- _b_ _b_ Then *you* may   hand   it over, Sir. And if ---                 
    ## [278]          --- have *you* been cooling your    eye   there _b_ _b_ _b_ _b_ ---                
    ## [279]              --- know. If *you* shut your   eyes  , perhaps *you* 'll go to ---             
    ## [280]           --- *you*. Another shake of the   hand  , Marchioness, if *you* please. Sit ---   
    ## [281]              --- it for putting *you* 're   hand   in the pocket of a ---                   
    ## [282]          --- *you* might be glancing your    eye   down the street _b_ _b_ ---              
    ## [283]                      --- put it out of my   head  . I think *you* said Rooshan ---          
    ## [284]         --- blow ! *You* 're casting your    eye   round the shop, Mr Wegg. ---             
    ## [285]          --- _b_ *You* 've tolerable good   eyes  , ai n't *you*, Governor ? *You* ---      
    ## [286]          --- *You* 've all tolerable good   eyes  , ai n't *you* _b_ _b_ ---                
    ## [287]         --- having promised *you* that an    eye   should be always kept on ---             
    ## [288]                --- noted down with my own   hand  , and that *you* may be ---               
    ## [289]                   --- _b_ _b_ that in her   eyes   *you* look well in any ---               
    ## [290]               --- the blood boiling to my   head  . I do n't hear *you* ---                 
    ## [291]           --- house ? Do *you* stick your   head   out of a chimney-pot _b_ ---             
    ## [292]              --- the wall, where her blue   eyes   can shine upon *you* _b_ ---             
    ## [293]               --- how *you* come by 'em ?   Hand   over that there bottle _b_ ---           
    ## [294]         --- next, sitting there with your   eyes   shut ? *You* ai n't asleep. ---          
    ## [295]               --- is. Never fall into his   hands , Lammle, I beg of *you* ---              
    ## [296]                   --- for money out of my   eyes   long, and when *you* see ---             
    ## [297]  --- consequences *you* brought upon your   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [298]            --- *You* have fallen into the   hands  of the Jews, Eugene _b_ ---              
    ## [299]     --- *you*, Lawyer Lightwood, ought to   hand   over this here stifficate, and ---       
    ## [300]               --- When did *you* last set   eyes   upon his daughter _b_ _b_ ---            
    ## [301]                --- *you* are as knowing a   hand   as I am. We should ---                   
    ## [302]            --- fallen into Mr Fledgeby 's   hands . Let me tell *you* that, ---             
    ## [303]                    --- I 'm almost off my   head  . *You* hurry me so. Be ---               
    ## [304]                --- *you* 'll keep one and   hand   over the others _b_ _b_ ---              
    ## [305]                --- -- ry good. Will *you*   hand   me that chair, sir, to ---               
    ## [306]          --- of grateful pleasure into my   eyes  , to hear *you* say so ---                
    ## [307]                 --- be allowed to wash my   hands , only *you* find me out ---              
    ## [308]                   --- *you* out of my own   head  . John dear, why did *you* ---            
    ## [309]               --- where there are so many   eyes   to see *you*, that I ---                 
    ## [310]       --- constancy since *you* first set   eyes   upon her ? Ass ! Can *you* ---           
    ## [311]                --- _b_ *you* 'll cut your   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [312]            --- and Co. after all ! Little   Eyes  , Little Eyes, *you* 're too ---          
    ## [313]       --- after all ! Little Eyes, Little   Eyes  , *you* 're too cunning by ---            
    ## [314]               --- are obliged to keep our   eyes   always open. And *you* know ---          
    ## [315]                --- What have *you* got in   hand   now _b_ _b_ _b_ _b_ ---                  
    ## [316]                 --- So *you* put your two   hands  between my two hands again ---           
    ## [317]                   --- *you* be so good as   hand   me over that same dockyment ---          
    ## [318]             --- _b_ *You* 're knocking my   head   against the wall _b_ _b_ ---             
    ## [319]            --- paper now rattling in your   hand   as I shake *you* -- ---                  
    ## [320]               --- talking, I 'll bring my   hand   down upon *you* with all ---             
    ## [321]         --- afore *you* tried your clumsy   hand   at it; in days when ---                  
    ## [322]                 --- see *you* with my own   eyes   take your own clothes from ---           
    ## [323]                  --- her, and there 's my   hand  , and thank *you* again _b_ ---           
    ## [324]          --- _b_ *You* think this thumped   head   of mine is excited _b_ ---               
    ## [325]             --- 'em suffer before my very   eyes  , *you* know sir _b_ _b_ ---              
    ## [326]                 --- a knife to that black    eye  , as *you* run along. It ---              
    ## [327]                   --- I 've got the upper   hand   over *you*, Fagin; and, d ---            
    ## [328]                --- _b_ _b_ _b_ _b_ Come !   Hand   over, will *you* _b_ _b_ ---             
    ## [329]                   --- _b_ _b_ _b_ _b_ _b_   hand   over, I tell *you* ! Do ---              
    ## [330]               --- loading will be in your   head   without notice. So, if *you* ---         
    ## [331]                --- this job *you* have on   hand  , *you* 'll prevent his ever ---          
    ## [332]        --- *you* might never have clapped   eyes   on the boy to notice ---                 
    ## [333]                --- *you* do n't take your   hands  off. Do *you* hear me ---                
    ## [334]               --- _b_ *You* have the same    eye   to your own interest, that ---           
    ## [335]                --- a quiet tongue in your   head  , will *you* _b_ _b_ _b_ ---              
    ## [336]                --- have *you* got in your   head   now _b_ _b_ _b_ _b_ ---                  
    ## [337]                --- _b_ and *you* slap her   hands , Fagin, while Bill undoes the ---        
    ## [338]                   --- I have the means at   hand  , quiet and close. If *you* ---           
    ## [339]                 --- take a paper from her   hand  , and watched *you* too, next ---         
    ## [340]                  --- _b_ _b_ give me your   hand  . Do not tremble. *You* need ---          
    ## [341]                --- *you* can cut. Saw his   head   off _b_ _b_ _b_ _b_ ---                  
    ## [342]               --- tie round your dear old   head   -- *you* really should take ---          
    ## [343]                    --- _b_ _b_ _b_ a keen   hand   like *you* ought to have ---             
    ## [344]               --- place the matter in the   hands  of a professional man, *you* ---         
    ## [345]               --- door for *you* to shake   hands  with; and six children in ---            
    ## [346]        --- *you*, " said Tom, putting his   hand   in his pocket. _b_ _b_ ---               
    ## [347]         --- what ! Mr. Pickwick, with the   eyes   of the world upon *you* ! ---            
    ## [348]                  --- -- *you* may bind me   hand   and leg, or lock me ---                  
    ## [349]       --- beautifully. *You* are an older   hand   at this than I thought ---               
    ## [350]                   --- 's it; give us your   hand  , Sir. Up with *you*. *You* ---           
    ## [351]                --- _b_ Do *you* want your   head   knocked up against that wall, ---        
    ## [352]              --- the room, by his excited    eye  . Did *you* observe his excited ---       
    ## [353]         --- Did *you* observe his excited    eye  , Mr. Jinks _b_ _b_ _b_ ---               
    ## [354]               --- any fellow that wants a   head  . I wish *you* 'd take ---                
    ## [355]              --- *You* need n't take your   hand   away to do that. I ---                   
    ## [356]                  --- Have *you* a pair of   eyes  , Mr. Weller _b_ _b_ _b_ ---              
    ## [357]             --- deal door; but bein' only   eyes  , *you* see, my wision 's ---             
    ## [358]        --- are *you* a-reachin' out, your   hand   for the tumbler in that ---              
    ## [359]                --- can see with the naked    eye   that *you* gets stouter under ---        
    ## [360]              --- all *you* would say. The   head   is in fault _b_ _b_ ---                  
    ## [361]                    --- as my uncle felt a   hand   on his shoulder, " *you* 're ---         
    ## [362]                    --- felt a hand on his shoulder, " *you* 're booked for one ---          
    ## [363]                 --- _b_ _b_ Never mind my   eyes  ; *you* had much better read ---          
    ## [364]               --- _b_ _b_ _b_ Well, shake   hands , wo n't *you* _b_ _b_ ---                
    ## [365]           --- partner has tendered me his   hand  , and *you* have both assumed ---         
    ## [366]           --- of *you*, except me ? Shake   hands  with him, and order him ---              
    ## [367]             --- a coach, and puttin' your   hand   in his pocket, vile *you* ---            
    ## [368]                --- pale face and her cold   hands . Do *you* call that being ---            
    ## [369]             --- is clinging to *you*, the   hands  of baby, girl, and woman, ---            
    ## [370]           --- frying and sputtering in my   head  . If *you* want me to ---                 
    ## [371]            --- yourself; if, on the other   hand  , *you* should be satisfied with ---      
    ## [372]               --- *you* see with your own   eyes   that he was a young ---                  
    ## [373]               --- sake ! She will put her   hands  together and pray *you* to ---           
    ## [374]              --- see. *You* may kiss your   hand   towards that highest shelving roof ---   
    ## [375]               --- do n't move your pretty   head   from his shoulder as *you* ---           
    ## [376]             --- your pretty head from his shoulder as *you* have it now, ---                
    ## [377]             --- _b_ _b_ After not setting   eyes   upon *you* or hearing of ---             
    ## [378]        --- beaten. Have *you* followed my   hand  , Mr. Barsad _b_ _b_ _b_ ---              
    ## [379]          --- _b_ Never *you* trouble your   head   about this man _b_ _b_ ---               
    ## [380]           --- have my certificate in your   hand   with the rest, *you* know, ---           
    ## [381]                --- *you* let me hold your   hand   ? I am not afraid, but ---               
    ## [382]              --- that dark hair upon your   head  , if *you* lay a finger ---

### Concordances: Long suspensions

``` r
# returned
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("returned"), context = 0)
y
```

    ## [ 1]          --- _b_ she *returned*, drying her  eyes _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 2]     --- _b_ *returned* Charley, putting her  head forward and folding her hands ---        
    ## [ 3]   --- *returned* Mr. Woodcourt, shaking his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 4]   --- *returned* the locksmith, shaking his  head, and smiling _b_ _b_ _b_ ---             
    ## [ 5]        --- *returned* the other, waving his  hand _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 6]         --- *returned* the son, raising his  head for a moment, and then ---               
    ## [ 7]       --- *returned* the other, raising his  head a little from the cushion ---            
    ## [ 8]         --- *returned* Sir John, fixing his  eyes upon him _b_ _b_ _b_ ---                 
    ## [ 9]     --- *returned* Mr Haredale, shaking his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [10]       --- _b_ *returned* Uriah, shaking his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [11]  --- *returned* Mrs. Markleham, shaking her  head and her fan _b_ _b_ ---                  
    ## [12]      --- *returned* Agnes, raising her soft  eyes to mine _b_ _b_ _b_ ---                  
    ## [13]          --- _b_ he *returned*, pressing my  hand _b_ _b_ _b_ _b_ _b_ ---                  
    ## [14]       --- *returned* the Major, kissing his  hand _b_ _b_ _b_ _b_ _b_ ---                  
    ## [15]      --- *returned* his wife, immoveable in  eye , and voice, and attitude _b_ ---         
    ## [16]          --- _b_ he *returned*, shaking his  head at me with a deliberate ---              
    ## [17]     --- *returned* Mr. Jaggers, turning his  eyes upon me coolly, and taking ---           
    ## [18]      --- _b_ *returned* Rachael, drying her  eyes _b_ _b_ _b_ _b_ _b_ ---                  
    ## [19]          --- _b_ she *returned*, fixing her  eyes upon him _b_ _b_ _b_ ---                 
    ## [20]       --- *returned* Mrs Gowan, shaking her  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [21]      --- _b_ _b_ *returned* Martin, shaking hands with him again _b_ _b_ ---               
    ## [22]     --- *returned* Mrs Todgers, nodding her  head with mysterious intelligence _b_ _b_ --- 
    ## [23]        --- *returned* Martin, as they shook hands _b_ _b_ _b_ _b_ _b_ ---                  
    ## [24]      --- *returned* the doctor, shaking his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [25]        --- *returned* Mr Folair, waving his  hand in deprecation of any further ---        
    ## [26] --- *returned* brother Charles, shaking his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [27]          --- _b_ *returned* Tim, wiping his  eyes _b_ _b_ _b_ _b_ _b_ ---                  
    ## [28]    --- _b_ *returned* Nicholas, meeting his  eye  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [29]       --- *returned* the child with tearful  eyes _b_ _b_ _b_ _b_ _b_ ---                  
    ## [30]     --- *returned* the child, with downcast  eyes _b_ _b_ _b_ _b_ _b_ ---                  
    ## [31]       --- *returned* the other, meeting his  eye  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [32]          --- *returned* Mr Boffin, with his  hand still to his chin _b_ ---                
    ## [33] --- *returned* Lavinia, coolly, tossing her  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [34]    --- *returned* his sister, detaining his  hand as he withdrew it _b_ ---                
    ## [35]   --- _b_ *returned* Sophronia, shaking her  head, and smiling her best smile ---          
    ## [36]       --- _b_ *returned* Bella, tossing her  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [37]       --- *returned* Mr Boffin, with folded hands _b_ _b_ _b_ _b_ _b_ ---                  
    ## [38]        --- _b_ *returned* Wegg, shaking his  head sagaciously, and bestowing a wooden ---  
    ## [39]     --- *returned* the dressmaker, with her  eyes upon her work _b_ _b_ ---                
    ## [40]      --- *returned* Mrs. Maylie, laying her  hand upon his shoulder _b_ _b_ ---            
    ## [41]        --- *returned* the man, clapping his hands to his mouth nevertheless, and ---       
    ## [42]  --- *returned* that gentleman, shaking his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [43]        --- *returned* Mr. Lorry, drying his  eyes _b_ _b_ _b_ _b_ _b_ ---

``` r
# nodding
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("nodding"), context = 0)
y
```

    ## [ 1]           --- the blind man, *nodding* his  head with perfect composure _b_ _b_ ---       
    ## [ 2] --- interrupted Mr. Spenlow, *nodding* his  head a great many times, and ---              
    ## [ 3]       --- said Mr. Micawber, *nodding* his  head sorrowfully _b_ _b_ _b_ _b_ ---          
    ## [ 4]    --- observed the Captain, *nodding* his  head thoughtfully _b_ _b_ _b_ _b_ ---         
    ## [ 5]            --- _b_ _b_ often *nodding* her  head, and much enjoying the Lumps ---         
    ## [ 6]     --- interposed the Dean, *nodding* his  head smoothly _b_ _b_ _b_ _b_ ---             
    ## [ 7]  --- Miss Havisham, steadily *nodding* her  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 8]            --- _b_ said Bar, *nodding* his  head, for he was not to ---                   
    ## [ 9]         --- large knees, and *nodding* his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [10]      --- cried Tigg, gravely *nodding* his  head as if some ground of ---                 
    ## [11]          --- said Mr George, *nodding* his  head violently at every second syllable ---   
    ## [12]    --- returned Mrs Todgers, *nodding* her  head with mysterious intelligence _b_ _b_ --- 
    ## [13]         --- _b_ cried Merry, *nodding* her  head and giggling very much _b_ ---           
    ## [14]                  --- of her gown with both hands, and *nodding* her head a ---            
    ## [15]          --- both hands, and *nodding* her  head a great many times as ---                
    ## [16]       --- _b_ said Nicholas, *nodding* his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [17]              --- a sigh, and *nodding* his  head a great many times _b_ ---               
    ## [18]     --- replied brother Ned, *nodding* his  head as a man thoroughly determined ---       
    ## [19]          --- said Mrs Quilp, *nodding* her  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [20]            --- said the boy, *nodding* his  head and drawing back, with the ---           
    ## [21]            --- said the boy, *nodding* his  head and rubbing it at the ---                
    ## [22]         --- bawled the dwarf *nodding* his  head _b_ _b_ _b_ _b_ _b_ ---                  
    ## [23]        --- his patron, sadly *nodding* his  head and musing _b_ _b_ _b_ ---               
    ## [24]          --- said Mr. Giles, *nodding* his  head, approvingly _b_ _b_ _b_ _b_ ---         
    ## [25]         --- said Mr. Weller, *nodding* his  head with a satisfied air _b_ ---             
    ## [26]        --- _b_ said Stryver, *nodding* his  head over him as he reviewed ---              
    ## [27]    --- _b_ rejoined Stryver, *nodding* his  head in a smoothing and final ---             
    ## [28]             --- a breath and *nodding* her  head with a stern kind of ---                 
    ## [29]         --- said Miss Pross, *nodding* her  head emphatically _b_ _b_ _b_ _b_ ---

``` r
# replied
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("replied"), context = 0)
y
```

    ## [ 1]   --- he slowly *replied*, roughening his   head   more and more _b_ _b_ ---          
    ## [ 2]      --- _b_ *replied* Em'ly, shaking her   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 3]       --- _b_ *replied* Dora, slapping my   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 4]   --- he *replied*, patiently shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 5]     --- *replied* the Major, shutting one    eye  , putting his head on one ---       
    ## [ 6]         --- _b_ he *replied*, shaking his   head   mournfully _b_ _b_ _b_ _b_ ---     
    ## [ 7]    --- _b_ *replied* Walter, grasping his   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 8]         --- _b_ he *replied*, shaking her   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 9]      --- she *replied*, glancing over her shoulder as he slouched after us ---        
    ## [10]    --- _b_ *replied* Wemmick, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [11]         --- _b_ he *replied*, holding his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [12]        --- _b_ *replied* Tom, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [13]   --- _b_ *replied* Nicholas, shaking his   head   mournfully _b_ _b_ _b_ _b_ ---     
    ## [14]  --- *replied* Lord Frederick, fixing his   eyes   on Miss Nickleby _b_ _b_ ---       
    ## [15]    --- *replied* Mr Crummles, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [16]   --- *replied* Mr Folair, scratching his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [17] --- _b_ *replied* Squeers, scratching his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [18]     --- _b_ *replied* Smike, pressing his   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [19]    --- *replied* brother Ned, nodding his   head   as a man thoroughly determined --- 
    ## [20]   --- *replied* Mrs Nickleby, tossing her   head   and looking at the ashes ---       
    ## [21]   --- *replied* the stranger, folding his   hands  together _b_ _b_ _b_ _b_ ---       
    ## [22]    --- _b_ *replied* Gride, arresting his   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [23]       --- *replied* Gride, drawing in his   head   with a frightful grin _b_ ---      
    ## [24]     --- *replied* Mr. Bumble, shading his   eyes   with his hand, and surveying ---   
    ## [25]      --- *replied* the girl, wringing her   hands  _b_ _b_ _b_ _b_ _b_ ---

Analysis: 2. Comparing B1 + all “lexical” collocates in DNov quotes vs. long suspensions
========================================================================================

For this part, only the tag B1 is kept, all others are replaced by lower
case tokens. This means we are working with a version of the corpus
where only B1 semantic tags are present, whereas everything else is
shown as its original token form (but in lower case). This allows us to
see co-occurrences such as B1 + “rubbing”. If B1 co-occurred more
frequently with itself in one of the corpora, the co-occurrence pair B1
+ B1 would also show up (as all realizations of the tag B1 are disaplyed
as “B1” rather than their tokens at this stage).

``` r
quotes_text$tokens$type <- with(quotes_type_store, ifelse(grepl("^B1", semantic_tags), semantic_tags, lc_tokens))
quotes_text$tokens$type[is.na(quotes_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers
long_sus_text$tokens$type <- with(long_sus_type_store, ifelse(grepl("^B1", semantic_tags), semantic_tags, lc_tokens))
long_sus_text$tokens$type[is.na(long_sus_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers
```

Number of (lexical) types & tokens in B1 & examples
---------------------------------------------------

### Quotes

``` r
a <- corp_type_lookup(quotes_text)

# Number of tokens tagged as B1 in quotes
nrow(quotes_text$tokens[type=="B1"])
```

    ## [1] 9030

``` r
# Top 20 frequency of (lexical) types tagged as B1
freq_list <- (as.data.frame(sort(table(quotes_text$tokens[type=="B1"]$token), decreasing = TRUE)))
head(freq_list, 20)
```

    ##     Var1 Freq
    ## 1  heart  710
    ## 2   head  588
    ## 3   hand  579
    ## 4   eyes  467
    ## 5   face  443
    ## 6  hands  287
    ## 7  sleep  189
    ## 8    eye  170
    ## 9   back  166
    ## 10  born  165
    ## 11 blood  160
    ## 12  legs  144
    ## 13    to  138
    ## 14  feet  137
    ## 15 tired  133
    ## 16  hair  131
    ## 17   arm  126
    ## 18  body  121
    ## 19  lips  120
    ## 20  foot  110

``` r
# All (lexical) types tagged as B1 in quotes
unique(tolower(a[type == "B1"]$tokens))
```

    ## [1] "hearing, brains, finger, hand, born, head, sleeping, livers, wake, tired, go, to, bed, forehead, hair, tear, skin, sleep, heart, cheeks, ears, eyes, cheek, breathed, hands, blood, veins, wrist, hip, lips, face, back, room, consciousness, tire, mouth, asleep, lap, chest, lungs, snoring, teeth, teeth, throat, bones, breathing, eye, breath, body, legs, waist, breast, hearts, heads, ear, beard, birth, necks, skulls, tongue, bite, neck, bodily, knuckles, unconscious, blue-eyed, puts, goes, shoulders, sucked, feet, endurance, slumbers, waking, nose, foot, breathe, shoeless, knees, ankles, limbs, thirsty, swallow, hip, marrow, marrow, fist, marrows, nap, dozing, arms, wide, awake, hand, thirst, brain, faces, rouse, eyelids, slumbering, bile, complexion, shiver, profile, fingers, secreted, sleeps, arm, rousing, arms, tears, roused, bone, emaciated, going, ankle, bronchial, insensible, up, shoulder, flesh, gave, skins, brow, fringe, slept, spit, went, limb, crying, gone, eyebrows, wake, fast, bleed, put, bronzed, beard, wakes, unborn, sleep, faces, gore, tires, sleepy, falling, skull, hair's-breadth, noses, slumber, tooth, gnaws, face., backs, fall, snores, tush, drowsy, blood-vessels, anatomical, bodies, in, beards, thumb, licked, biting, waking, physical, ear., nimbler, go, rouse, bit, thirsts, soles, lip, cells, tongues, sleeping, bladder, wrists, tear, bare-footed, elbow, nerve, woke, awoke, wince, ribs, rib, bites, bites, leg, biled, blood, heel, frowned, liver, free, bosom, breathing-time, physically, face, fingers, toes, moustachios, bald, eyebrow, chin, stomach, knee, spine, bitten, thinness, blood-relation, spluttered, passage, swallowing, nerves, frown, organ, skeletons, skeleton, inhaling, fanny, tiring, bones, gored, biles, turnspits, jaws, give, snore, heart, lacerating, numbness, elbows, pins, and, needles, gall, liver, sleepless, brow, snapped, slumbered, head, unwound, yawn, hymen, breathed, blood-vessel, body, off, haunch, awake, bosoms, back, build, pulse, pitch-fork, shivers, round, bone, flabby, fore-foot, sole, gnawed, magnifying-glass, shivering, sweat, finger-nails, spluttering, tired, joints, hunchback, benumbed, hands, brows, sinews, snored, fallen, barefoot, anatomist, gone, bellies, bite, tiptoe, paunch, swallowed, bleeding, foreheads, chests, thirsty., born, bust, thumbs, nimble, palm, mouths, legs, looked, secrete, palms, vein, codicil, kidney, torpor, baldness, one-eyed, joint, skinny, anatomy, hairs, endurances, spat, unsaid, alabama, quaffed, snores, hearts, organ-loft, lick, holds, its, toe, births, looks, gastric, tip-toe, pimples, limb, toe, asleep, gasping, dimple, belly, jugular, bled, thumb, moustaches, orbs, pimples, organs, thirsting, unsay, waken, sneezed, cell, frowning, bloods, b-o-t, bot, fists, swallow, eyelashes, bodily, throats, laps, inhaled, nervous, system, collar-bone, complexions, tears, necks, sneezing, waists, lashes, thirsty, secreting, shivering, gnawing, sniffing, sniff, lies, ca-daverous, look, bloodshot, sneeze, arm, falls, jowl, mole, livered, shivered, unwind, bodies, born., snap, codicil, skulls, cuticle, gulp, anatomy, stomachs, unwinds, numbed, chins, thumbnail, sweats, sweating, blood-money, drowsiness, unsay, heart., nape, tooth-powder, suck, bile, instrumental, pore, flesh, bowels, cheek, suck, snooze, respiration, eyes, eye, weed, gasp, bare-facedest, knuckle, beat, mustachios, snoozing, bleeds, tiptoes, biling, heads, soles, tremulous, blown, out, doze, given, breathes, eyed, frowns, muscles, panting, perspiring, ocular, gasped, sleepy, tongue, scowl, agility, hind-quarters, muscular, swallowed, breathless, moustache, blink, eyelid, turpin, perspiration, eye-, browed, thighs, hips, scowling, exhalations, visage, hand."

### Long suspensions

``` r
b <- corp_type_lookup(long_sus_text)

# Number of tokens tagged as B1 in long suspensions
nrow(long_sus_text$tokens[type=="B1"])
```

    ## [1] 2742

``` r
# Top 20 frequency of (lexical) types tagged as B1
freq_list <- (as.data.frame(sort(table(long_sus_text$tokens[type=="B1"]$token), decreasing = TRUE)))
head(freq_list, 20)
```

    ##        Var1 Freq
    ## 1      hand  418
    ## 2      head  364
    ## 3      eyes  266
    ## 4      face  205
    ## 5     hands  152
    ## 6       arm  102
    ## 7  shoulder   69
    ## 8       eye   47
    ## 9      lips   47
    ## 10    tears   43
    ## 11      ear   40
    ## 12     hair   39
    ## 13     arms   37
    ## 14     back   37
    ## 15     chin   36
    ## 16   breast   35
    ## 17   finger   33
    ## 18     foot   32
    ## 19    Fanny   31
    ## 20     nose   31

``` r
# All (lexical) types tagged as B1 in long suspensions
unique(tolower(b[type == "B1"]$tokens))
```

    ## [1] "lips, face, back, eyes, hands, arm, head, hand, arms, shoulder, heart, finger, nose, tears, eyebrows, shoulders, consciousness, eye, forehead, neck, chin, knee, foot, fingers, breast, cheeks, elbow, thumb-nail, knees, tremulous, tongue, brow, hair, sniff, spits, mouth, legs, heads, crying, chest, knuckles, thigh, ear, leg, snort, breathless, unconscious, blowing, out, breathe, lip, breast-pocket, feet, pimples, nimbly, ankles, waking, wrist, hiccup, frowning, throat, teeth, fist, organ, biting, cheek, palm, breathing, body, perspiration, tired, tooth, yawn, sleeping, beard, skin, cells, brows, frown, veins, ears, rousing, breath, thumb, bosom, baldness, thumbs, swallowing, toes, lap, gasping, bite, limbs, joints, bones, winced, elbows, muscular, snorted, bitten, complexion, jaws, born, hearing, shiver, gasped, bald, visage, spat, blood, licking, frowned, rouse, collation, snorting, asleep, backs, snapping, yawned, fanny, pouted, panting, eyelids, pulse, moustache, tiring, fists, yawning, nerving, tiptoe, waist, room, cell, vein, snapped, nap, limb, bust, fertility, scowling, faces, sneezing, nerves, agility, palms, jowl, gulping, profile, free, ankle, squat, stomach, anatomist, bleeding, swallow, gulp, dimples, dimple, skeleton, heel, pouting, drowsy, skinny, slept, tear, blinking, fallen, wake, roused, flesh, head"

``` r
# the set of nodes and collocates we are interested in
nodes <- unique(grep("^B1", c(quotes_text$tokens$type, long_sus_text$tokens$type), value = TRUE))
nodes
```

    ## [1] "B1"

``` r
#co-occurrences
quotes_surface <- corp_surface(quotes_text, span = "5LR", nodes = nodes)
long_sus_surface <- corp_surface(long_sus_text, span = "5LR", nodes = nodes)

# compare
results <- corp_coco(quotes_surface, long_sus_surface, nodes = nodes)
```

Concordances of “lexical” collocates
------------------------------------

### Concordances: Quotes

``` r
# "to" as the realisation of B1
y <- corp_concordance(quotes_surface, nodes = nodes, context = 0)
# In order to subset by the node "to" as a B1 realisation and sort by the first word on the right, in this case sort by "R1", not "R1_type" (the type is the semantic tag and in this case it will be B1 for all of the R1s, because "to" is part of multiword sequences that are tagged for B1 as a unit, with "to" in the middle)
subset(y[order(R1),], N=="to")
```

    ## [  1]        --- perhaps you would rather go to bed _b_ _b_ _b_ _b_ ---                 
    ## [  2]              --- 's tired, he puts her to bed. And when he 's ---                 
    ## [  3]                --- he 's tired he goes to bed himself. And when I ---             
    ## [  4]                   --- when I do n't go to bed. And I 'm a-going ---               
    ## [  5]            --- am doing, before you go to bed _b_ _b_ _b_ _b_ ---                 
    ## [  6]       --- supper. When I went upstairs to bed, our house being small ---          
    ## [  7]         --- family after they was gone to bed and about its being ---             
    ## [  8]              --- Had n't you better go to bed _b_ _b_ _b_ _b_ ---                 
    ## [  9]               --- had a deal better go to bed, Miss Dedlock _b_ _b_ ---           
    ## [ 10]              --- Had n't you better go to bed, miss _b_ _b_ _b_ ---               
    ## [ 11]               --- had a deal better go to bed, Miss Dedlock _b_ _b_ ---           
    ## [ 12]             --- into the house and put to bed in a state that ---                 
    ## [ 13]             --- into the house and put to bed in a state that ---                 
    ## [ 14]             --- into the house and put to bed in a state that ---                 
    ## [ 15]             --- into the house and put to bed in a state that ---                 
    ## [ 16]             --- _b_ _b_ Has Dolly gone to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 17]                    --- _b_ I do n't go to bed this night _b_ _b_ ---              
    ## [ 18]         --- some prayers before you go to bed, I hope _b_ _b_ ---                 
    ## [ 19]          --- taking a candle and going to bed directly. How dare you, ---         
    ## [ 20]                --- I said you might go to bed, John _b_ _b_ _b_ ---               
    ## [ 21]        --- the handbills before I went to bed, and both are gone ---              
    ## [ 22]         --- drink more strong wine, go to bed every night more drunk ---          
    ## [ 23]            --- Miggs, my good girl, go to bed -- do go to ---                     
    ## [ 24]                    --- to bed -- do go to bed. You 're really worse ---           
    ## [ 25]                 --- n't bear it. Do go to bed, Miggs. To oblige me ---            
    ## [ 26]                --- Yes yes, oh do ! Go to bed directly _b_ _b_ _b_ ---            
    ## [ 27]                --- Do you hear me ? Go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 28]              --- _b_ You had better go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 29]            --- for the boy - David, go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 30]            --- with - I should put him to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 31]              --- me up. I generally go to bed late _b_ _b_ _b_ ---                
    ## [ 32]          --- River ed - will have gone to bed these two hours _b_ ---             
    ## [ 33]           --- the purpose. You must go to bed another time, my love. ---          
    ## [ 34]                    --- n't go, I 'd go to bed at six. In consequence ---          
    ## [ 35]           --- let these dear rogues go to bed; and as no house ---                
    ## [ 36]       --- something warm before you go to bed, and not to distress ---            
    ## [ 37]               --- _b_ you 'd better go to bed again. Do n't you ---               
    ## [ 38]             --- off your things and go to bed this minute _b_ _b_ ---             
    ## [ 39] --- meditations, when you go up-stairs to bed. That 's all, old ---               
    ## [ 40]                --- Now the baby 's put to bed let 's have supper ---              
    ## [ 41]            --- nothing more to say. Go to bed, go to bed _b_ ---                  
    ## [ 42]                 --- say. Go to bed, go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 43]                --- to get to sleep. Go to bed, go to bed _b_ ---                  
    ## [ 44]               --- sleep. Go to bed, go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 45]               --- _b_ _b_ _b_ _b_ Gone to bed, sir _b_ _b_ _b_ ---                
    ## [ 46]            --- tired, and will go home to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 47]           --- my brother is going home to bed. He is tired, and ---               
    ## [ 48]                 --- _b_ If they all go to bed, why I must go. ---                 
    ## [ 49]          --- and solitude, if one went to bed two hours hence _b_ ---             
    ## [ 50]       --- over comfortably, and may go to bed. You best and dearest ---           
    ## [ 51]              --- gave you up, she went to bed, dear _b_ _b_ _b_ ---               
    ## [ 52]              --- I recommend you to go to bed immediately _b_ _b_ _b_ ---         
    ## [ 53]                    --- I beg you to go to bed. I -- ha -- ---                     
    ## [ 54]       --- personal request that you go to bed. You ought to have ---              
    ## [ 55]                 --- _b_ _b_ Shall I go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 56]                --- and I had better go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 57]            --- think YOU had better go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 58]           --- should ever happen to go to bed there -- you MAY, ---               
    ## [ 59]          --- my regular time for going to bed, and I can find ---                 
    ## [ 60]        --- _b_ fired pistols, and went to bed in a nightcap; and, ---             
    ## [ 61]      --- every night just before going to bed; at least, I do ---                 
    ## [ 62]           --- men never dream of going to bed without 'em, and I ---              
    ## [ 63]          --- half an hour before going to bed, (for I have just ---               
    ## [ 64]                --- that he does not go to bed; therefore it can not ---           
    ## [ 65]                --- know he does n't go to bed, because my room is ---             
    ## [ 66]            --- it is your weakness. Go to bed. Do go to bed ---                   
    ## [ 67]                   --- Go to bed. Do go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 68]            --- walked. When I had gone to bed again, I heard him ---              
    ## [ 69]                --- _b_ or is she going to bed in her own little ---               
    ## [ 70]     --- strangers walking in and going to bed without leave or licence ---        
    ## [ 71]               --- of him since he went to bed yesterday afternoon _b_ _b_ ---     
    ## [ 72]                  --- _b_ _b_ _b_ to go to bed when I like, get ---                
    ## [ 73]              --- tin box when she goes to bed, and does n't lock ---              
    ## [ 74]              --- 's clear. When I went to bed, my hands were not ---              
    ## [ 75]                  --- she left me to go to bed in the dark, locked ---             
    ## [ 76]           --- night after they 'd gone to bed, and feel about in ---              
    ## [ 77]             --- out after they 'd gone to bed, and sometimes before, you ---      
    ## [ 78]            --- night after we had gone to bed, she brought back the ---           
    ## [ 79]                 --- meat. As it is, go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 80]           --- going to forgive you. Go to bed this moment _b_ _b_ ---             
    ## [ 81]                 --- But if he has gone to bed, I 'll put a ---                    
    ## [ 82]                  --- day, and I 'll go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 83]            --- present; but you may go to bed in the Albany, Piccadilly, ---      
    ## [ 84]                    --- and he is to go to bed directly, poor fellow, to ---       
    ## [ 85]             --- Had n't they better go to bed, ma'am _b_ _b_ _b_ ---              
    ## [ 86]              --- him back, and put him to bed again _b_ _b_ _b_ ---               
    ## [ 87]          --- by mistake before he went to bed. But nobody ever minded ---         
    ## [ 88]                   --- it 's time to go to bed. It will never do, ---              
    ## [ 89]        --- kitchen fire afore she went to bed, and locked up the ---              
    ## [ 90]              --- My young girl is gone to bed, Sir _b_ _b_ _b_ ---                
    ## [ 91]           --- Mr. Pickwick, I would go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 92]              --- _b_ _b_ _b_ _b_ going to bed ? I wish I was. ---                 
    ## [ 93]             --- _b_ _b_ There ! Now go to bed, Sam, and we 'll ---                
    ## [ 94]                    --- but I ca n't go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 95]                 --- _b_ _b_ _b_ Not go to bed _b_ _b_ _b_ _b_ ---                 
    ## [ 96]        --- always smoke arter you goes to bed, old cock _b_ _b_ ---               
    ## [ 97]      --- the coffee-room, and shall go to bed soon, it is hardly ---              
    ## [ 98]                 --- _b_ I shall not go to bed till night; but I ---               
    ## [ 99]                 --- _b_ _b_ and may go to bed _b_ _b_ _b_ _b_ ---                 
    ## [100]            --- the road, the sun going to bed, the carriage of the ---            
    ## [101]               --- is again about to go to bed. I am collecting my ---             
    ## [102]              --- side of the sun going to bed, where they have a ---              
    ## [103]               --- as the sun was going to bed, and looked back from ---           
    ## [104]      --- only getting stupid and going to sleep _b_ _b_ _b_ _b_ ---               
    ## [105]            --- _b_ Him, who never goes to sleep, or so much as ---                
    ## [106]             --- eat, and drink, and go to sleep, as long as I ---                 
    ## [107]                  --- to me. I 'm going to sleep _b_ _b_ _b_ _b_ ---               
    ## [108]                --- tell you I 'm going to sleep _b_ _b_ _b_ _b_ ---               
    ## [109]              --- a child that had gone to sleep _b_ _b_ _b_ _b_ ---               
    ## [110]               --- with my hand, and go to sleep. Oh, pray, pray, let ---          
    ## [111]              --- to write, before I go to sleep _b_ _b_ _b_ _b_ ---               
    ## [112]              --- _b_ _b_ Have you gone to sleep, Loo _b_ _b_ _b_ ---              
    ## [113]       --- mechanically. I am not going to sleep here. I am going ---              
    ## [114]            --- have the power of going to sleep and waking up whenever ---        
    ## [115]               --- wo n't mind my going to sleep, if I can _b_ ---                 
    ## [116]              --- _b_ You should n't go to sleep upon the ground with ---          
    ## [117]            --- friend of mine never go to sleep with his head in ---              
    ## [118]             --- in case of their going to sleep; eh _b_ _b_ _b_ ---               
    ## [119]              --- _b_ _b_ are you going to sleep all day, up there ---             
    ## [120]             --- I thought you had gone to sleep _b_ _b_ _b_ _b_ ---               
    ## [121]                 --- _b_ I 'm not going to sleep in the fresh air; ---             
    ## [122]                   --- And now I 'll go to sleep till half-past five, when ---     
    ## [123]             --- and then, and has gone to sleep for two years, I ---              
    ## [124]               --- and if you 're going to sleep in that way, you ---              
    ## [125]         --- you there ? You were going to sleep upon cold bricks; I ---           
    ## [126]           --- eyes, perhaps you 'll go to sleep. You 'll be all ---               
    ## [127]               --- not the place I went to sleep in _b_ _b_ _b_ ---                
    ## [128]      --- juryman; and should have gone to sleep, as fast as Newgate, ---          
    ## [129]               --- _b_ _b_ are you gone to sleep in there _b_ _b_ ---              
    ## [130]                 --- _b_ Say I 've gone to sleep -- they 'll believe ---           
    ## [131]               --- that boy, he 's gone to sleep again. -- Joe, let ---            
    ## [132]               --- that boy, he 's gone to sleep again. Be good enough ---         
    ## [133]               --- that boy; he 's gone to sleep again. Joe ! Joe _b_ ---          
    ## [134]                 --- _b_ _b_ he 's gone to sleep again _b_ _b_ _b_ ---             
    ## [135]               --- that boy, he 's gone to sleep again -- Joe, help ---            
    ## [136]               --- that boy, he 's gone to sleep _b_ _b_ _b_ _b_ ---               
    ## [137]              --- would make any one go to sleep, that bedstead would, whether --- 
    ## [138]               --- for fear I should go to sleep _b_ _b_ _b_ _b_ ---

### Concordances: Long suspensions

``` r
# returned
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("returned"), context = 0)
y
```

    ## [ 1]          --- _b_ she *returned*, drying her   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 2]     --- _b_ *returned* Charley, putting her   head   forward and folding her hands ---        
    ## [ 3]     --- *returned* Mr. Skimpole, his genial   face   irradiated by the comicality of ---      
    ## [ 4]   --- *returned* Mr. Woodcourt, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 5]   --- *returned* the locksmith, shaking his   head  , and smiling _b_ _b_ _b_ ---             
    ## [ 6]        --- *returned* the other, waving his   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 7]       --- *returned* the other, leaning his    arm   upon the chimney-piece, and turning ---  
    ## [ 8]         --- *returned* the son, raising his   head   for a moment, and then ---               
    ## [ 9]           --- _b_ he *returned* between his   teeth , as he motioned her aside ---            
    ## [10]       --- *returned* the other, raising his   head   a little from the cushion ---            
    ## [11]      --- _b_ *returned* John, elevating his eyebrows, and lowering his voice to ---           
    ## [12]       --- *returned* the man, thrusting his  tongue  into his cheek _b_ _b_ ---               
    ## [13]         --- *returned* Sir John, fixing his   eyes   upon him _b_ _b_ _b_ ---                 
    ## [14]     --- *returned* Mr Haredale, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [15]       --- _b_ *returned* Uriah, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [16]  --- *returned* Mrs. Markleham, shaking her   head   and her fan _b_ _b_ ---                  
    ## [17]       --- he *returned*, rubbing his double   chin   again _b_ _b_ _b_ _b_ ---                
    ## [18]      --- *returned* Agnes, raising her soft   eyes   to mine _b_ _b_ _b_ ---                  
    ## [19]           --- *returned* my aunt, taking my    arm   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [20]          --- _b_ he *returned*, pressing my   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [21]      --- _b_ *returned* Mr. Micawber, whose   face   clouded at this reference _b_ ---        
    ## [22]          --- _b_ *returned* the child, with   tears  springing to her eyes _b_ ---            
    ## [23]       --- *returned* the Major, kissing his   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [24]      --- *returned* his wife, immoveable in    eye  , and voice, and attitude _b_ ---         
    ## [25]          --- _b_ he *returned*, shaking his   head   at me with a deliberate ---              
    ## [26]     --- *returned* Mr. Jaggers, turning his   eyes   upon me coolly, and taking ---           
    ## [27]           --- he *returned*, drawing a long  breath  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [28]      --- _b_ *returned* Rachael, drying her   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [29]          --- _b_ she *returned*, fixing her   eyes   upon him _b_ _b_ _b_ ---                 
    ## [30]       --- *returned* Mrs Gowan, shaking her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [31]  --- *returned* Gowan, touching the painted   face   with his brush in the ---                
    ## [32]              --- she *returned* in the same  breath  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [33]              --- _b_ _b_ _b_ _b_ *returned*   Fanny  (in a tone suggesting that ---           
    ## [34]              --- _b_ _b_ _b_ _b_ *returned*   Fanny , taking him up short upon ---            
    ## [35]              --- _b_ _b_ _b_ _b_ *returned*   Fanny , with great indignation _b_ _b_ ---      
    ## [36]     --- *returned* Mrs Todgers, nodding her   head   with mysterious intelligence _b_ _b_ --- 
    ## [37]      --- *returned* the doctor, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [38]        --- *returned* Mr Folair, waving his   hand   in deprecation of any further ---        
    ## [39]     --- _b_ *returned* Squeers, rubbing his   knees  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [40] --- *returned* brother Charles, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [41]          --- _b_ *returned* Tim, wiping his   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [42]    --- _b_ *returned* Nicholas, meeting his    eye   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [43]     --- *returned*, looking anxiously in my   face   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [44]       --- *returned* the child, kissing her   cheek  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [45]       --- *returned* the child with tearful   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [46]     --- *returned* the child, with downcast   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [47]       --- *returned* the other, meeting his    eye   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [48]          --- *returned* Mr Boffin, with his   hand   still to his chin _b_ ---                
    ## [49] --- *returned* Lavinia, coolly, tossing her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [50]           --- _b_ _b_ *returned* Miss Wren, snapping her fingers in a volley ---              
    ## [51]      --- *returned* Miss Wren, snapping her  fingers in a volley of impatient ---             
    ## [52]   --- _b_ *returned* Pleasant, dropping her   arms   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [53]        --- *returned* Bella, with a burning   face   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [54]    --- *returned* his sister, detaining his   hand   as he withdrew it _b_ ---                
    ## [55]       --- *returned* Lizzie, with a burning   face   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [56]   --- _b_ *returned* Sophronia, shaking her   head  , and smiling her best smile ---          
    ## [57]       --- _b_ *returned* Bella, tossing her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [58]   --- _b_ *returned* Bradley with quivering   lips   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [59]       --- _b_ *returned* Lavvy, folding her   arms   and leaning back in her ---              
    ## [60]       --- *returned* Mr Boffin, with folded   hands  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [61]        --- _b_ *returned* Wegg, shaking his   head   sagaciously, and bestowing a wooden ---  
    ## [62]     --- *returned* the dressmaker, with her   eyes   upon her work _b_ _b_ ---                
    ## [63]    --- _b_ *returned* Bella, with quivering   lips   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [64]      --- *returned* Mrs. Maylie, laying her   hand   upon his shoulder _b_ _b_ ---            
    ## [65]  --- *returned* that gentleman, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [66]      --- _b_ *returned* madame, lifting her eyebrows a little _b_ _b_ _b_ ---                 
    ## [67]        --- *returned* Mr. Lorry, drying his   eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [68]     --- _b_ *returned* Carton, stamping his   foot   _b_ _b_ _b_ _b_ _b_ ---

``` r
# replied
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("replied"), context = 0)
y
```

    ## [ 1]              --- _b_ he *replied*, pressing my    arm   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 2]        --- he slowly *replied*, roughening his   head   more and more _b_ _b_ ---          
    ## [ 3]           --- _b_ *replied* Em'ly, shaking her   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 4]            --- _b_ *replied* Dora, slapping my   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 5]        --- he *replied*, patiently shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 6]     --- *replied* Traddles, on whose attentive   face   a thoughtful shade had stolen ---  
    ## [ 7]          --- *replied* the Major, shutting one    eye  , putting his head on one ---       
    ## [ 8]              --- _b_ he *replied*, shaking his   head   mournfully _b_ _b_ _b_ _b_ ---     
    ## [ 9] --- *replied*, attiring herself, with fumbling  fingers _b_ _b_ _b_ _b_ _b_ ---            
    ## [10]         --- _b_ *replied* Walter, grasping his   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [11]           --- she *replied*, glancing over her shoulder as he slouched after us ---        
    ## [12]         --- _b_ *replied* Wemmick, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [13]              --- _b_ he *replied*, holding his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [14]             --- _b_ *replied* Tom, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [15]        --- _b_ *replied* Nicholas, shaking his   head   mournfully _b_ _b_ _b_ _b_ ---     
    ## [16]       --- *replied* Lord Frederick, fixing his   eyes   on Miss Nickleby _b_ _b_ ---       
    ## [17]         --- *replied* Mr Crummles, shaking his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [18]        --- *replied* Mr Folair, scratching his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [19]      --- _b_ *replied* Squeers, scratching his   head   _b_ _b_ _b_ _b_ _b_ ---            
    ## [20]   --- *replied* Newman, suddenly thrusting his   face   into that of Squeers _b_ ---       
    ## [21]          --- _b_ *replied* Smike, pressing his   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [22]         --- *replied* brother Ned, nodding his   head   as a man thoroughly determined --- 
    ## [23]        --- *replied* Mrs Nickleby, tossing her   head   and looking at the ashes ---       
    ## [24]        --- *replied* the stranger, folding his   hands  together _b_ _b_ _b_ _b_ ---       
    ## [25]         --- _b_ *replied* Gride, arresting his   hand   _b_ _b_ _b_ _b_ _b_ ---            
    ## [26]         --- she *replied* through her starting   tears  _b_ _b_ _b_ _b_ _b_ ---            
    ## [27]          --- *replied* Mr. Bumble, shading his   eyes   with his hand, and surveying ---   
    ## [28]           --- *replied* the girl, wringing her   hands  _b_ _b_ _b_ _b_ _b_ ---            
    ## [29]         --- _b_ _b_ *replied* Oliver, shedding   tears  of delight _b_ _b_ _b_ ---

``` r
# cried
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("cried"), context = 0)
y
```

    ## [ 1]        --- *cried* Charley with a heaving    heart   _b_ _b_ _b_ _b_ _b_ ---                 
    ## [ 2]          --- *cried* my guardian with his    hand    in his pocket _b_ _b_ ---               
    ## [ 3]    --- *cried* Barnaby, glancing over his  shoulder  _b_ _b_ _b_ _b_ _b_ ---                 
    ## [ 4]         --- *cried* Miggs, with a flushed    face    _b_ _b_ _b_ _b_ _b_ ---                 
    ## [ 5]        --- _b_ *cried* Miggs, rubbing her    hands   _b_ _b_ _b_ _b_ _b_ ---                 
    ## [ 6]         --- *cried* Miggs, turning on the    tears   again, previous to quitting the ---     
    ## [ 7] --- *cried* the locksmith with brightened    eyes   , and sturdy, honest voice _b_ ---       
    ## [ 8]   --- _b_ *cried* Barnaby with glistening    eyes   , as he clutched his pole ---            
    ## [ 9]       --- *cried* outright, and wrung his    hands   _b_ _b_ _b_ _b_ _b_ ---                 
    ## [10]        --- _b_ *cried* Miggs, folding her    hands   and looking upwards with a ---          
    ## [11]         --- _b_ she *cried*, clasping her    hands  , and looking upward _b_ _b_ ---         
    ## [12]       --- *cried* Hugh, raising his right     arm    aloft, and looking upward like ---      
    ## [13]           --- she *cried*, with her whole    heart   and soul in her earnest ---             
    ## [14]     --- *cried*, abruptly pointing in his    face   , and stepping back _b_ _b_ ---          
    ## [15]     --- *cried* Mr. Peggotty, rolling his    head    in an ecstasy at the ---                
    ## [16]        --- _b_ *cried* Agnes, putting her    hands   before her face, as her ---             
    ## [17]    --- *cried* Miss Mowcher, wringing her    hands   impatiently, as she went to ---         
    ## [18]        --- she *cried*, tearing her black    hair    _b_ _b_ _b_ _b_ _b_ ---                 
    ## [19]       --- _b_ *cried* Susan, wringing her    hands   _b_ _b_ _b_ _b_ _b_ ---                 
    ## [20]        --- *cried* Mr Toots, whose tender    heart   was moved by the Captain ---            
    ## [21]       --- *cried* Mr Dombey, striking his    hand    upon the table _b_ _b_ ---              
    ## [22]      --- *cried* Florence, falling on her    bosom   _b_ _b_ _b_ _b_ _b_ ---                 
    ## [23]  --- *cried* Mr. Grewgious, smoothing his    head    triumphantly _b_ _b_ _b_ _b_ ---        
    ## [24]         --- *cried* Joe, opening his blue    eyes    wide _b_ _b_ _b_ _b_ ---                
    ## [25]       --- *cried*, getting up, putting my     arm    round her neck, and giving ---          
    ## [26]    --- _b_ *cried* Bounderby, shaking his    head   , with a whistle _b_ _b_ ---             
    ## [27]       --- _b_ *cried* Lagnier, giving his    head    a twirl _b_ _b_ _b_ ---                 
    ## [28]   --- *cried* Little Dorrit, covering her    tears   with her hands _b_ _b_ ---              
    ## [29]       --- *cried* Mr Meagles, rubbing his    hands   with a relish _b_ _b_ ---               
    ## [30] --- *cried* Mistress Affery, wringing her    hands   in this last uneasy dream ---           
    ## [31]               --- _b_ _b_ _b_ _b_ *cried*    Fanny  , affrighted and bursting into tears --- 
    ## [32]               --- _b_ _b_ _b_ _b_ *cried*    Fanny  , half tolerant and half impatient ---   
    ## [33]               --- _b_ _b_ _b_ _b_ *cried*    Fanny   with an air of resignation ---          
    ## [34]          --- _b_ *cried* Mr Meagles, more breathless than before _b_ _b_ _b_ ---             
    ## [35]     --- *cried* Tigg, gravely nodding his    head    as if some ground of ---                
    ## [36]         --- _b_ *cried* Tigg, kissing his    hand    again, and beginning to follow ---      
    ## [37]      --- *cried* Mrs Todgers, raising her    eyes    and shaking her head _b_ ---            
    ## [38]        --- _b_ *cried* Mr Pecksniff whose    eyes    had in the meantime wandered ---        
    ## [39]      --- _b_ *cried* Martin, clapping his    hand    upon his mouth _b_ _b_ ---              
    ## [40]        --- _b_ *cried* Merry, nodding her    head    and giggling very much _b_ ---          
    ## [41]    --- _b_ *cried* Mr Pecksniff, shedding    tears   _b_ _b_ _b_ _b_ _b_ ---                 
    ## [42]     --- *cried* Mr Pecksniff, shaking his    head    in pity _b_ _b_ _b_ ---                 
    ## [43]   --- *cried* Nicholas, staggering to his    feet    _b_ _b_ _b_ _b_ _b_ ---                 
    ## [44]        --- *cried* his wife, flinging her    arms    about him _b_ _b_ _b_ ---               
    ## [45]   --- _b_ *cried* Nicholas, clenching his    fist    and suddenly changing his tone ---      
    ## [46]    --- _b_ *cried* Nicholas, grasping his    hand    _b_ _b_ _b_ _b_ _b_ ---                 
    ## [47]     --- *cried* Arthur Gride, shading his    eyes    with his hand _b_ _b_ ---               
    ## [48]          --- _b_ she *cried*, folding her    arms    and wagging her head _b_ ---            
    ## [49]     --- *cried* Mr Swiveller, tapping his    nose    _b_ _b_ _b_ _b_ _b_ ---                 
    ## [50]       --- _b_ *cried* Nelly, clasping her    hand    _b_ _b_ _b_ _b_ _b_ ---                 
    ## [51]         --- *cried* the old man, suddenly   rousing  himself from his state of ---           
    ## [52]             --- *cried* Kit with a rueful    face    _b_ _b_ _b_ _b_ _b_ ---                 
    ## [53]       --- _b_ *cried* Kit, trembling from    head    to foot _b_ _b_ _b_ ---                 
    ## [54]     --- _b_ *cried* Sampson, clasping his    hands   _b_ _b_ _b_ _b_ _b_ ---                 
    ## [55]   --- _b_ *cried* Georgiana, wringing her    hands   as she ran up to ---                    
    ## [56]       --- _b_ *cried* Bella, covering her    face    with her hands _b_ _b_ ---              
    ## [57]     --- *cried*, jumping fiercely up: her    face    flushed, and her eyes starting ---      
    ## [58]    --- *cried* Fagin, extending his right    hand   , and turning to Mr. Bolter ---          
    ## [59]  --- *cried* Oliver, eagerly clasping the    hand    of Rose, and pointing out ---           
    ## [60]      --- _b_ *cried* Oliver, throwing his    arms    about her neck _b_ _b_ ---              
    ## [61]      --- *cried* Miss Pross, still wildly   crying   _b_ _b_ _b_ _b_ _b_ ---

``` r
# rubbing
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("rubbing"), context = 0)
y
```

    ## [ 1]               --- _b_ he added, *rubbing* his     head    very significantly _b_ _b_ _b_ ---        
    ## [ 2]         --- he observes, slowly *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 3]            --- and slowly *rubbing* his rusty     legs    up and down, up and ---                   
    ## [ 4]          --- very slowly *rubbing* his gloved    hands   , as if, to his cold ---                   
    ## [ 5]            --- _b_ cried Miggs, *rubbing* her    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 6]             --- his hammer, and *rubbing* his     nose    on the back of a ---                      
    ## [ 7]                 --- *rubbing* his nose on the     back    of a very sooty hand ---                  
    ## [ 8]           --- said Lord George, *rubbing* his     eyes    and looking round the room ---            
    ## [ 9]            --- _b_ said Dennis, *rubbing* his     legs    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [10]                --- ' further *rubbing* of his     chin    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [11]             --- Mr. Omer, after *rubbing* his     chin    again, and smoking a little ---           
    ## [12]         --- he returned, *rubbing* his double     chin    again _b_ _b_ _b_ _b_ ---                 
    ## [13]              --- beside us, and *rubbing* his    hands    in his sense of relief ---                
    ## [14]            --- Mr. Peggotty, with a delighted     face   , after some further *rubbing* of ---      
    ## [15]             --- some further *rubbing* of his     legs    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [16]           --- observed my aunt, *rubbing* her     nose    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [17]          --- explained my aunt, *rubbing* her     nose    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [18]                --- his hat, and *rubbing* his     hair    all kinds of ways _b_ ---                 
    ## [19]          --- said Mr. Littimer, *rubbing* his    hands    uneasily _b_ _b_ _b_ _b_ ---              
    ## [20]              --- said Mr. Omer, *rubbing* his    hands    feebly _b_ _b_ _b_ _b_ ---                
    ## [21]                      --- _b_ _b_ _b_ said the unconscious MacStinger, *rubbing* her hands _b_ ---   
    ## [22] --- the unconscious MacStinger, *rubbing* her    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [23]               --- *rubbing* the bridge of his     nose    for some time with his ---                
    ## [24]         --- said the gentleman, *rubbing* his   forehead  again; and drumming on the ---            
    ## [25]         --- said the gentleman, *rubbing* his     head   , as despondently as before _b_ ---        
    ## [26]          --- some time silently *rubbing* his     chin   , with his eyes fixed upon ---             
    ## [27]              --- *rubbing* his chin, with his     eyes    fixed upon her _b_ _b_ ---                
    ## [28]                --- the old woman, shaking her     head   , and *rubbing* her shrivelled hands ---   
    ## [29]        --- head, and *rubbing* her shrivelled    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [30]              --- little more *rubbing* of his     ear     _b_ _b_ _b_ _b_ _b_ ---                   
    ## [31]        --- said Mr. Crisparkle, *rubbing* his     ear    , as his mother resumed her ---            
    ## [32]         --- he continued, after *rubbing* his    knees    a little, " when you do ---               
    ## [33]           --- cried Mr Meagles, *rubbing* his    hands    with a relish _b_ _b_ ---                 
    ## [34]              --- _b_ said Mark, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [35]              --- _b_ said Mark, *rubbing* his     nose    with the knob at the ---                  
    ## [36]          --- _b_ observed Poll, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [37]             --- Miss La Creevy, *rubbing* her    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [38]           --- _b_ said Squeers, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [39]             --- _b_ said Ralph, *rubbing* his    hands    slowly over each other _b_ ---            
    ## [40]         --- said Mr Wititterly, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [41]       --- _b_ returned Squeers, *rubbing* his    knees    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [42]          --- said Mrs Nickleby, *rubbing* her     nose    with an impassioned air _b_ ---           
    ## [43]         --- resumed Mr Squeers, *rubbing* his    knees    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [44]                 --- said the boy, nodding his     head    and *rubbing* it at the ---               
    ## [45]             --- _b_ said Quilp, *rubbing* his  shoulders  _b_ _b_ _b_ _b_ _b_ ---                   
    ## [46]            --- added the dwarf, *rubbing* his    hands    hard _b_ _b_ _b_ _b_ ---                  
    ## [47]       --- Miss Potterson, *rubbing* her vexed     nose    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [48]             --- said Mr Boffin, *rubbing* his     ear     _b_ _b_ _b_ _b_ _b_ ---                   
    ## [49]             --- said Mr Boffin, *rubbing* his    hands    in his pleasantly childish admiration --- 
    ## [50]   --- the last-named gentleman, *rubbing* his    knees    peevishly _b_ _b_ _b_ _b_ ---             
    ## [51]         --- cherub, smiling and *rubbing* his    hands    as she sat him down ---                   
    ## [52]           --- chuckled the Jew, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [53]      --- observed Mr. Pickwick, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [54]       --- exclaimed Mr. Weller, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [55]            --- said Bob Sawyer, *rubbing* his    hands    _b_ _b_ _b_ _b_ _b_ ---

``` r
# shaking
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("shaking"), context = 0)
y
```

    ## [  1]              --- _b_ said Ada, clasping her   hands  upon his arm and *shaking* ---           
    ## [  2]             --- clasping her hands upon his    arm   and *shaking* her head at ---            
    ## [  3]               --- his arm and *shaking* her   head   at me across him -- ---                  
    ## [  4]              --- _b_ said he, *shaking* his   head   pleasantly _b_ _b_ _b_ _b_ ---           
    ## [  5]                    --- _b_ he said with his   hand   upon his heart and *shaking* ---         
    ## [  6]                  --- with his hand upon his   heart  and *shaking* his head at ---            
    ## [  7]             --- his heart and *shaking* his   head   at me in a melancholy ---                
    ## [  8]           --- _b_ cries Judy, *shaking* her   head   and stamping her foot as ---             
    ## [  9]       --- Caddy, laughing and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 10]         --- pursuing it after *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 11]     --- returns Mrs. Snagsby, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 12]                --- _b_ said I, *shaking* my   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 13]        --- Mr. Vholes, gently *shaking* his   head   and rapping the hollow desk, ---         
    ## [ 14]         --- says Mr. Snagsby, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 15]           --- _b_ replies Jo, *shaking* his   head   fearfully _b_ _b_ _b_ _b_ ---            
    ## [ 16]          --- says Mr. George, *shaking* his   head   sorrowfully _b_ _b_ _b_ _b_ ---          
    ## [ 17]   --- returned Mr. Woodcourt, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 18]         --- says the trooper, *shaking* his   head   very doubtfully _b_ _b_ _b_ ---          
    ## [ 19]        --- said Mr. Skimpole, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 20]   --- returned the locksmith, *shaking* his   head  , and smiling _b_ _b_ _b_ ---             
    ## [ 21]          --- *shaking* the locksmith by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 22]            --- his voice, and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 23]      --- _b_ retorted Dennis, *shaking* his   head  , with a kind of pity ---                 
    ## [ 24]          --- Gashford, *shaking* him by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 25]            --- the blind man, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 26]   --- observed the gentleman, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 27]             --- his wife, and *shaking* his   head   sorrowfully, while a smile at ---        
    ## [ 28]         --- Hugh, *shaking* back his ragged   hair   and glancing towards the door ---        
    ## [ 29]     --- returned Mr Haredale, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 30]   --- observed the clergyman, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 31]        --- _b_ replied Em'ly, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 32]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 33]           --- Creakle, *shaking* him by the    arm  ; and his whisper was so ---              
    ## [ 34]        --- said Mr. Peggotty, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 35]                --- _b_ said I, *shaking* my   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 36]        --- said Mr. Micawber, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 37]             --- said my aunt, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 38]             --- _b_ she said, *shaking* her  finger  at him _b_ _b_ _b_ ---                   
    ## [ 39]       --- _b_ returned Uriah, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 40]       --- pursued her mother, *shaking* her   head   and her fan at her, ---                  
    ## [ 41]  --- returned Mrs. Markleham, *shaking* her   head   and her fan _b_ _b_ ---                  
    ## [ 42]                 --- at me and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 43]            --- said Mr. Omer, *shaking* his   head   gently _b_ _b_ _b_ _b_ ---               
    ## [ 44]         --- the little woman, *shaking* her   head   at me, with reproachful earnestness ---  
    ## [ 45]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 46]         --- said Dora, slightly raising her eyebrows, and *shaking* her head _b_ ---          
    ## [ 47]         --- her eyebrows, and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 48]             --- said my aunt, *shaking* her   head  , and smiling gravely _b_ _b_ ---         
    ## [ 49]     --- sentiment, and slowly *shaking* his   head   as he poised himself upon ---            
    ## [ 50]       --- unpleasant way, and *shaking* his   head   at me _b_ _b_ _b_ ---                    
    ## [ 51]     --- he replied, patiently *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 52]        --- said Mr. Peggotty, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 53]        --- said Mr. Peggotty, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 54]       --- said Mrs. Micawber, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 55]  --- Mrs. Micawber, pensively *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 56]       --- said Mrs. Micawber, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 57]          --- very meekly, and *shaking* his   head   as he surveyed me _b_ ---                
    ## [ 58]    --- Chillip, slowly *shaking* his little   head   again _b_ _b_ _b_ _b_ ---                
    ## [ 59]      --- Mr. Wickfield, *shaking* his white   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 60]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 61]     --- _b_ pursued Spitfire, *shaking* her   head   resolutely _b_ _b_ _b_ _b_ ---           
    ## [ 62]             --- glistening of her hard grey    eye  , and a dreary *shaking* of ---           
    ## [ 63]            --- dreary *shaking* of her bent   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 64]          --- said the Doctor, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 65]           --- said Mr Carker, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 66]           --- *shaking* him heartily by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 67]           --- said Mrs Chick, *shaking* her   head   with energy, and arranging herself ---   
    ## [ 68]         --- said the Captain, *shaking* his   head   slowly _b_ _b_ _b_ _b_ ---               
    ## [ 69]           --- _b_ he replied, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [ 70]            --- the old woman, *shaking* her   head   and laughing; for her daughter ---       
    ## [ 71]                --- towards the sky, and her   head   thrown back and *shaking* _b_ ---        
    ## [ 72]             --- her face, and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 73]            --- the old woman, *shaking* her   head  , and rubbing her shrivelled hands ---    
    ## [ 74]          --- Brown came back, *shaking* its   head   and chattering to itself _b_ ---         
    ## [ 75]            --- said Mr Perch, *shaking* his   head   and speaking in a silvery ---            
    ## [ 76]           --- out afresh, and *shaking* her   head   violently _b_ _b_ _b_ _b_ ---            
    ## [ 77]         --- said the Captain, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 78]           --- _b_ cries Rosa, *shaking* her   head   and bursting into real tears ---         
    ## [ 79]          --- the Minor Canon, *shaking* his   head   with a sorrowful smile _b_ ---           
    ## [ 80]    --- said Mr. Honeythunder, *shaking* his   head   again _b_ _b_ _b_ _b_ ---                
    ## [ 81]            --- said, *shaking* his shock of   hair  , as a Newfoundland dog might ---         
    ## [ 82]           --- said my sister, *shaking* her   head   at me as an encouragement ---            
    ## [ 83]       --- _b_ he interrupted, *shaking* his   head   and frowning and smiling both ---        
    ## [ 84]     --- interrupted, *shaking* his head and frowning and smiling both at once ---             
    ## [ 85]                 --- at me and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 86]      --- _b_ replied Wemmick, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 87]          --- _b_ he returned, *shaking* his   head   at me with a deliberate ---              
    ## [ 88]  --- upon this encouragement, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 89]    --- said Slackbridge then, *shaking* his   head   with violent scorn _b_ _b_ ---           
    ## [ 90]           --- his patron, but *shaking* his   head   sullenly too _b_ _b_ _b_ ---             
    ## [ 91]      --- _b_ cried Bounderby, *shaking* his   head  , with a whistle _b_ _b_ ---              
    ## [ 92]          --- _b_ said Bitzer, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 93]      --- _b_ repeated Sleary, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 94]         --- raised again, and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 95]       --- returned Mrs Gowan, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 96]           --- Meagles, *shaking* him by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 97]     --- Mrs Gowan, *shaking* her despondent   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 98]           --- said the other, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 99]     --- observed her brother, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [100]        --- Gowan, smiling and *shaking* her   head   with accusatory intelligence _b_ _b_ --- 
    ## [101]           --- Meagles, *shaking* him by the   hand   stoutly _b_ _b_ _b_ _b_ ---              
    ## [102]          --- said Mr Meagles, *shaking* his   head   very seriously _b_ _b_ _b_ ---           
    ## [103]     --- silently smiling, and *shaking* his   head   at the fire _b_ _b_ ---                  
    ## [104]         --- said the hostess, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [105]     --- *shaking* his forefinger before his   nose  , and planting his legs wider ---         
    ## [106]            --- _b_ said Mark, *shaking* his   head   argumentatively _b_ _b_ _b_ _b_ ---      
    ## [107]          --- cried Mrs Todgers, raising her   eyes   and *shaking* her head _b_ ---           
    ## [108]              --- her eyes and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [109]             --- _b_ said Tom, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [110]            --- _b_ said Mark, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [111]          --- _b_ he answered, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [112]             --- a moment, and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [113]      --- returned the doctor, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [114]          --- _b_ replied Tom, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [115]       --- _b_ said Pecksniff, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [116]           --- said Mr Tapley, *shaking* his   head   with a rueful air _b_ ---                
    ## [117]          --- said the doctor, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [118]        --- said Mr Pecksniff, *shaking* his   hand   vigorously _b_ _b_ _b_ _b_ ---           
    ## [119]        --- said Mr Pecksniff, *shaking* his   head   at Martin with indignant jocularity ---  
    ## [120]       --- cried Mr Pecksniff, *shaking* his   head   in pity _b_ _b_ _b_ ---                  
    ## [121]             --- _b_ said Tom, *shaking* his   head   as if this were a ---                    
    ## [122]            --- said Mrs Gamp, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [123]            --- said Mrs Gamp, *shaking* her   head  , and shedding tears _b_ _b_ ---          
    ## [124]     --- _b_ replied Nicholas, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [125]        --- said Mr Lillyvick, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [126]           --- _b_ said Smike, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [127]        --- the poor creature, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [128]      --- replied Mr Crummles, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [129]                 --- _b_ _b_ _b_ said Ralph, scowling round, and *shaking* his clenched ---    
    ## [130]       --- round, and *shaking* his clenched   hand   as the faces of the ---                  
    ## [131]         --- said Mr Crummles, *shaking* his   fist   at the comic countryman when ---         
    ## [132]        --- _b_ said Nicholas, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [133]     --- Mrs Nickleby, gravely *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [134]        --- _b_ said Nicholas, *shaking* his   head  , and making an attempt to ---            
    ## [135]             --- _b_ said Peg, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [136] --- returned brother Charles, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [137]             --- _b_ said Dick *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [138]             --- _b_ said Dick *shaking* his   head   with a look of infinite ---              
    ## [139] --- rejoined the schoolmaster *shaking* his   head   sorrowfully _b_ _b_ _b_ _b_ ---          
    ## [140]    --- said the schoolmaster, *shaking* his   head  , and smiling thoughtfully _b_ _b_ ---    
    ## [141]            --- _b_ added Kit, *shaking* his   head   sorrowfully _b_ _b_ _b_ _b_ ---          
    ## [142]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [143]           --- said the lawyer *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [144]              --- the old man, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [145]        --- said Mr Chuckster, *shaking* his   head   gravely, as men are wont ---             
    ## [146]       --- Mr Podsnap, gravely *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [147]    --- slightly colouring and *shaking* her   head  , a little out of humour ---              
    ## [148] --- business-like manner, and *shaking* her   head   and her chin _b_ _b_ ---                 
    ## [149]              --- *shaking* her head and her   chin   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [150]          --- _b_ said Lizzie, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [151]          --- the man, sternly *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [152]       --- the doctor, gravely *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [153]   --- _b_ returned Sophronia, *shaking* her   head  , and smiling her best smile ---          
    ## [154]        --- shrugging his shoulders with his   hands  in his pockets, and *shaking* ---        
    ## [155]          --- his pockets, and *shaking* his   head   in a sulkily ominous manner ---          
    ## [156]           --- _b_ said Jenny, *shaking* her   head   and her emphatic little forefinger ---   
    ## [157]            --- bonnet and *shaking* out her   hair   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [158]       --- _b_ said Riderhood, *shaking* his   head   with an air of thorough ---              
    ## [159]        --- _b_ returned Wegg, *shaking* his   head   sagaciously, and bestowing a wooden ---  
    ## [160]  --- Mr Sampson remonstrated, *shaking* his   head   seriously _b_ _b_ _b_ _b_ ---            
    ## [161]            --- the button and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [162]         --- said young Hexam, *shaking* his   head   in a half-threatening manner _b_ ---     
    ## [163]        --- said Eugene, again *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [164]   --- the surgeon, mournfully *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [165]                   --- with his hat over his   ears  , and *shaking* all over, as ---          
    ## [166]             --- the old lady, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [167]           --- said Mr. Roker, *shaking* his   head   slowly from side to side, ---            
    ## [168]     --- rejoined the cobbler, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [169]           --- _b_ said Roker, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [170]           --- and *shaking* Mrs. Sanders to   wake   her _b_ _b_ _b_ _b_ ---                  
    ## [171]        --- _b_ rejoined Mary, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [172]         --- _b_ said Stryver, *shaking* his   head   in his bullying way _b_ ---              
    ## [173]  --- returned that gentleman, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [174]  --- Jacques Three, dubiously *shaking* his   head  , with his cruel fingers at ---           
    ## [175]  --- Cruncher, hesitating and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---

``` r
# nodding
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("shaking"), context = 0)
y
```

    ## [  1]              --- _b_ said Ada, clasping her   hands  upon his arm and *shaking* ---           
    ## [  2]             --- clasping her hands upon his    arm   and *shaking* her head at ---            
    ## [  3]               --- his arm and *shaking* her   head   at me across him -- ---                  
    ## [  4]              --- _b_ said he, *shaking* his   head   pleasantly _b_ _b_ _b_ _b_ ---           
    ## [  5]                    --- _b_ he said with his   hand   upon his heart and *shaking* ---         
    ## [  6]                  --- with his hand upon his   heart  and *shaking* his head at ---            
    ## [  7]             --- his heart and *shaking* his   head   at me in a melancholy ---                
    ## [  8]           --- _b_ cries Judy, *shaking* her   head   and stamping her foot as ---             
    ## [  9]       --- Caddy, laughing and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 10]         --- pursuing it after *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 11]     --- returns Mrs. Snagsby, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 12]                --- _b_ said I, *shaking* my   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 13]        --- Mr. Vholes, gently *shaking* his   head   and rapping the hollow desk, ---         
    ## [ 14]         --- says Mr. Snagsby, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 15]           --- _b_ replies Jo, *shaking* his   head   fearfully _b_ _b_ _b_ _b_ ---            
    ## [ 16]          --- says Mr. George, *shaking* his   head   sorrowfully _b_ _b_ _b_ _b_ ---          
    ## [ 17]   --- returned Mr. Woodcourt, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 18]         --- says the trooper, *shaking* his   head   very doubtfully _b_ _b_ _b_ ---          
    ## [ 19]        --- said Mr. Skimpole, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 20]   --- returned the locksmith, *shaking* his   head  , and smiling _b_ _b_ _b_ ---             
    ## [ 21]          --- *shaking* the locksmith by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 22]            --- his voice, and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 23]      --- _b_ retorted Dennis, *shaking* his   head  , with a kind of pity ---                 
    ## [ 24]          --- Gashford, *shaking* him by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 25]            --- the blind man, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 26]   --- observed the gentleman, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 27]             --- his wife, and *shaking* his   head   sorrowfully, while a smile at ---        
    ## [ 28]         --- Hugh, *shaking* back his ragged   hair   and glancing towards the door ---        
    ## [ 29]     --- returned Mr Haredale, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 30]   --- observed the clergyman, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 31]        --- _b_ replied Em'ly, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 32]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 33]           --- Creakle, *shaking* him by the    arm  ; and his whisper was so ---              
    ## [ 34]        --- said Mr. Peggotty, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 35]                --- _b_ said I, *shaking* my   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 36]        --- said Mr. Micawber, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 37]             --- said my aunt, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 38]             --- _b_ she said, *shaking* her  finger  at him _b_ _b_ _b_ ---                   
    ## [ 39]       --- _b_ returned Uriah, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 40]       --- pursued her mother, *shaking* her   head   and her fan at her, ---                  
    ## [ 41]  --- returned Mrs. Markleham, *shaking* her   head   and her fan _b_ _b_ ---                  
    ## [ 42]                 --- at me and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 43]            --- said Mr. Omer, *shaking* his   head   gently _b_ _b_ _b_ _b_ ---               
    ## [ 44]         --- the little woman, *shaking* her   head   at me, with reproachful earnestness ---  
    ## [ 45]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 46]         --- said Dora, slightly raising her eyebrows, and *shaking* her head _b_ ---          
    ## [ 47]         --- her eyebrows, and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 48]             --- said my aunt, *shaking* her   head  , and smiling gravely _b_ _b_ ---         
    ## [ 49]     --- sentiment, and slowly *shaking* his   head   as he poised himself upon ---            
    ## [ 50]       --- unpleasant way, and *shaking* his   head   at me _b_ _b_ _b_ ---                    
    ## [ 51]     --- he replied, patiently *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 52]        --- said Mr. Peggotty, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 53]        --- said Mr. Peggotty, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 54]       --- said Mrs. Micawber, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 55]  --- Mrs. Micawber, pensively *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 56]       --- said Mrs. Micawber, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 57]          --- very meekly, and *shaking* his   head   as he surveyed me _b_ ---                
    ## [ 58]    --- Chillip, slowly *shaking* his little   head   again _b_ _b_ _b_ _b_ ---                
    ## [ 59]      --- Mr. Wickfield, *shaking* his white   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 60]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 61]     --- _b_ pursued Spitfire, *shaking* her   head   resolutely _b_ _b_ _b_ _b_ ---           
    ## [ 62]             --- glistening of her hard grey    eye  , and a dreary *shaking* of ---           
    ## [ 63]            --- dreary *shaking* of her bent   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 64]          --- said the Doctor, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 65]           --- said Mr Carker, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 66]           --- *shaking* him heartily by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 67]           --- said Mrs Chick, *shaking* her   head   with energy, and arranging herself ---   
    ## [ 68]         --- said the Captain, *shaking* his   head   slowly _b_ _b_ _b_ _b_ ---               
    ## [ 69]           --- _b_ he replied, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [ 70]            --- the old woman, *shaking* her   head   and laughing; for her daughter ---       
    ## [ 71]                --- towards the sky, and her   head   thrown back and *shaking* _b_ ---        
    ## [ 72]             --- her face, and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 73]            --- the old woman, *shaking* her   head  , and rubbing her shrivelled hands ---    
    ## [ 74]          --- Brown came back, *shaking* its   head   and chattering to itself _b_ ---         
    ## [ 75]            --- said Mr Perch, *shaking* his   head   and speaking in a silvery ---            
    ## [ 76]           --- out afresh, and *shaking* her   head   violently _b_ _b_ _b_ _b_ ---            
    ## [ 77]         --- said the Captain, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 78]           --- _b_ cries Rosa, *shaking* her   head   and bursting into real tears ---         
    ## [ 79]          --- the Minor Canon, *shaking* his   head   with a sorrowful smile _b_ ---           
    ## [ 80]    --- said Mr. Honeythunder, *shaking* his   head   again _b_ _b_ _b_ _b_ ---                
    ## [ 81]            --- said, *shaking* his shock of   hair  , as a Newfoundland dog might ---         
    ## [ 82]           --- said my sister, *shaking* her   head   at me as an encouragement ---            
    ## [ 83]       --- _b_ he interrupted, *shaking* his   head   and frowning and smiling both ---        
    ## [ 84]     --- interrupted, *shaking* his head and frowning and smiling both at once ---             
    ## [ 85]                 --- at me and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 86]      --- _b_ replied Wemmick, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 87]          --- _b_ he returned, *shaking* his   head   at me with a deliberate ---              
    ## [ 88]  --- upon this encouragement, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 89]    --- said Slackbridge then, *shaking* his   head   with violent scorn _b_ _b_ ---           
    ## [ 90]           --- his patron, but *shaking* his   head   sullenly too _b_ _b_ _b_ ---             
    ## [ 91]      --- _b_ cried Bounderby, *shaking* his   head  , with a whistle _b_ _b_ ---              
    ## [ 92]          --- _b_ said Bitzer, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 93]      --- _b_ repeated Sleary, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 94]         --- raised again, and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 95]       --- returned Mrs Gowan, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 96]           --- Meagles, *shaking* him by the   hand   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 97]     --- Mrs Gowan, *shaking* her despondent   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 98]           --- said the other, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 99]     --- observed her brother, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [100]        --- Gowan, smiling and *shaking* her   head   with accusatory intelligence _b_ _b_ --- 
    ## [101]           --- Meagles, *shaking* him by the   hand   stoutly _b_ _b_ _b_ _b_ ---              
    ## [102]          --- said Mr Meagles, *shaking* his   head   very seriously _b_ _b_ _b_ ---           
    ## [103]     --- silently smiling, and *shaking* his   head   at the fire _b_ _b_ ---                  
    ## [104]         --- said the hostess, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [105]     --- *shaking* his forefinger before his   nose  , and planting his legs wider ---         
    ## [106]            --- _b_ said Mark, *shaking* his   head   argumentatively _b_ _b_ _b_ _b_ ---      
    ## [107]          --- cried Mrs Todgers, raising her   eyes   and *shaking* her head _b_ ---           
    ## [108]              --- her eyes and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [109]             --- _b_ said Tom, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [110]            --- _b_ said Mark, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [111]          --- _b_ he answered, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [112]             --- a moment, and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [113]      --- returned the doctor, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [114]          --- _b_ replied Tom, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [115]       --- _b_ said Pecksniff, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [116]           --- said Mr Tapley, *shaking* his   head   with a rueful air _b_ ---                
    ## [117]          --- said the doctor, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [118]        --- said Mr Pecksniff, *shaking* his   hand   vigorously _b_ _b_ _b_ _b_ ---           
    ## [119]        --- said Mr Pecksniff, *shaking* his   head   at Martin with indignant jocularity ---  
    ## [120]       --- cried Mr Pecksniff, *shaking* his   head   in pity _b_ _b_ _b_ ---                  
    ## [121]             --- _b_ said Tom, *shaking* his   head   as if this were a ---                    
    ## [122]            --- said Mrs Gamp, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [123]            --- said Mrs Gamp, *shaking* her   head  , and shedding tears _b_ _b_ ---          
    ## [124]     --- _b_ replied Nicholas, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [125]        --- said Mr Lillyvick, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [126]           --- _b_ said Smike, *shaking* his   head   mournfully _b_ _b_ _b_ _b_ ---           
    ## [127]        --- the poor creature, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [128]      --- replied Mr Crummles, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [129]                 --- _b_ _b_ _b_ said Ralph, scowling round, and *shaking* his clenched ---    
    ## [130]       --- round, and *shaking* his clenched   hand   as the faces of the ---                  
    ## [131]         --- said Mr Crummles, *shaking* his   fist   at the comic countryman when ---         
    ## [132]        --- _b_ said Nicholas, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [133]     --- Mrs Nickleby, gravely *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [134]        --- _b_ said Nicholas, *shaking* his   head  , and making an attempt to ---            
    ## [135]             --- _b_ said Peg, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [136] --- returned brother Charles, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [137]             --- _b_ said Dick *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [138]             --- _b_ said Dick *shaking* his   head   with a look of infinite ---              
    ## [139] --- rejoined the schoolmaster *shaking* his   head   sorrowfully _b_ _b_ _b_ _b_ ---          
    ## [140]    --- said the schoolmaster, *shaking* his   head  , and smiling thoughtfully _b_ _b_ ---    
    ## [141]            --- _b_ added Kit, *shaking* his   head   sorrowfully _b_ _b_ _b_ _b_ ---          
    ## [142]              --- _b_ he said, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [143]           --- said the lawyer *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [144]              --- the old man, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [145]        --- said Mr Chuckster, *shaking* his   head   gravely, as men are wont ---             
    ## [146]       --- Mr Podsnap, gravely *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [147]    --- slightly colouring and *shaking* her   head  , a little out of humour ---              
    ## [148] --- business-like manner, and *shaking* her   head   and her chin _b_ _b_ ---                 
    ## [149]              --- *shaking* her head and her   chin   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [150]          --- _b_ said Lizzie, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [151]          --- the man, sternly *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [152]       --- the doctor, gravely *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [153]   --- _b_ returned Sophronia, *shaking* her   head  , and smiling her best smile ---          
    ## [154]        --- shrugging his shoulders with his   hands  in his pockets, and *shaking* ---        
    ## [155]          --- his pockets, and *shaking* his   head   in a sulkily ominous manner ---          
    ## [156]           --- _b_ said Jenny, *shaking* her   head   and her emphatic little forefinger ---   
    ## [157]            --- bonnet and *shaking* out her   hair   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [158]       --- _b_ said Riderhood, *shaking* his   head   with an air of thorough ---              
    ## [159]        --- _b_ returned Wegg, *shaking* his   head   sagaciously, and bestowing a wooden ---  
    ## [160]  --- Mr Sampson remonstrated, *shaking* his   head   seriously _b_ _b_ _b_ _b_ ---            
    ## [161]            --- the button and *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [162]         --- said young Hexam, *shaking* his   head   in a half-threatening manner _b_ ---     
    ## [163]        --- said Eugene, again *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [164]   --- the surgeon, mournfully *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [165]                   --- with his hat over his   ears  , and *shaking* all over, as ---          
    ## [166]             --- the old lady, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [167]           --- said Mr. Roker, *shaking* his   head   slowly from side to side, ---            
    ## [168]     --- rejoined the cobbler, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [169]           --- _b_ said Roker, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [170]           --- and *shaking* Mrs. Sanders to   wake   her _b_ _b_ _b_ _b_ ---                  
    ## [171]        --- _b_ rejoined Mary, *shaking* her   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [172]         --- _b_ said Stryver, *shaking* his   head   in his bullying way _b_ ---              
    ## [173]  --- returned that gentleman, *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [174]  --- Jacques Three, dubiously *shaking* his   head  , with his cruel fingers at ---           
    ## [175]  --- Cruncher, hesitating and *shaking* his   head   _b_ _b_ _b_ _b_ _b_ ---

``` r
# laying
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("laying"), context = 0)
y
```

    ## [ 1]                 --- to us, and *laying* his   hand   gently on her arm _b_ ---             
    ## [ 2]          --- said my guardian, *laying* his   hand   emphatically on the sleeve of ---     
    ## [ 3]                 --- _b_ said I, *laying* my   face   against her forehead, for indeed ---  
    ## [ 4]            --- *laying* my face against her forehead, for indeed I was crying ---          
    ## [ 5]         --- said Mr Tappertit, *laying* his   hand   upon his breast _b_ _b_ ---           
    ## [ 6]              --- *laying* his hand upon his  breast  _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 7]             --- and *laying* his broad flat   hand   upon the table _b_ _b_ ---            
    ## [ 8]               --- her seat and *laying* her   hand   upon his shoulder _b_ _b_ ---         
    ## [ 9]              --- *laying* her hand upon his shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [10]            --- the widow, *laying* both her   hands  upon his breast, and scarcely ---     
    ## [11]            --- _b_ said Simon, *laying* his   hand   upon his breast, 'not a ---           
    ## [12]              --- *laying* his hand upon his  breast , 'not a _b_ _b_ _b_ ---               
    ## [13]       --- _b_ said Barnaby, withdrawing his   hand   from the bird, and *laying* ---       
    ## [14]              --- said my aunt, *laying* her   hand   with melancholy firmness on the ---   
    ## [15]                --- _b_ _b_ _b_ *laying* her   head   upon his shoulder _b_ _b_ ---         
    ## [16]              --- *laying* her head upon his shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [17] --- Wickfield again *laying* his irresolute   hand   upon the Doctor 's arm ---            
    ## [18]          --- chair nearer, and *laying* one   hand   upon my knee _b_ _b_ ---              
    ## [19]               --- *laying* one hand upon my   knee   _b_ _b_ _b_ _b_ _b_ ---               
    ## [20]         --- my aunt proceeded, *laying* her   hand   as usual on the back ---              
    ## [21]       --- he continued, mildly *laying* his   head   on one side _b_ _b_ ---               
    ## [22]            --- said the child, *laying* his   hands  upon the elbows of his ---            
    ## [23]             --- *laying* his hands upon the  elbows  of his little chair, and ---          
    ## [24]                --- son 's, and *laying* his   hand   gently on his back _b_ ---            
    ## [25]             --- he said gaily, *laying* his   hand   upon the old man 's ---               
    ## [26]         --- _b_ said Florence, *laying* her   hand   timidly upon the old man ---          
    ## [27]            --- said the Major, *laying* his  finger  on his lips, and speaking ---         
    ## [28]              --- *laying* his finger on his   lips  , and speaking half apart to ---       
    ## [29]              --- _b_ he added, *laying* his   hand   gently on her arm, for ---            
    ## [30]          --- and softly *laying* his velvet   hand  , as a cat might have ---              
    ## [31]        --- said Mr. Grewgious, *laying* his   hand   on Rosa 's, as the ---                
    ## [32]                 --- _b_ said I, *laying* my   hand   upon his knee _b_ _b_ ---             
    ## [33]               --- *laying* my hand upon his   knee   _b_ _b_ _b_ _b_ _b_ ---               
    ## [34]            --- _b_ said Biddy, *laying* her   hand   upon my arm, as I ---                 
    ## [35]               --- *laying* her hand upon my    arm  , as I was for running ---             
    ## [36]              --- voice, and *laying* a long  finger  on my breast in an ---                
    ## [37]               --- _b_ said he, *laying* his   hand   on my arm in a ---                    
    ## [38]                 --- *laying* his hand on my    arm   in a suddenly altered and ---         
    ## [39]          --- said Mr. Jaggers, *laying* his   hand   upon my arm, and smiling ---          
    ## [40]               --- *laying* his hand upon my    arm  , and smiling openly _b_ _b_ ---       
    ## [41]               --- to side, and *laying* her   chin   upon the little hand as ---           
    ## [42]           --- and *laying* his closed right   hand  , with its peculiar suppleness of ---  
    ## [43]         --- of the Marshalsea, *laying* his   hand   upon his shoulder, and mildly ---     
    ## [44]              --- *laying* his hand upon his shoulder, and mildly rallying him -- ---       
    ## [45]        --- *laying* that plastic workman 's   thumb  of his on the lapel ---               
    ## [46]     --- window-seat, and *laying* his right   hand   upon the stocking _b_ _b_ ---         
    ## [47]            --- the young lady, *laying* her   hand   upon his arm _b_ _b_ ---              
    ## [48]              --- *laying* her hand upon his    arm   _b_ _b_ _b_ _b_ _b_ ---               
    ## [49]         --- _b_ added Anthony, *laying* his   hand   upon his sleeve _b_ _b_ ---           
    ## [50]         --- said Mr Pecksniff, *laying* his   hand   tenderly upon his kinsman 's ---      
    ## [51]         --- great feeling, and *laying* her   hand   upon her arm _b_ _b_ ---              
    ## [52]              --- *laying* her hand upon her    arm   _b_ _b_ _b_ _b_ _b_ ---               
    ## [53]     --- resumed John Westlock, *laying* his   hand   on Tom 's wrist, to ---               
    ## [54]              --- said the lad, *laying* his   hand   timidly on that of Nicholas ---       
    ## [55]     --- _b_ rejoined Nicholas, *laying* his   hand   upon his shoulder _b_ _b_ ---         
    ## [56]              --- *laying* his hand upon his shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [57]     --- _b_ rejoined Nicholas, *laying* his   hand   upon the scrapbook _b_ _b_ ---        
    ## [58]               --- old man, and *laying* her    arm   upon his shoulder _b_ _b_ ---         
    ## [59]               --- *laying* her arm upon his shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [60]         --- said Mrs Nickleby, *laying* her   hand   on Kate 's _b_ _b_ ---                
    ## [61]         --- the old gentleman, *laying* his  finger  on his nose, with an ---              
    ## [62]              --- *laying* his finger on his   nose  , with an air of familiarity, ---      
    ## [63]               --- _b_ he said, *laying* his   hand   on Newman 's _b_ _b_ ---              
    ## [64]         --- the old gentleman, *laying* his   hand   upon his brother 's shoulder ---      
    ## [65]                --- the old man *laying* his   hand   upon her mouth _b_ _b_ ---            
    ## [66]              --- *laying* his hand upon her   mouth  _b_ _b_ _b_ _b_ _b_ ---               
    ## [67]         --- the old gentleman, *laying* his   hand   upon her head, and smiling ---        
    ## [68]              --- *laying* his hand upon her   head  , and smiling sadly _b_ _b_ ---        
    ## [69]          --- said Brass, *laying* his right   hand   on his waistcoat, and looking ---     
    ## [70]      --- gentleman rising, and *laying* his   hand   on Kit 's shoulder _b_ ---            
    ## [71]      --- light interruption, and *laying* a   hand   upon Eugene 's shoulder, as ---       
    ## [72]       --- her opportunity, and *laying* her   hand   persuasively on her arm _b_ ---       
    ## [73]            --- said Mr Boffin, *laying* his   hand   on Bella 's head again ---            
    ## [74]           --- she repressed by *laying* her   hand   on her neat methodical boddice ---    
    ## [75]          --- said Mrs. Maylie, *laying* her  finger  on her lip, as she ---                
    ## [76]              --- *laying* her finger on her    lip  , as she looked steadily into ---      
    ## [77]      --- returned Mrs. Maylie, *laying* her   hand   upon his shoulder _b_ _b_ ---         
    ## [78]              --- *laying* her hand upon his shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [79]                --- to him, and *laying* his   hand   upon his head _b_ _b_ ---             
    ## [80]              --- *laying* his hand upon his   head   _b_ _b_ _b_ _b_ _b_ ---               
    ## [81]         --- said Mr. Pickwick, *laying* his   hand   gently and compassionately on his --- 
    ## [82]         --- _b_ rejoined Pott, *laying* his   hand   on Mr. Pickwick 's knee, ---          
    ## [83]          --- _b_ added Perker, *laying* his   hand   on Mr. Pickwick 's shoulder ---       
    ## [84]          --- Mr. Lorry, gently *laying* his   hand   on the Doctor 's arm ---              
    ## [85]             --- nearer to him, *laying* her   head   upon his breast, and raising ---      
    ## [86]              --- *laying* her head upon his  breast , and raising her eyes to ---          
    ## [87]             --- his story, and *laying* his   hand   on hers _b_ _b_ _b_ ---               
    ## [88]        --- Doctor, rising, and *laying* his   hand   upon her shoulder _b_ _b_ ---         
    ## [89]              --- *laying* his hand upon her shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [90]       --- said Madame Defarge, *laying* her   hand   with a slight frown on ---

``` r
# glancing
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("glancing"), context = 0)
y
```

    ## [ 1] --- cried Barnaby, *glancing* over his shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 2]     --- Mr Willet, *glancing* over his shoulder at the organ in question ---          
    ## [ 3]      --- Hugh, shaking back his ragged   hair   and *glancing* towards the door ---   
    ## [ 4]              --- on each of her little   knees , and *glancing* shrewdly at me ---    
    ## [ 5]               --- meet in front of his   chin  , and *glancing* at me sideways ---    
    ## [ 6]     --- said Walter, *glancing* at her   foot   _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 7]     --- _b_ *glancing* at the downcast   eyes   of Florence, and not attempting ---   
    ## [ 8]   --- she replied, *glancing* over her shoulder as he slouched after us ---           
    ## [ 9]    --- said Biddy, *glancing* over her shoulder again _b_ _b_ _b_ _b_ ---             
    ## [10]      --- Mr Pecksniff, sticking up his   hair   and *glancing* at his bust ---        
    ## [11]         --- hair and *glancing* at his   bust   by Spoker _b_ _b_ _b_ ---             
    ## [12]     --- *glancing* once at Mary, whose   face   was now buried in her ---             
    ## [13]  --- Bella, *glancing* downward at the   feet   in question _b_ _b_ _b_ ---           
    ## [14]     --- _b_ said Monks, with quivering    lip  , and *glancing* over his shoulder --- 
    ## [15]       --- lip, and *glancing* over his shoulder _b_ _b_ _b_ _b_ _b_ ---               
    ## [16] --- Pickwick, *glancing* at her pretty   face   _b_ _b_ _b_ _b_ _b_ ---               
    ## [17]     --- the Marquis, *glancing* at his   hands  _b_ _b_ _b_ _b_ _b_ ---               
    ## [18]          --- _b_ _b_ *glancing* at his   hands  again _b_ _b_ _b_ _b_ ---             
    ## [19]  --- Mr. Cruncher, *glancing* over his shoulder _b_ _b_ _b_ _b_ _b_ ---

``` r
# surveying
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("surveying"), context = 0)
y
```

    ## [ 1] --- Childers, after *surveying* him from  head to foot _b_ _b_ _b_ ---                 
    ## [ 2]         --- *surveying* him from head to  foot _b_ _b_ _b_ _b_ _b_ ---                 
    ## [ 3]      --- *surveying* her with scorn from  head to foot _b_ _b_ _b_ ---                 
    ## [ 4]         --- hand stretched out above his  eyes had been *surveying* the young ---      
    ## [ 5]      --- hands, and *surveying* him from  head to foot with a bitter ---               
    ## [ 6]         --- *surveying* him from head to  foot with a bitter sneer _b_ ---             
    ## [ 7]      --- Mr. Giles, *surveying* the pale faces which surrounded him, and looking ---   
    ## [ 8]      --- replied Mr. Bumble, shading his  eyes with his hand, and *surveying* ---      
    ## [ 9]            --- shading his eyes with his  hand, and *surveying* the stranger, from --- 
    ## [10]   --- and *surveying* the stranger, from  head to foot, in evident perplexity ---

``` r
# casting
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("casting"), context = 0)
y
```

    ## [ 1]         --- Mr. Kenge, standing with his back to the fire and *casting* ---        
    ## [ 2]    --- her letters, *casting* her bright eyes smilingly over them, and sorting --- 
    ## [ 3]  --- Mrs. Jellyby, sweetly *casting* her eyes for a moment on me ---               
    ## [ 4]  --- resumed Miss Blimber, *casting* her  eye over the paper _b_ _b_ ---           
    ## [ 5]            --- _b_ he added, raising his eyes from his plate, and *casting* ---    
    ## [ 6]     --- said Harriet, *casting* down her eyes upon her black dress _b_ ---         
    ## [ 7]    --- asked Lord Decimus, *casting* his eyes around the table _b_ _b_ ---         
    ## [ 8]      --- Mrs General, *casting* down her eyes as she rose with a ---               
    ## [ 9]           --- Mrs Gamp, *casting* up her eyes _b_ _b_ _b_ _b_ _b_ ---              
    ## [10]     --- _b_ said Nicholas, *casting* his  eye upon the cramped direction _b_ ---   
    ## [11]    --- said Bradley, after *casting* his eyes on the ground _b_ _b_ ---            
    ## [12] --- Pross, *casting* up her tear-fraught eyes _b_ _b_ _b_ _b_ _b_ ---

``` r
# striking
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("striking"), context = 0)
y
```

    ## [ 1]      --- man, *striking* himself on the  breast  _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 2]       --- *striking* the table with his   hand   _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 3]    --- said Mr. Creakle, *striking* his   hand   upon the table, and looking ---       
    ## [ 4] --- Micawber, *striking* himself on the  breast  _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 5]     --- _b_ *striking* himself upon the  breast  _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 6]     --- cried Mr Dombey, *striking* his   hand   upon the table _b_ _b_ ---            
    ## [ 7]   --- Tigg, *striking* himself upon the  breast  _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 8]    --- said the manager, *striking* his   knee   emphatically _b_ _b_ _b_ _b_ ---      
    ## [ 9]                 --- _b_ _b_ _b_ _b_ _b_  gulping down its contents, and *striking* --- 
    ## [10]     --- _b_ *striking* himself upon the  breast  _b_ _b_ _b_ _b_ _b_ ---               
    ## [11]     --- his pockets, and *striking* the knuckles of his right against the ---

``` r
# dropping
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("dropping"), context = 0)
y
```

    ## [1] --- and immediately afterwards *dropping* his  eyes to the buttons of Mr ---              
    ## [2]          --- said Clennam, brushing away some tears that had been silently *dropping* --- 
    ## [3]         --- been silently *dropping* down his  face _b_ _b_ _b_ _b_ _b_ ---               
    ## [4]       --- throwing some intelligence into his  eyes all at once, and *dropping* ---       
    ## [5]                       --- into his cup from a squat black bottle, and *dropping* it ---   
    ## [6]     --- _b_ returned Pleasant, *dropping* her  arms _b_ _b_ _b_ _b_ _b_ ---               
    ## [7]               --- the old man, *dropping* his hands on his knees _b_ _b_ ---

``` r
# opening
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("opening"), context = 0)
y
```

    ## [ 1]       --- _b_ said Charley, *opening* her  eyes and smiling _b_ _b_ _b_ ---        
    ## [ 2]     --- says Sir Leicester, *opening* his  eyes _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 3]        --- says Mr. Bucket, *opening* his  arms _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 4]      --- _b_ said Gashford, *opening* his  eyes to their utmost width _b_ ---      
    ## [ 5]      --- _b_ said Traddles, *opening* his  eyes _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 6]     --- _b_ exclaimed Dora, *opening* her  eyes wide _b_ _b_ _b_ _b_ ---           
    ## [ 7]  --- _b_ rejoined Traddles, *opening* his  eyes _b_ _b_ _b_ _b_ _b_ ---            
    ## [ 8]        --- the Commander, getting off the chest, and *opening* the lid _b_ ---     
    ## [ 9]         --- cried Joe, *opening* his blue  eyes wide _b_ _b_ _b_ _b_ ---           
    ## [10]     --- _b_ said Bounderby, *opening* his  eyes _b_ _b_ _b_ _b_ _b_ ---            
    ## [11]             --- _b_ _b_ _b_ *opening* his  eyes wide, and standing on tiptoe ---   
    ## [12]        --- said the barber, *opening* his  eyes, and putting on his raven ---      
    ## [13] --- exclaimed Mr Mantalini, *opening* his  eyes at the sound of Ralph ---          
    ## [14]         --- the desk with his contentious  hand, *opening* his eyes wider, and --- 
    ## [15]   --- his contentious hand, *opening* his  eyes wider, and taking a long ---

``` r
# glistening
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("glistening"), context = 0)
y
```

    ## [1]      --- _b_ cried Barnaby with *glistening*  eyes , as he clutched his pole ---          
    ## [2]            --- *glistening* of her hard grey   eye , and a dreary shaking of ---          
    ## [3]                --- _b_ said the Captain, his  eyes  *glistening* with the praise of ---   
    ## [4]                    --- _b_ he fancied he saw  tears *glistening* in her eyes, and ---     
    ## [5] --- she answered, laughing with *glistening*  eyes  and standing on tiptoe to ---         
    ## [6]        --- *glistening* eyes and standing on tiptoe to kiss him _b_ _b_ ---               
    ## [7]               --- _b_ said Mr. Pickwick, his  eyes  *glistening* with delight at this ---

``` r
# fixing
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("fixing"), context = 0)
y
```

    ## [ 1]       --- *fixing* Mr. Skimpole with her   eye  _b_ _b_ _b_ _b_ _b_ ---              
    ## [ 2]           --- his head, and *fixing* his  eyes  on Mr Haredale 's face ---           
    ## [ 3]      --- returned Sir John, *fixing* his  eyes  upon him _b_ _b_ _b_ ---             
    ## [ 4]           --- _b_ said Alice, taking the  hand  again, and *fixing* her lustrous --- 
    ## [ 5]     --- again, and *fixing* her lustrous  eyes  lovingly upon her visitor, while --- 
    ## [ 6]       --- _b_ she returned, *fixing* her  eyes  upon him _b_ _b_ _b_ ---             
    ## [ 7] --- replied Lord Frederick, *fixing* his  eyes  on Miss Nickleby _b_ _b_ ---         
    ## [ 8]      --- said Mrs Nickleby, *fixing* her  eyes  modestly on the ground _b_ ---       
    ## [ 9]        --- his attention by *fixing* his  head  _b_ _b_ _b_ _b_ _b_ ---              
    ## [10]        --- says Mrs Lammle, *fixing* her  eyes  on his face, to enforce ---          
    ## [11]             --- *fixing* her eyes on his  face , to enforce what she says ---        
    ## [12]        --- says Mrs Lammle, *fixing* his  eyes  with hers: which he would ---        
    ## [13]        --- _b_ said Lizzie, *fixing* her  eyes  upon him with the look ---           
    ## [14]           --- said the Jew, *fixing* his  eyes  on Oliver _b_ _b_ _b_ ---            
    ## [15]         --- _b_ said Sikes, *fixing* his  eyes  upon her, and muttering the ---      
    ## [16]   --- Brownlow, slowly, and *fixing* his  eyes  upon the other 's face ---           
    ## [17]        --- said Mr. Jingle, *fixing* his  eyes  on the aunt 's face ---              
    ## [18]           --- and fork, and *fixing* his  eyes  on the visage of his ---             
    ## [19]             --- *fixing* his eyes on the visage of his friend _b_ _b_ ---

``` r
# rolling
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("rolling"), context = 0)
y
```

    ## [ 1]     --- said Mr. Creakle, putting his     head    on one side, and *rolling* ---    
    ## [ 2]       --- one side, and *rolling* his     eyes    round the school _b_ _b_ ---      
    ## [ 3] --- cried Mr. Peggotty, *rolling* his     head    in an ecstasy at the ---          
    ## [ 4]  --- the Major, *rolling* his lobster     eyes    round and round Princess 's ---   
    ## [ 5]  --- began the Captain, *rolling* his     eyes    slowly round the little room, --- 
    ## [ 6]     --- said the Major, *rolling* his     head    at the unconscious Miss Tox, ---  
    ## [ 7]         --- *rolling* his head at the unconscious Miss Tox, while his starting ---  
    ## [ 8] --- ideal portrait, and *rolling* his     head    emphatically _b_ _b_ _b_ _b_ ---  
    ## [ 9]  --- said Mr Pecksniff, *rolling* his     head    portentously _b_ _b_ _b_ _b_ ---  
    ## [10]      --- _b_ thinks Twemlow, with his     eyes    *rolling* _b_ _b_ _b_ _b_ ---

``` r
# turning
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("turning"), context = 0)
y
```

    ## [ 1]       --- said my guardian, *turning* his   face   away for a moment _b_ ---                     
    ## [ 2]    --- Mr. Skimpole, *turning* his bright   face   about _b_ _b_ _b_ _b_ ---                     
    ## [ 3] --- Mr. Skimpole, *turning* his sprightly   eyes   from one to the other ---                     
    ## [ 4]       --- said John Willet, *turning* his   eyes   from the ceiling to the ---                   
    ## [ 5]       --- _b_ said Solomon, *turning* his   back   upon the strange man _b_ ---                  
    ## [ 6]       --- returned the other, leaning his    arm   upon the chimney-piece, and *turning* ---     
    ## [ 7]         --- cried Miggs, *turning* on the   tears  again, previous to quitting the ---           
    ## [ 8]    --- rejoined his father, *turning* his   face   lazily towards him, and cracking ---          
    ## [ 9]         --- _b_ _b_ *turning* a darkening   face   on Peggotty, when he had ---                  
    ## [10]     --- said Mr. Murdstone, *turning* his   head   and his eyes stiffly towards ---              
    ## [11]            --- *turning* his head and his   eyes   stiffly towards me _b_ _b_ ---                
    ## [12]             --- my aunt, *turning* a deaf    ear   to the sister, and continuing ---             
    ## [13]             --- said I, *turning* away my   head   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [14]     --- Mr Dombey, slightly *turning* his   head   in his cravat, as if ---                      
    ## [15]          --- chair, and *turning* the old   face   up towards Mr Dombey 's ---                   
    ## [16]      --- said Carker, *turning* his white   teeth  on Mrs Skewton like a ---                     
    ## [17]       --- said the Captain, *turning* his   eyes   upon him with a faint ---                     
    ## [18]   --- retorts Edwin, *turning* merely his   eyes   in that direction _b_ _b_ ---                 
    ## [19]        --- said my convict, *turning* his   eyes   on Joe in a moody ---                         
    ## [20]             --- _b_ _b_ _b_ *turning* his   eyes   round the room _b_ _b_ ---                    
    ## [21]   --- returned Mr. Jaggers, *turning* his   eyes   upon me coolly, and taking ---                
    ## [22]       --- said Mr. Harthouse, putting his   hand   upon his shoulder and *turning* ---           
    ## [23]             --- putting his hand upon his shoulder and *turning* him, so that ---                
    ## [24]            --- and *turning* his beads of   eyes   upon his employer _b_ _b_ ---                 
    ## [25]             --- _b_ _b_ _b_ *turning* his   hands  over and over and looking ---                 
    ## [26]           --- old man, *turning* round on   Fanny  _b_ _b_ _b_ _b_ _b_ ---                       
    ## [27]        --- said Mrs Merdle, *turning* the   bosom  towards that gentleman _b_ _b_ ---            
    ## [28]        --- Mr Merdle, after *turning* his  tongue  again _b_ _b_ _b_ _b_ ---                     
    ## [29]     --- his wife, languidly *turning* her  eyelids a little in his direction (---                
    ## [30]         --- again, and *turning* away his   face   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [31]      --- said Mr Pecksniff, *turning* his   eyes   on Tom Pinch, even more ---                   
    ## [32]   --- she answered, *turning* her glowing   cheek  indignantly upon him _b_ _b_ ---              
    ## [33]       --- said the invalid, *turning* his   head   impatiently towards the adjoining room ---    
    ## [34]      --- *turning* upon him with gleaming   eyes   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [35]         --- _b_ said Richard, passing his   hand   over his forehead and *turning* ---           
    ## [36]             --- passing his hand over his forehead and *turning* suddenly round, as ---          
    ## [37]        --- said Bella, *turning* away her   eyes   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [38]      --- said Riderhood, *turning* on his   heel   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [39]       --- said this figure, *turning* his   head   towards the door _b_ _b_ ---                  
    ## [40]          --- the young mag, *turning* his   face   towards the bed, as if ---                    
    ## [41]      --- cried Fagin, extending his right   hand  , and *turning* to Mr. Bolter ---              
    ## [42]         --- _b_ said Sikes, *turning* his   face   to Crackit _b_ _b_ _b_ ---                    
    ## [43]     --- said Serjeant Buzfuz, folding his   arms   emphatically, and *turning* half-round to --- 
    ## [44]     --- _b_ inquired Emily, *turning* her   head   aside _b_ _b_ _b_ _b_ ---                     
    ## [45]             --- _b_ _b_ _b_ *turning* her   eyes   lovingly to him as he ---

``` r
# shading
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("shading"), context = 0)
y
```

    ## [1] --- said Mr. Gradgrind, *shading* his face with his hand _b_ _b_ ---             
    ## [2]       --- *shading* his face with his hand _b_ _b_ _b_ _b_ _b_ ---               
    ## [3] --- cried Arthur Gride, *shading* his eyes with his hand _b_ _b_ ---             
    ## [4]       --- *shading* his eyes with his hand _b_ _b_ _b_ _b_ _b_ ---               
    ## [5]         --- and *shading* it with his hand _b_ _b_ _b_ _b_ _b_ ---               
    ## [6] --- replied Mr. Bumble, *shading* his eyes with his hand, and surveying ---      
    ## [7]       --- *shading* his eyes with his hand, and surveying the stranger, from ---

``` r
# shutting
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("shutting"), context = 0)
y
```

    ## [1]            --- _b_ said he, folding his   arms   and *shutting* his eyes with --- 
    ## [2]         --- his arms and *shutting* his   eyes   with an oath _b_ _b_ ---         
    ## [3]         --- make without lifting up his eyebrows and *shutting* his eyes _b_ ---  
    ## [4]     --- his eyebrows and *shutting* his   eyes   _b_ _b_ _b_ _b_ _b_ ---          
    ## [5] --- said Mr. Turveydrop, *shutting* his   eyes   and lifting up his shoulders --- 
    ## [6]   --- replied the Major, *shutting* one    eye  , putting his head on one ---     
    ## [7]     --- *shutting* one eye, putting his   head   on one side, passing his ---     
    ## [8]      --- Mr Fledgeby, *shutting* up one    eye   _b_ _b_ _b_ _b_ _b_ ---

``` r
# lifting
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("lifting"), context = 0)
y
```

    ## [ 1]       --- make without *lifting* up his  eyebrows and shutting his eyes _b_ ---         
    ## [ 2]   --- said Mr. Turveydrop, shutting his    eyes   and *lifting* up his shoulders ---    
    ## [ 3]           --- eyes and *lifting* up his shoulders with modest consciousness _b_ _b_ --- 
    ## [ 4]           --- he said, *lifting* up his    head   soon after we were left ---           
    ## [ 5] --- Littimer, slightly *lifting* up his  eyebrows, but not his eyes _b_ ---             
    ## [ 6]         --- _b_ she said, *lifting* her    head   suddenly _b_ _b_ _b_ _b_ ---          
    ## [ 7]     --- *lifting* his wristbands to his    eyes   in the simplest manner possible, ---  
    ## [ 8] --- haughtily, without *lifting* up her    eyes   _b_ _b_ _b_ _b_ _b_ ---               
    ## [ 9]      --- Mrs Plornish, *lifting* up her  eyebrows, and searching for a solution ---     
    ## [10]    --- his friend, lazily *lifting* his    head   a little to look at ---               
    ## [11]        --- Mrs Wilfer, *lifting* up her    eyes   and apostrophising the air _b_ ---    
    ## [12]  --- _b_ returned madame, *lifting* her  eyebrows a little _b_ _b_ _b_ ---

``` r
# raising
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("raising"), context = 0)
y
```

    ## [ 1]           --- Ada then, *raising* her blue   eyes   tenderly to his face _b_ ---         
    ## [ 2]   --- Mr. Skimpole, *raising* his laughing   eyes   in playful astonishment _b_ _b_ ---  
    ## [ 3]  --- Sir Leicester observes; *raising* his   eyes   to his face _b_ _b_ ---              
    ## [ 4]               --- _b_ said I, *raising* my   eyes   to his _b_ _b_ _b_ ---               
    ## [ 5]          --- said the guest, *raising* his   eyes   to John 's fat face ---              
    ## [ 6]        --- returned the son, *raising* his   head   for a moment, and then ---           
    ## [ 7]          --- said, at length *raising* his   eyes   to the ceiling with the ---          
    ## [ 8]      --- returned the other, *raising* his   head   a little from the cushion ---        
    ## [ 9]             --- _b_ he said, *raising* his   head   to look after him _b_ ---            
    ## [10]     --- Mr Chester, *raising* his delicate   hand   imploringly _b_ _b_ _b_ _b_ ---      
    ## [11]        --- _b_ growled Hugh, *raising* his   head   to look at him with ---              
    ## [12]           --- said Sir John, *raising* his   hand   in deprecation of his delivering --- 
    ## [13]            --- the wall; and *raising* his   eyes   to the locksmith 's face ---         
    ## [14]        --- cried Hugh, *raising* his right    arm   aloft, and looking upward like ---   
    ## [15]       --- said Dolly, *raising* her pretty   face   to his _b_ _b_ _b_ ---               
    ## [16]      --- said Dora, slightly *raising* her eyebrows, and shaking her head _b_ ---        
    ## [17]     --- returned Agnes, *raising* her soft   eyes   to mine _b_ _b_ _b_ ---              
    ## [18]      --- _b_ pursued Walter, *raising* his   eyes   with a look of entreaty ---          
    ## [19]            --- _b_ he added, *raising* his   eyes   from his plate, and casting ---      
    ## [20]              --- _b_ _b_ _b_ *raising* the   hand   she pressed upon her bosom, ---      
    ## [21]      --- said Biddy, quietly *raising* her eyebrows _b_ _b_ _b_ _b_ _b_ ---              
    ## [22]        --- _b_ said Estella, *raising* her   eyes   after a silence _b_ _b_ ---          
    ## [23]       --- _b_ Stephen began, *raising* his   eyes   from the floor, after a ---          
    ## [24]           --- pale fire, and *raising* her   eyes   again to the face which ---          
    ## [25]          --- said Mr Dorrit, *raising* his eyebrows _b_ _b_ _b_ _b_ _b_ ---              
    ## [26]       --- said Mrs Sparkler, *raising* her   eyes   to him after another minute ---      
    ## [27]      --- said Little Dorrit, *raising* her   eyes   to his _b_ _b_ _b_ ---               
    ## [28]       --- cried Mrs Todgers, *raising* her   eyes   and shaking her head _b_ ---         
    ## [29]        --- _b_ she answered, *raising* her   head   after a short silence, and ---       
    ## [30]       --- the amiable Jonas, *raising* his   eyes   from yesterday 's newspaper _b_ ---  
    ## [31]           --- _b_ added Tom, *raising* his   eyes   to his benefactor 's face ---        
    ## [32]          --- _b_ said Ralph, *raising* his   eyes   _b_ _b_ _b_ _b_ _b_ ---              
    ## [33]           --- _b_ said Kate, *raising* her   face   again _b_ _b_ _b_ _b_ ---            
    ## [34]           --- the stout man, *raising* his   eyes   from his cards for the ---           
    ## [35]         --- the silence, and *raising* his   eyes   to the ceiling with a ---            
    ## [36]        --- added the lawyer, *raising* his   eyes   to the ceiling _b_ _b_ ---           
    ## [37]         --- said Miss Brass, *raising* her   head  , with which she had hitherto ---     
    ## [38]          --- _b_ said Bella, *raising* her   eyes   to his, after a little ---           
    ## [39]         --- says Mrs Lammle, *raising* her   eyes   to his face again, and ---           
    ## [40]       --- the old gentleman, *raising* his   hands  instinctively _b_ _b_ _b_ _b_ ---    
    ## [41] --- foremost one, *raising* her shrivelled   hand   _b_ _b_ _b_ _b_ _b_ ---              
    ## [42]         --- Pott, *raising* herself in the   arms   of her attendant _b_ _b_ ---         
    ## [43]            --- _b_ she said, *raising* her   hand   to Mr. Lorry as he ---               
    ## [44]              --- nearer to him, laying her   head   upon his breast, and *raising* ---   
    ## [45]               --- laying her head upon his  breast , and *raising* her eyes to ---       
    ## [46]          --- his breast, and *raising* her   eyes   to his _b_ _b_ _b_ ---

``` r
# drawing
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("drawing"), context = 0)
y
```

    ## [ 1]            --- at his *drawing* with his  head  on one side _b_ _b_ ---                  
    ## [ 2]         --- _b_ said Allan, *drawing* my   arm  through his _b_ _b_ _b_ ---              
    ## [ 3]        --- said Mr. Creakle, darting his  head  at him suddenly, and *drawing* ---       
    ## [ 4]         --- said Uriah, *drawing* up one   leg , at the risk of bringing ---             
    ## [ 5]        --- Miss Nipper, *drawing* in her breath _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 6]        --- *drawing* his sleeve over his  eyes  and forehead, as the click ---           
    ## [ 7]        --- he returned, *drawing* a long breath _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 8]        --- Mrs Todgers, *drawing* in her breath _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 9]          --- said the actor, setting his  teeth together, and *drawing* in his ---       
    ## [10]       --- together, and *drawing* in his breath with a hissing sound _b_ ---             
    ## [11]    --- _b_ muttered Ralph, *drawing* his  hand  across his mouth with a ---              
    ## [12]        --- *drawing* his hand across his  mouth with a connoisseur-like air, and ---     
    ## [13]            --- said the boy, nodding his  head  and *drawing* back, with the ---         
    ## [14]         --- and *drawing* back, with the elbows ready in case of the ---                 
    ## [15]          --- Eugene, *drawing* a lady 's  head  upon his writing-paper, and touching --- 
    ## [16]            --- _b_ _b_ _b_ *drawing* the  back  of his hand across them ---              
    ## [17]            --- *drawing* the back of his  hand  across them _b_ _b_ _b_ ---              
    ## [18]          --- the room, and *drawing* her   arm  through Bella 's _b_ _b_ ---             
    ## [19]      --- *drawing* his sleeve across his  mouth _b_ _b_ _b_ _b_ _b_ ---                  
    ## [20] --- *drawing* his coat-sleeve across his  mouth _b_ _b_ _b_ _b_ _b_ ---                  
    ## [21]      --- the old gentlman, *drawing* her   arm  through his _b_ _b_ _b_ ---              
    ## [22]         --- _b_ said madame, *drawing* a breath and nodding her head with ---            
    ## [23]            --- _b_ _b_ _b_ *drawing* his   arm  soothingly round her waist _b_ ---

### Figure 2: Plot of B1 +“lexical” collocates in DNov quotes vs. long suspensions

``` r
plot(results)
```

![](DNov_quotes_long_sus_files/figure-markdown_github/B1_DNov_quotes_vs_long_sus_lexical-1.png)

Analysis: 3. Comparing B1 + all semantic types in DNov quotes vs. long suspensions
==================================================================================

``` r
quotes_text$tokens$type <- with(quotes_type_store, semantic_tags)
long_sus_text$tokens$type <- with(long_sus_type_store, semantic_tags)

head(quotes_text$tokens, 20)
```

    ##     idx   type start end  token
    ##  1:   1   <NA>    13  15    _b_
    ##  2:   2   <NA>    17  19    _b_
    ##  3:   3   <NA>    21  23    _b_
    ##  4:   4   <NA>    25  27    _b_
    ##  5:   5   <NA>    29  31    _b_
    ##  6:   6  E4.1-    33  38 Suffer
    ##  7:   7  N5.1+    40  42    any
    ##  8:   8  A5.3-    44  48  wrong
    ##  9:   9     Z8    50  53   that
    ## 10:  10    A7+    55  57    can
    ## 11:  11     Z5    59  60     be
    ## 12:  12 A1.1.1    62  65   done
    ## 13:  13     Z8    67  69    you
    ## 14:  14     Z5    71  76 rather
    ## 15:  15     Z5    78  81   than
    ## 16:  16   A4.1    83  86   come
    ## 17:  17     M6    88  91   here
    ## 18:  18   <NA>    93  95    _b_
    ## 19:  19   <NA>    97  99    _b_
    ## 20:  20   <NA>   101 103    _b_

``` r
head(long_sus_text$tokens, 20)
```

    ##     idx   type start end      token
    ##  1:   1   <NA>    13  15        _b_
    ##  2:   2   <NA>    17  19        _b_
    ##  3:   3   <NA>    21  23        _b_
    ##  4:   4   <NA>    25  27        _b_
    ##  5:   5   <NA>    29  31        _b_
    ##  6:   6 A1.1.1    33  40   proceeds
    ##  7:   7     Z5    42  44        the
    ##  8:   8   G1.1    46  55 Chancellor
    ##  9:   9    T2+    58  62      still
    ## 10:  10     Z5    64  65         on
    ## 11:  11    Z99    67  74   Jarndyce
    ## 12:  12     Z5    76  78        and
    ## 13:  13    Z99    80  87   Jarndyce
    ## 14:  14   <NA>    89  91        _b_
    ## 15:  15   <NA>    93  95        _b_
    ## 16:  16   <NA>    97  99        _b_
    ## 17:  17   <NA>   101 103        _b_
    ## 18:  18   <NA>   105 107        _b_
    ## 19:  19 A1.1.1   109 116   proceeds
    ## 20:  20     Z5   118 120        the

``` r
# the set of nodes and collocates we are interested in
nodes <- unique(grep("^B1", c(quotes_text$tokens$type, long_sus_text$tokens$type), value = TRUE))
nodes
```

    ## [1] "B1"

``` r
quotes_surface <- corp_surface(quotes_text, span = "5LR", nodes = nodes)
long_sus_surface <- corp_surface(long_sus_text, span = "5LR", nodes = nodes)

# compare
results <- corp_coco(quotes_surface, long_sus_surface, nodes = nodes)
```

Figure 3: Plot of B1 + “semantic tag collocates” in DNov quotes vs. long suspensions
------------------------------------------------------------------------------------

``` r
plot(results)
```

![](DNov_quotes_long_sus_files/figure-markdown_github/B1_DNov_quotes_vs_long_sus_semantic-1.png)

Concordances of semantic tag collocates
---------------------------------------

The concordances below have been picked relatively spontaneously from
among the high effect size differences and the unique results. We can
easily add other concordances.

### Concordances: Long suspensions

``` r
# "I3.2" - "Work and employment: Professionalism""
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("I3.2"), context = 0)
y
```

    ## [1]    --- here the *secretary* clasped his hands _b_ _b_ _b_ _b_ _b_ ---          
    ## [2]    --- whispering in his *secretary* 's  ear  _b_ _b_ _b_ _b_ _b_ ---          
    ## [3] --- George, pressing his *secretary* 's  arm  tight within his own, and ---    
    ## [4]           --- his head, and keeping his  eyes upon the *secretary* 's face --- 
    ## [5]        --- eyes upon the *secretary* 's  face _b_ _b_ _b_ _b_ _b_ ---          
    ## [6]     --- the *Secretary*, with a beaming  face _b_ _b_ _b_ _b_ _b_ ---

``` r
# "Q2.1" - "Speech etc: Communicative"
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("Q2.1"), context = 0)
y
```

    ## [  1]                 --- who entreated me with their     eyes    to *speak* _b_ _b_ _b_ ---                      
    ## [  2]                --- _b_ *said* Ada, clasping her    hands    upon his arm and shaking ---                    
    ## [  3]                  --- _b_ *said* he, shaking his     head    pleasantly _b_ _b_ _b_ _b_ ---                  
    ## [  4]                  --- _b_ *said* he, folding his     arms    and shutting his eyes with ---                  
    ## [  5]                    --- *say* at night, with her     head    upon my shoulder and the ---                    
    ## [  6]                      --- _b_ he *said* with his     hand    upon his heart and shaking ---                  
    ## [  7]                 --- *says* Mr. Snagsby with his    finger   on his nose _b_ _b_ ---                         
    ## [  8]                      --- _b_ *said* Ada, on his   shoulder  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [  9]         --- *said* Mr. Turveydrop, shutting his     eyes    and lifting up his shoulders ---                
    ## [ 10]             --- *said* my guardian, turning his     face    away for a moment _b_ ---                       
    ## [ 11]             --- _b_ *said* Charley, opening her     eyes    and smiling _b_ _b_ _b_ ---                     
    ## [ 12]                  --- _b_ he *said*, beating one     hand    on the other passionately _b_ ---               
    ## [ 13]                  --- _b_ he *said*, bending his     head    to Ada and me with ---                          
    ## [ 14]                   --- _b_ *says* Jo, with dirty    tears    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 15]                 --- _b_ he *whispers*, with his     eyes    screwed up, after tasting it ---                
    ## [ 16]                 --- _b_ *says* Jo with starting     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 17]                  --- the *point* with his dirty  thumb-nail, bestows an oily smile on ---                   
    ## [ 18]                  --- *says* Mr. George with his     eyes    musingly fixed on Judy _b_ ---                  
    ## [ 19]         --- *says* Grandfather Smallweed with a  tremulous  wave of his shrivelled hand ---                 
    ## [ 20]                        --- for this slip of the    tongue   by *saying* to Judy _b_ ---                     
    ## [ 21]              --- *says* Mr. George, passing his     hand    hopelessly across his brow _b_ ---              
    ## [ 22]              --- *says* Mr. Snagsby, pausing to    sniff    and taste the air a ---                         
    ## [ 23]                 --- *says* Mr. Snagsby when his    tongue   is loosened _b_ _b_ _b_ ---                     
    ## [ 24]                --- *says* Mr. Guppy, taking his     arm     again and walking him slowly ---                
    ## [ 25]                         --- had the pipe in his     hand   , is the *speaker* now _b_ ---                   
    ## [ 26]                 --- _b_ *said* she, putting her     hand    into her reticule _b_ _b_ ---                   
    ## [ 27]                    --- _b_ *said* I, shaking my     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 28]           --- *says* Sir Leicester, opening his     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 29]                   --- *says* Sir Leicester in a  breathless condition _b_ _b_ _b_ _b_ ---                   
    ## [ 30]             --- *says* Mr. Snagsby, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 31]         --- *says* Mr. Tulkinghorn, tapping his     chin    with the key and looking ---                    
    ## [ 32] --- *whispers* mademoiselle, stretching out her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 33]              --- *said* my guardian, laying his     hand    emphatically on the sleeve of ---               
    ## [ 34]                      --- _b_ _b_ _b_ he *said*, unconscious with what application _b_ _b_ ---               
    ## [ 35]               --- _b_ *says* Allan, keeping his     eye     upon him _b_ _b_ _b_ ---                        
    ## [ 36]              --- *says* Mr. George, shaking his     head    sorrowfully _b_ _b_ _b_ _b_ ---                 
    ## [ 37]             --- *says* the trooper, passing his     hand    over his brow _b_ _b_ ---                       
    ## [ 38]                 --- _b_ *says* Mrs. Bagnet, her     eyes    sparkling with pleasure and her ---             
    ## [ 39]              --- *says* Mr. Bucket, opening his     arms    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 40]               --- *says* Mr. Bucket, taking his     arm     at the shop-door _b_ _b_ ---                    
    ## [ 41]             --- *said* Mr. Vholes, bringing his     hand    flat down upon his desk ---                     
    ## [ 42]              --- cordial *voice*, and taking my     hand    with the brotherly regard which ---             
    ## [ 43]        --- _b_ *said* Richard, relinquishing my     hand    gently and walking across the ---               
    ## [ 44]              --- *says* Mr. Bucket, warming his    hands    and looking pleasantly at the ---               
    ## [ 45]             --- *says* Mr. Bucket, offering his     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 46]             --- *says* the trooper, shaking his     head    very doubtfully _b_ _b_ _b_ ---                 
    ## [ 47]                  --- _b_ *said* he, beating his    finger   on the apron _b_ _b_ ---                        
    ## [ 48]             --- _b_ *says* Sir Leicester, whose     eyes    are much attracted towards him ---              
    ## [ 49]                     --- _b_ *said* I, laying my     face    against her forehead, for indeed ---            
    ## [ 50]                    --- _b_ *said* I, raising my     eyes    to his _b_ _b_ _b_ ---                          
    ## [ 51]            --- *said* Mr. Skimpole, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 52]                     --- *said* I, giving him my     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 53]             --- *says* the trooper, folding his     arms    and looking with indomitable firmness ---       
    ## [ 54]             --- *says* the trooper, folding his     arms    more resolutely yet _b_ _b_ ---                 
    ## [ 55]                --- _b_ *said* Allan, drawing my     arm     through his _b_ _b_ _b_ ---                     
    ## [ 56]             --- *said* John Willet, turning his     eyes    from the ceiling to the ---                     
    ## [ 57]                     --- from the ceiling to the     face    of his interrupter, and *uttering* ---          
    ## [ 58]             --- _b_ *said* Solomon, turning his     back    upon the strange man _b_ ---                    
    ## [ 59]           --- _b_ _b_ *said* Varden, descending    nimbly   from his chaise _b_ _b_ ---                     
    ## [ 60]             --- _b_ *said* Barnaby, passing his     arm     through Varden 's, and peering ---              
    ## [ 61]                          --- use he made of his     eyes    when he *said* this _b_ ---                     
    ## [ 62]               --- *said* the guest, raising his     eyes    to John 's fat face ---                         
    ## [ 63]                    --- _b_ _b_ _b_ *said* John,   frowning  aside at Barnaby _b_ _b_ ---                    
    ## [ 64]                --- his *voice*, and shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 65]              --- *said* Barnaby, holding up his    finger   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 66]          --- *said* Mr Tappertit, releasing his     leg     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 67]                  --- _b_ _b_ *said* Mrs Varden,   frowning  at her husband _b_ _b_ ---                      
    ## [ 68]               --- *said*, at length raising his     eyes    to the ceiling with the ---                     
    ## [ 69]                 --- _b_ he *said*, pressing his     hand    tenderly upon the book as ---                   
    ## [ 70]             --- *said* Mr Tappertit, laying his     hand    upon his breast _b_ _b_ ---                     
    ## [ 71]             --- *said* Mr Chester, relaxing his     face    when he was fairly gone ---                     
    ## [ 72]         --- cried the locksmith with brightened     eyes   , and sturdy, honest *voice* _b_ ---             
    ## [ 73]                        --- to get nearer to his     ear    , and *whispering* hoarsely _b_ _b_ ---          
    ## [ 74]                 --- _b_ he *said*, pressing her     hand    delicately to his lips _b_ ---                  
    ## [ 75]                  --- _b_ he *said*, raising his     head    to look after him _b_ ---                       
    ## [ 76]                --- *said* Joe, putting out both    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 77]            --- _b_ returned John, elevating his   eyebrows , and lowering his *voice* to ---                
    ## [ 78]                   --- *said* John Grueby in his     ear    , after what appeared to him ---                 
    ## [ 79]                 --- _b_ _b_ *said* Lord George,    biting   his nails most horribly _b_ ---                 
    ## [ 80]                  --- _b_ *said* Gashford in his     ear    , as he drew the curtains ---                    
    ## [ 81]             --- *said* Lord George, rubbing his     eyes    and looking round the room ---                  
    ## [ 82]            --- _b_ *said* Gashford, opening his     eyes    to their utmost width _b_ ---                   
    ## [ 83]               --- he *said*, stretching out his     hand    and taking it back _b_ ---                      
    ## [ 84]              --- _b_ *said* Dennis, rubbing his     legs    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 85]                --- loud *voice*, and waving his     hand    in a disturbed and agitated ---                 
    ## [ 86]     --- *said* Gashford, upon whose unwholesome     face    the perspiration had broken out ---             
    ## [ 87]                       --- she *said*, in a half  breathless manner _b_ _b_ _b_ _b_ ---                      
    ## [ 88]            --- *whispering* in his secretary 's     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 89]                  --- *voice*, as in his altered     face    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 90]              --- *whisper* as he repeated, with     eyes    fixed upon the locksmith _b_ ---                
    ## [ 91]           --- _b_ *said* Gashford, pinching his     arm     with such malevolence that his ---              
    ## [ 92]                 --- _b_ *said* Hugh, wiping his     face    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 93]                  --- here he *whispered* in his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 94]                --- _b_ *said* Simon, laying his     hand    upon his breast, 'not a ---                     
    ## [ 95]                --- *speech*, that grated on the     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 96]         --- _b_ *said* Barnaby, withdrawing his     hand    from the bird, and laying ---                   
    ## [ 97]                  --- _b_ she *whispered* in his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 98]            --- _b_ *said* Hugh, contracting his    brows    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 99]                --- *said* Sir John, leaning his     head    upon his hand, and sipping ---                  
    ## [100]                --- *said* Sir John, raising his     hand    in deprecation of his delivering ---            
    ## [101]                    --- eyes to the locksmith 's     face    again, *said*, with an air ---                  
    ## [102]            --- her earnest *voice*, and gushing    tears    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [103]            --- *said* Dolly, raising her pretty     face    to his _b_ _b_ _b_ ---                          
    ## [104]             --- _b_ *said* Peggotty, taking her     eyes    from me, after a little ---                     
    ## [105]             --- *said* my mother, shedding more    tears    than before _b_ _b_ _b_ ---                     
    ## [106]             --- *said* Peggotty, intent upon my     face    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [107]                   --- _b_ he *said*, making his     lips    thin, by pressing them together ---             
    ## [108]                  --- _b_ he *said*, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [109]            --- *said* Mr. Creakle, striking his     hand    upon the table, and looking ---                 
    ## [110]                   --- *said* Mr. Mell, with his     lips    trembling more and more _b_ ---                 
    ## [111]                 --- Creakle, shaking him by the     arm    ; and his *whisper* was so ---                   
    ## [112]             --- *said* Mr. Creakle, darting his     head    at him suddenly, and drawing ---                
    ## [113]             --- *said* Mr. Creakle, putting his     head    on one side, and rolling ---                    
    ## [114]                --- *said* Mr. Creakle, with his    veins    swelling again bigger than ever ---             
    ## [115]            --- *said* Mr. Peggotty, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [116]             --- *said* Mr. Barkis, carrying his     eyes    back to his horse 's ---                        
    ## [117]                  --- *said* my mother, with the    tears    which were engendered in her ---                
    ## [118]           --- *said* Mr. Murdstone, turning his     head    and his eyes stiffly towards ---                
    ## [119]                    --- _b_ *said* I, shaking my     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [120]            --- *said* Mr. Micawber, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [121]                 --- *said* my aunt, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [122]               --- _b_ he *said* cheerfully, and   rousing   himself _b_ _b_ _b_ _b_ ---                     
    ## [123]                 --- _b_ she *said*, shaking her    finger   at him _b_ _b_ _b_ ---                          
    ## [124]              --- *said* the Doctor, warming his    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [125]                  --- *said*, clapping me on the   shoulder  again _b_ _b_ _b_ _b_ ---                       
    ## [126]                   --- _b_ he *said*, wiping his     head   , and breathing with difficulty _b_ ---          
    ## [127]                --- *said*, wiping his head, and  breathing  with difficulty _b_ _b_ _b_ ---                 
    ## [128]             --- _b_ *said* Peggotty, wiping her     eyes    with her apron _b_ _b_ ---                      
    ## [129]               --- *said* Mr. Peggotty, with his     face    one high noon of enjoyment ---                  
    ## [130]               --- she *said*, smiting her small    knees   , and rising _b_ _b_ _b_ ---                     
    ## [131]                  --- *said* my aunt, laying her     hand    with melancholy firmness on the ---             
    ## [132]                       --- _b_ *said* I, with my     hand    on the bell-rope _b_ _b_ ---                    
    ## [133]                   --- *said* I, turning away my     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [134]           --- *said* Traddles, falling a little     back    from it to survey it ---                        
    ## [135]               --- *said* Mr. Micawber, with one     eye     on Traddles _b_ _b_ _b_ ---                     
    ## [136]                --- *said* Mr. Omer, shaking his     head    gently _b_ _b_ _b_ _b_ ---                      
    ## [137]                  --- _b_ he *said*, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [138]                    --- _b_ she *said*, with her     hand    on her bosom, as if ---                         
    ## [139]           --- *said* Dora, slightly raising her   eyebrows , and shaking her head _b_ ---                   
    ## [140]                 --- *said* my aunt, shaking her     head   , and smiling gravely _b_ _b_ ---                
    ## [141]                --- *said* Uriah, drawing up one     leg    , at the risk of bringing ---                    
    ## [142]            --- _b_ *said* Traddles, opening his     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [143]                   --- he *said*, lifting up his     head    soon after we were left ---                     
    ## [144]                 --- _b_ *said* Dora, her bright     eyes    shining very brightly, and her ---              
    ## [145]                   --- she *said*, giving me her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [146]                   --- *said* Mr. Wickfield in a  tremulous  *voice* _b_ _b_ _b_ _b_ ---                     
    ## [147]                      --- *said* at length, in a  breathless *voice* _b_ _b_ _b_ _b_ ---                     
    ## [148]                 --- _b_ he *said*, removing his     hand    from his cheek _b_ _b_ ---                      
    ## [149]                        --- _b_ he *said*, in my     ear     (I did not turn my ---                          
    ## [150]           --- *said* Annie without removing her     eyes    from his face _b_ _b_ ---                       
    ## [151]            --- *said* Mr. Littimer, rubbing his    hands    uneasily _b_ _b_ _b_ _b_ ---                    
    ## [152]            --- *said* Mr. Micawber, nodding his     head    sorrowfully _b_ _b_ _b_ _b_ ---                 
    ## [153]                --- _b_ _b_ *said* Mr. Micawber,   gasping  , puffing, and sobbing, to that ---              
    ## [154]              --- she *said*, stretching out her     hand    with her contemptuous laugh, and ---            
    ## [155]                  --- *said* my aunt, drying her     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [156]            --- *said* Mr. Peggotty, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [157]                --- *said* Mr. Omer, rubbing his    hands    feebly _b_ _b_ _b_ _b_ ---                      
    ## [158]            --- *said* Mr. Peggotty, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [159]               --- *said* Dora, putting back her     hair   , and looking wonderingly at my ---              
    ## [160]                --- he *said*, with an impatient     bite    at the handkerchief in which ---                
    ## [161]           --- *said* Mrs. Micawber, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [162]                    --- *said*, when I opened my     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [163]                     --- _b_ _b_ *said* he, with    tears    starting to his weather-beaten face, ---        
    ## [164]           --- *said* Mr. Micawber, clearing his    throat   in his magnificent way _b_ ---                  
    ## [165]           --- *said* Mrs. Micawber, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [166]           --- _b_ *said* Traddles, rumpling his     hair    in his excitement, which was ---                
    ## [167]           --- _b_ *said* Traddles, sticking his     hair    upright with both hands, and ---                
    ## [168]                 --- *said* my aunt, patting the     back    of my hand, as we ---                           
    ## [169]              --- *said* Agnes, with her cordial     eyes    turned cheerfully upon me _b_ ---               
    ## [170]                  --- _b_ he *said*, kissing her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [171]                  --- _b_ he *said*, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [172]          --- *said* Louisa; smiling through her    tears   , which indeed were not overpowering ---         
    ## [173]                    --- *said* Mr Dombey, with a    frown    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [174]                --- _b_ he *said*, arranging his     hair    (which was thin) with his ---                   
    ## [175]                        --- much ado to keep her    teeth    from *chattering* _b_ _b_ _b_ ---               
    ## [176]                 --- _b_ she *said*, running her     eyes    over the child 's slight ---                    
    ## [177]              --- *said* Walter, glancing at her     foot    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [178]                --- *said* the child, laying his    hands    upon the elbows of his ---                      
    ## [179]             --- *said* little Paul, warming his    hands   , and looking in between the ---                 
    ## [180]           --- *said* Mrs Blimber, with uplifted     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [181]              --- *said* the Doctor, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [182]               --- *said* Mr Carker, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [183]                --- *voice*, to have covered his     face    with his hands _b_ _b_ ---                      
    ## [184]                   --- *said* the Captain in his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [185]                 --- he *said* gaily, laying his     hand    upon the old man 's ---                         
    ## [186]             --- _b_ *said* Florence, laying her     hand    timidly upon the old man ---                    
    ## [187]             --- *said* the other, retaining his     hand    while he *spoke* _b_ _b_ ---                    
    ## [188]               --- *said* the Major, rolling his     head    at the unconscious Miss Tox, ---                
    ## [189]                --- *said* Carker, with his soft     hand    playing round his mouth, and ---                
    ## [190]                 --- _b_ *said* the Captain, his     eyes    glistening with the praise of ---               
    ## [191]                      --- _b_ _b_ _b_ *said* the unconscious MacStinger, rubbing her hands _b_ ---           
    ## [192]                --- tracing the *outline* of her   eyebrows  with her forefinger _b_ _b_ ---                 
    ## [193]            --- *said* Mrs Skewton, trimming her     lips    with the laced edge of ---                      
    ## [194]                --- *said* the Major, laying his    finger   on his lips, and *speaking* ---                 
    ## [195]                    --- laying his finger on his     lips   , and *speaking* half apart to ---               
    ## [196]               --- _b_ she *said*, with flashing     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [197]               --- *said* Mrs Chick, shaking her     head    with energy, and arranging herself ---          
    ## [198]                    --- *said* Mrs Chick, with a    shiver   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [199]           --- *said* Mrs Skewton, detaining her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [200]                        --- to *say* in the same    breath   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [201]             --- *said* the Captain, shaking his     head    slowly _b_ _b_ _b_ _b_ ---                      
    ## [202]           --- *said* the gentleman, rubbing his   forehead  again; and drumming on the ---                  
    ## [203]           --- *said* the gentleman, rubbing his     head   , as despondently as before _b_ ---              
    ## [204]                 --- _b_ she *said*, lifting her     head    suddenly _b_ _b_ _b_ _b_ ---                    
    ## [205]            --- *said* Carker, turning his white    teeth    on Mrs Skewton like a ---                       
    ## [206]                  --- *said* the Major, with his    hands    behind him, and his legs ---                    
    ## [207]          --- *says* Cousin Feenix, stroking his     chin   , which he has just enough ---                   
    ## [208]                  --- *said* Mrs Brown, with her     arms    uplifted towards the sky, and ---               
    ## [209]           --- *said*, with her eager avaricious     face    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [210]            --- returned his wife, immoveable in     eye    , and *voice*, and attitude _b_ ---              
    ## [211]          --- Mr Dombey, *speaking* with knitted    brows   , and after a moment 's ---                      
    ## [212]          --- *said* Edith, addressing her proud     face    to Carker _b_ _b_ _b_ ---                       
    ## [213]             --- *said* the Captain, turning his     eyes    upon him with a faint ---                       
    ## [214]                --- *said* Mr Toots, holding his   forehead  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [215]                --- at which each shuddered from     head    to foot, and *said* _b_ ---                     
    ## [216]                 --- each shuddered from head to     foot   , and *said* _b_ _b_ _b_ ---                     
    ## [217]                --- Brown came back, shaking its     head    and *chattering* to itself _b_ ---              
    ## [218]                 --- _b_ *said* Rob, pulling his     hair    with both hands in the ---                      
    ## [219]                --- *said* Mr Perch, shaking his     head    and *speaking* in a silvery ---                 
    ## [220]                    --- *know* that I was within   hearing  , ' *said* Mr Morfin _b_ ---                     
    ## [221]                  --- he *said*, showing all his    teeth    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [222]             --- *said* the Captain, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [223]                    --- with that had struck his     hand    upon his forehead, and *said* ---               
    ## [224]                    --- struck his hand upon his   forehead , and *said* _b_ _b_ _b_ ---                     
    ## [225]            --- *said* Harriet, casting down her     eyes    upon her black dress _b_ ---                    
    ## [226]            --- *said* Alice, shrinking with her     face    behind her hand _b_ _b_ ---                     
    ## [227]                --- _b_ *said* Alice, taking the     hand    again, and fixing her lustrous ---              
    ## [228]                 --- *says* Mr. Sapsea, with his     legs    stretched out, and solemnly enjoying ---        
    ## [229]            --- *said* Mr. Grewgious, laying his     hand    on Rosa 's, as the ---                          
    ## [230]          --- *said* Mr. Crisparkle, rubbing his     ear    , as his mother resumed her ---                  
    ## [231]            --- _b_ *said* Neville, pressing his     hand    upon his face _b_ _b_ ---                       
    ## [232]               --- *says* Jasper, giving him his     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [233]                       --- *said* the man, as he     spat    out some blood, and wiped ---                   
    ## [234]        --- *said* Mr. Honeythunder, shaking his     head    again _b_ _b_ _b_ _b_ ---                       
    ## [235]                --- *said*, shaking his shock of     hair   , as a Newfoundland dog might ---                
    ## [236]               --- *said* Mr. Datchery, making a     leg     with his hat under his ---                      
    ## [237]           --- *said* Mr. Grewgious, passing his     hand    under his chin _b_ _b_ ---                      
    ## [238]                     --- _b_ _b_ *said* the man,   licking   his lips _b_ _b_ _b_ ---                        
    ## [239]                 --- *said* the man, licking his     lips    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [240]                --- Joe, solemnly, with his last     bite    in his cheek and *speaking* ---                 
    ## [241]                        --- his last bite in his    cheek    and *speaking* in a confidential ---            
    ## [242]              --- *said* my convict, turning his     eyes    on Joe in a moody ---                           
    ## [243]               --- *said* my sister, shaking her     head    at me as an encouragement ---                   
    ## [244]                      --- _b_ _b_ _b_ *said* he,    biting   the side of his great ---                       
    ## [245]           --- *said* Biddy, quietly raising her   eyebrows  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [246]             --- *said* Biddy, glancing over her   shoulder  again _b_ _b_ _b_ _b_ ---                       
    ## [247]            --- *said* Mr. Jaggers, throwing his    finger   at me sideways _b_ _b_ ---                      
    ## [248]           --- _b_ *said* Mr. Pumblechook, after   snorting  admiration at me for some ---                   
    ## [249]                 --- Pumblechook took me by both    hands    again, and *communicated* a movement ---        
    ## [250]                 --- _b_ *said* Mike, wiping his     nose    on his fur cap this ---                         
    ## [251]                  --- _b_ *said* he, putting his    thumbs   in his waistcoat pockets _b_ ---                
    ## [252]                --- *said* he, putting his large     hand    on my shoulder and moving ---                   
    ## [253]                 --- _b_ *said* he, sluicing his     face   , and *speaking* through the water-drops ---     
    ## [254]            --- *said* Joe, slightly tossing his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [255]                     --- _b_ *said* I, laying my     hand    upon his knee _b_ _b_ ---                       
    ## [256]                       --- _b_ *said* I, with my     head    still turned away _b_ _b_ ---                   
    ## [257]               --- *said* Wemmick, gravely in my     ear    , as he took my arm ---                          
    ## [258]                --- _b_ *said* Biddy, laying her     hand    upon my arm, as I ---                           
    ## [259]             --- *said* Mr. Jaggers, warming the    backs    of his legs with the ---                        
    ## [260]          --- *said* Miss Havisham, flashing her     eyes    upon her _b_ _b_ _b_ ---                        
    ## [261]             --- _b_ *said* Estella, raising her     eyes    after a silence _b_ _b_ ---                     
    ## [262]                 --- *said* he, looking over his   shoulder  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [263]                  --- *voice*, and laying a long    finger   on my breast in an ---                          
    ## [264]                  --- _b_ *said* he, dandling my    hands    up and down in his, ---                         
    ## [265]                   --- _b_ *said* he, laying his     hand    on my arm in a ---                              
    ## [266]            --- *said* Mr. Jaggers, offering his     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [267]          --- *said* he, superciliously over his   shoulder  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [268]                     --- _b_ *said* he, with his    hands    still in the sleeves _b_ ---                    
    ## [269]              --- *said* Mr. Jaggers, laying his     hand    upon my arm, and smiling ---                    
    ## [270]                 --- _b_ *said* he, bringing his     fist    down upon the table with ---                    
    ## [271]                  --- _b_ *said* he, folding his     arms    on the table again _b_ ---                      
    ## [272]                  --- _b_ *said* he, folding his     arms    again _b_ _b_ _b_ _b_ ---                       
    ## [273]          --- _b_ *said* Wemmick, scratching his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [274]        --- _b_ *said* Pumblechook, screwing his     head    at me in the old ---                            
    ## [275]        --- *said* Gradgrind, pondering with his    hands    in his pockets, and his ---                     
    ## [276]           --- *said* Mr. Childers, stroking his     face    again, and repeating his look ---               
    ## [277]                --- _b_ *said* Tom, tumbling his     hair    all manner of ways with ---                     
    ## [278]          --- *said* Tom, spitefully setting his    teeth    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [279]              --- _b_ *said* Sissy, covering her     eyes   , and sobbing yet _b_ _b_ ---                    
    ## [280]             --- *said* Mrs. Sparsit, making her     nose    more Roman and her eyebrows ---                 
    ## [281]        --- *said* Slackbridge then, shaking his     head    with violent scorn _b_ _b_ ---                  
    ## [282]           --- *said* Mr. Harthouse, putting his     hand    upon his shoulder and turning ---               
    ## [283]           --- _b_ *said* Bounderby, opening his     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [284]           --- *said* Mr. Gradgrind, shading his     face    with his hand _b_ _b_ ---                       
    ## [285]                --- _b_ *said* Rachael, with the    tears    in her eyes again _b_ ---                       
    ## [286]              --- _b_ *said* Bitzer, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [287]            --- *said* Sleary, after putting his     lips    to his brandy and water ---                     
    ## [288]              --- *said* Mr. Sleary, putting his     head    in at the door again ---                        
    ## [289]            --- *said* Pet, timidly touching her     hand    as it lay impassive on ---                      
    ## [290]                --- *whispered* it, and laid his     hand    nervously upon her desk _b_ ---                 
    ## [291]         --- *voice*, agitated, and clearing his    throat   every now and then _b_ ---                      
    ## [292]          --- *said* Little Dorrit, watching her     face    while she *spoke* _b_ _b_ ---                   
    ## [293]           --- _b_ _b_ *mentioning* that obscure     body    with reluctance, as his natural ---             
    ## [294]                 --- _b_ she *said*, bending her     face    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [295]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , in whom there was a ---                        
    ## [296]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , with a heightening colour _b_ ---              
    ## [297]                  --- Treasury turned him by the     arm     towards the sideboard and *spoke* ---           
    ## [298]                   --- _b_ _b_ _b_ *said* Maggy,   panting   for breath _b_ _b_ _b_ ---                      
    ## [299]               --- _b_ *said* Maggy, panting for    breath   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [300]                   --- *said* the girl, with her    bosom    swelling high, and *speaking* with ---          
    ## [301]               --- _b_ *said* Little Dorrit, her    heart    well-nigh broken _b_ _b_ _b_ ---                
    ## [302]                   --- _b_ he *said*, taking her     hand    again, and *speaking* lower than ---            
    ## [303]               --- *said* Mrs Gowan, tapping the     back    of her friend 's hand ---                       
    ## [304]               --- _b_ *said* Flora, putting her    hands    to her ears and moving ---                      
    ## [305]               --- *said* the other, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [306]           --- *said* the traveller, pulling his  moustache  dry with his hand, for ---                      
    ## [307]               --- *said* Mr Dorrit, raising his   eyebrows  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [308]                   --- _b_ _b_ *said* Mr Dorrit,   panting   with anger _b_ _b_ _b_ ---                      
    ## [309]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , almost as well composed in ---                 
    ## [310]                      --- _b_ _b_ _b_ _b_ *said*    Fanny    to her one night when ---                       
    ## [311]              --- *said* Mrs Merdle, turning the    bosom    towards that gentleman _b_ _b_ ---              
    ## [312]                 --- _b_ *said* Bar, nodding his     head   , for he was not to ---                          
    ## [313]           --- startling *touch* *on* Clennam 's     knee    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [314]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , when her sister 's gentleness ---              
    ## [315]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , without answering the question _b_ ---         
    ## [316]                      --- _b_ _b_ _b_ _b_ *said*    Fanny    with a sigh _b_ _b_ ---                         
    ## [317]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , returning the smile with one ---               
    ## [318]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , weighing her bonnet by the ---                 
    ## [319]            --- *said* Mr Dorrit, recovering his    breath   by a great effort, as ---                       
    ## [320]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , before whom Mrs General instantly ---          
    ## [321]                --- *said* Mr Dorrit, giving his     hand    a final pressure, and releasing ---             
    ## [322]                  --- *said* she, holding up her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [323]            --- *said* Mrs Sparkler, raising her     eyes    to him after another minute ---                 
    ## [324]                      --- _b_ _b_ _b_ _b_ *said*    Fanny   , yawning in a dreary manner ---                 
    ## [325]                   --- _b_ _b_ _b_ *said* Fanny,   yawning   in a dreary manner _b_ ---                      
    ## [326]          --- *said* Clennam, brushing away some    tears    that had been silently dropping ---             
    ## [327]                 --- _b_ _b_ _b_ *said* Clennam,   nerving   himself to go through with ---                  
    ## [328]             --- *said* Mrs Clennam, bending her    brows    upon him angrily _b_ _b_ ---                    
    ## [329]                 --- _b_ *said* Mr Pancks, whose     eye     had often stealthily wandered to ---            
    ## [330]                   --- _b_ *said* Affery, with a    shiver   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [331]             --- *said* Mr Meagles, clearing his    throat   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [332]           --- *said* Little Dorrit, raising her     eyes    to his _b_ _b_ _b_ ---                          
    ## [333]              --- *said* Mr Meagles, shaking his     head    very seriously _b_ _b_ _b_ ---                  
    ## [334]                  --- plainly *said* " I have my     eye     upon the rascal now _b_ ---                     
    ## [335]             --- *said* the hostess, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [336]            --- *said* Mr Pecksniff, keeping his     hand    in his waistcoat as though ---                  
    ## [337]            --- *said* Mr Pecksniff, towering on    tiptoe   among the curtains, as if ---                   
    ## [338]                --- *said* Mr Tigg, clapping one     hand    on the shoulder of his ---                      
    ## [339]               --- *said* Mr George, nodding his     head    violently at every second syllable ---          
    ## [340]                --- _b_ *said* Mark, shaking his     head    argumentatively _b_ _b_ _b_ _b_ ---             
    ## [341]             --- *said* Mr Pecksniff, waving his     hand    towards the wall _b_ _b_ ---                    
    ## [342]            --- *said* Mr Pecksniff, folding his    hands   , and looking at his young ---                   
    ## [343]                --- _b_ *said* Mr Pecksniff with    tears    in his eyes, as he ---                          
    ## [344]           --- _b_ *said* Mr Pecksniff, shedding    tears    and *speaking* with an imperfect ---            
    ## [345]               --- _b_ *said* Martin, waving his     hand    impatiently _b_ _b_ _b_ _b_ ---                 
    ## [346]             --- *said* Mr Pecksniff, drying his    hands    upon his handkerchief, and looking ---          
    ## [347]                      --- _b_ _b_ _b_ *said* he,   snapping  his fingers _b_ _b_ _b_ ---                     
    ## [348]                 --- _b_ *said* he, snapping his   fingers   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [349]               --- *said* Mr Pecksniff, with his     eyes    still closed _b_ _b_ _b_ ---                    
    ## [350]                 --- _b_ *said* Tom, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [351]               --- _b_ *said* Martin leaning his     chin    upon his hand, and looking ---                  
    ## [352]                --- *said* the other, giving his     hand    a hearty squeeze _b_ _b_ ---                    
    ## [353]            --- _b_ *said* Pecksniff, waving his     hand    and smiling _b_ _b_ _b_ ---                     
    ## [354]            --- *said* Mr Pecksniff, turning his     eyes    on Tom Pinch, even more ---                     
    ## [355]              --- _b_ *said* Martin, leaning his     chin    upon his hand, and looking ---                  
    ## [356]                --- _b_ *said* Mark, rubbing his    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [357]                --- _b_ *said* Mark, rubbing his     nose    with the knob at the ---                        
    ## [358]                  --- *said* Mark, taking a long    breath   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [359]                 --- *voice* almost in Martin 's     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [360]                --- _b_ *said* Mark, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [361]        --- and *speaking* confidentially in his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [362]                --- _b_ *said* Mould, waving his     hand    at the public in general ---                    
    ## [363]             --- *said* Mr Pecksniff, laying his     hand    tenderly upon his kinsman 's ---                
    ## [364]              --- _b_ *said* Jonas, clasping the    waist    of each _b_ _b_ _b_ ---                         
    ## [365]                    --- plan, but showing by his  tremulous  *voice* how much depended, in ---               
    ## [366]             --- _b_ *said* Martin, bringing his     hand    heavily upon the table _b_ ---                  
    ## [367]                      --- _b_ *said* Tigg in his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [368]              --- *said* the barber, opening his     eyes   , and putting on his raven ---                   
    ## [369]            --- *said* Mr Pecksniff, rolling his     head    portentously _b_ _b_ _b_ _b_ ---                
    ## [370]                 --- *said* Mary, giving him her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [371]               --- *said* Mr Tapley, shaking his     head    with a rueful air _b_ ---                       
    ## [372]               --- _b_ *said* Tom, extending his     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [373]              --- *said* the doctor smacking his     lips    after a glass of wine ---                       
    ## [374]              --- *said* the doctor, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [375]            --- *said* Mr Pecksniff, shaking his     hand    vigorously _b_ _b_ _b_ _b_ ---                  
    ## [376]            --- *said* Mr Pecksniff, shaking his     head    at Martin with indignant jocularity ---         
    ## [377]           --- *said* Mr Pecksniff, pressing his     hand    almost reverentially _b_ _b_ _b_ ---            
    ## [378]                 --- _b_ *said* Tom, shaking his     head    as if this were a ---                           
    ## [379]                --- *said* Mrs Gamp, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [380]                --- *said* Mrs Gamp, shaking her     head   , and shedding tears _b_ _b_ ---                 
    ## [381]                       --- -- his eyes and whole     face    brightening as he *spoke* _b_ ---               
    ## [382]          --- *said* Chuffey, stretching out his     arm     towards Jonas while an unwonted ---             
    ## [383]         --- _b_ *said* Nicholas, presenting his     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [384]         --- *said* that gentleman, smacking his     lips    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [385]              --- *said* he of the good-tempered     face    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [386]             --- _b_ *said* Squeers, rubbing his    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [387]               --- _b_ _b_ continued Kate, whose    tears    fell while she *spoke* _b_ ---                  
    ## [388]                   --- _b_ he *said*, taking her     arm     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [389]               --- *said* Miss Price: her bright     eye     dancing with merriment as she ---               
    ## [390]              --- _b_ *said* Newman, passing his     hand    hastily over the coat which ---                 
    ## [391]            --- *said* Mr Lillyvick, shaking his     head    mournfully _b_ _b_ _b_ _b_ ---                  
    ## [392]                 --- _b_ he *said*, wringing her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [393]               --- _b_ *said* Smike, shaking his     head    mournfully _b_ _b_ _b_ _b_ ---                  
    ## [394]                  --- *said* the lad, laying his     hand    timidly on that of Nicholas ---                 
    ## [395]            --- *said* the manager, striking his     knee    emphatically _b_ _b_ _b_ _b_ ---                
    ## [396]               --- *said* the actor, setting his    teeth    together, and drawing in his ---                
    ## [397]         --- *said* Miss Snevellicci, taking his     arm     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [398]                --- _b_ _b_ *said* Mr Lillyvick,   snapping  his fingers _b_ _b_ _b_ ---                     
    ## [399]           --- *said* Mr Lillyvick, snapping his   fingers   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [400]               --- _b_ *said* Ralph, rubbing his    hands    slowly over each other _b_ ---                  
    ## [401]           --- *said* Mr Wititterly, rubbing his    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [402]                   --- passing his arm round her    waist    as he *spoke* _b_ _b_ ---                       
    ## [403]                   --- _b_ _b_ _b_ *said* Ralph,   scowling  round, and shaking his clenched ---             
    ## [404]            --- _b_ *said* Nicholas, nodding his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [405]            --- _b_ *said* Nicholas, casting his     eye     upon the cramped direction _b_ ---              
    ## [406]             --- *said* Mr Crummles, shaking his     fist    at the comic countryman when ---                
    ## [407]         --- *said* Madame Mantalini, wiping her     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [408]          --- _b_ *said* Mrs Nickleby, shrinking     back    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [409]            --- _b_ *said* Nicholas, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [410]             --- *said* Mrs Nickleby, wiping her     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [411]             --- *said* Mrs Nickleby, drying her    tears    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [412]             --- *said* the invalid, turning his     head    impatiently towards the adjoining room ---      
    ## [413]               --- _b_ *said* Ralph, raising his     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [414]                   --- _b_ _b_ *said* Ralph, his     face    darkening, and his own hatred ---               
    ## [415]                --- _b_ *said* Kate, raising her     face    again _b_ _b_ _b_ _b_ ---                       
    ## [416]             --- *said* Mrs Nickleby, laying her     hand    on Kate 's _b_ _b_ ---                          
    ## [417]             --- *said* Mrs Nickleby, fixing her     eyes    modestly on the ground _b_ ---                  
    ## [418]                 --- _b_ *said* John, wiping his     eyes   ; 'a very bad _b_ _b_ ---                        
    ## [419]            --- *said* Miss Squeers, tossing her     head   , and looking contemptuously at the ---          
    ## [420]                    --- _b_ *said* John, 'noo my    blood    is oop, that thou'rt an ---                     
    ## [421]                 --- _b_ *said* Tim, folding his     arms    resolutely _b_ _b_ _b_ _b_ ---                  
    ## [422]            --- *said* Mrs Nickleby, rubbing her     nose    with an impassioned air _b_ ---                 
    ## [423]               --- _b_ *said* Kate, stealing her     arm     round her mother 's neck ---                    
    ## [424]      --- continued Madame Mantalini, drying her     eyes   , and *speaking* with great indignation ---      
    ## [425]              --- _b_ *said* Noggs, stopping for    breath   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [426]                  --- _b_ *said* Ralph, 'by your    tongue  ; and HIM' (pointing to Smike ---                
    ## [427]      --- *said* brother Charles, with sparkling     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [428]            --- _b_ *said* Nicholas, shaking his     head   , and making an attempt to ---                   
    ## [429]                   --- _b_ he *said*, laying his     hand    on Newman 's _b_ _b_ ---                        
    ## [430]                 --- *said* Mr Kenwigs, with one     hand    round Mrs Kenwigs 's waist: ---                 
    ## [431]             --- _b_ *said* Ralph, suffering his     lip     to curl into a smile ---                        
    ## [432]                 --- _b_ he *said*, stamping his     foot    impatiently upon the ground _b_ ---             
    ## [433]   --- *said* Nicholas, extending his disengaged     hand    in the air _b_ _b_ ---                          
    ## [434]                 --- _b_ *said* Peg, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [435]                    --- Tim, catching him by the     arm     and *speaking* most earnestly _b_ ---           
    ## [436]                    --- _b_ *said* Ralph, as his     eyes    brightened _b_ _b_ _b_ _b_ ---                  
    ## [437]             --- *said* Ralph, pointing with his    finger   towards the recess already *mentioned* ---      
    ## [438]             --- *said* Mrs Nickleby, wiping her     eyes   , and sobbing bitterly _b_ _b_ ---               
    ## [439]                       --- laid his hand upon my     arm     and leant forward to *whisper* ---              
    ## [440]                  --- _b_ he *said*, putting his     hand    into his breast and sidling ---                 
    ## [441]               --- *said* Mrs Quilp, nodding her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [442]                 --- *said* the boy, nodding his     head    and drawing back, with the ---                  
    ## [443]              --- *said* Quilp, wrinkling up his     eyes    and luring her towards him ---                  
    ## [444]             --- _b_ *said* Quilp, with gleaming     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [445]                 --- *said* the boy, nodding his     head    and rubbing it at the ---                       
    ## [446]             --- *said* the child with streaming     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [447]                 --- _b_ *said* Dick shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [448]                 --- _b_ *said* Dick shaking his     head    with a look of infinite ---                     
    ## [449]                  --- which shone in her flushed     face   , trembling *voice*, and impassioned gesture --- 
    ## [450]                 --- *said* the child passing an     arm     round his neck _b_ _b_ ---                      
    ## [451]              --- *said* the dwarf, smacking his     lips    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [452]             --- *said* Quilp, nursing his short     leg    , and making his eyes twinkle ---                
    ## [453]               --- _b_ *said* Quilp, rubbing his  shoulders  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [454]               --- *said* Mr Codlin, beating his     hand    on the little footboard where ---               
    ## [455]            --- *said* the landlord smacking his     lips    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [456]               --- _b_ *said* Jerry, putting his     hand    into the capacious pocket of ---                
    ## [457]    --- *whispered* the schoolmaster, anxious to    rouse    him, for a dulness seemed ---                   
    ## [458]        --- *said* the schoolmaster, shaking his     head   , and smiling thoughtfully _b_ _b_ ---           
    ## [459]                         --- _b_ she *said* in a  tremulous  *voice*, after they had walked ---              
    ## [460]            --- *said* Mr Chuckster, running his   fingers   through his hair _b_ _b_ ---                    
    ## [461]                      --- _b_ _b_ _b_ _b_ *said*     Jowl   , lying down again with a ---                    
    ## [462]                      --- _b_ _b_ _b_ _b_ *said*     Jowl    with feigned reluctance _b_ _b_ ---             
    ## [463]                      --- _b_ _b_ _b_ _b_ *said*     Jowl   , warming his hands at the ---                   
    ## [464]                --- _b_ *said* Jowl, warming his    hands    at the fire _b_ _b_ ---                         
    ## [465]                  --- _b_ he *said*, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [466]               --- *said* the lawyer shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [467]            --- *said* Mr Chuckster, shaking his     head    gravely, as men are wont ---                    
    ## [468]            --- *said* Mr Swiveller, folding his     arms    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [469]              --- *said* Brass, laying his right     hand    on his waistcoat, and looking ---               
    ## [470]             --- _b_ *said* Richard, passing his     hand    over his forehead and turning ---               
    ## [471]                    --- _b_ _b_ _b_ *said* Dick,   rousing   himself from this pause, and ---                
    ## [472]              --- *said* Miss Brass, folding her     arms    as though she were about ---                    
    ## [473]              --- *said* Miss Brass, raising her     head   , with which she had hitherto ---                
    ## [474]                --- _b_ he *said*, with flashing     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [475]             --- *said* Mr Garland, pressing his     hand    after a pause _b_ _b_ ---                       
    ## [476]              --- _b_ *said* Eugene, putting his     legs    up on the opposite seat ---                     
    ## [477]                  --- his arms, smoking with his     eyes    shut, and *speaking* slightly through ---       
    ## [478]         --- and *speaking* slightly through his     nose    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [479]                       --- *voice* was as if the     head    of his boat 's mop ---                          
    ## [480]               --- *said* Mr Boffin, rubbing his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [481]             --- *said* Eugene, smoking with his     eyes    on the fire _b_ _b_ ---                         
    ## [482]                     --- tilted it into his left    cheek   , as *saying* _b_ _b_ _b_ ---                    
    ## [483]                      --- _b_ jerked it into his   stomach  , as *saying* _b_ _b_ _b_ ---                    
    ## [484]               --- *said* Mr Boffin, rubbing his    hands    in his pleasantly childish admiration ---       
    ## [485]             --- Mrs Boffin, *speaking* with her     eyes    closed, and her left hand ---                   
    ## [486]                   --- *said* Mrs Boffin, with a     face    inviting trust _b_ _b_ _b_ ---                  
    ## [487]          --- *said* Bradley, with his clutching     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [488]             --- *said* Mrs Wilfer, presenting a    cheek    to be kissed, as sympathetic ---                
    ## [489]              --- _b_ *said* Lizzie, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [490]               --- _b_ *said* Bella, raising her     eyes    to his, after a little ---                      
    ## [491]           --- *said* Bradley, after casting his     eyes    on the ground _b_ _b_ ---                       
    ## [492]                    --- *said*, taking one up to     eye     it closely _b_ _b_ _b_ ---                      
    ## [493]            --- _b_ *said* Fledgeby, meeting his     eyes    with a wink _b_ _b_ ---                         
    ## [494]              --- *said* Bella, pushing back her     hair    from her temples with both ---                  
    ## [495]                 --- *said* her father, with his     hand    to his eyes _b_ _b_ ---                         
    ## [496]              --- would *say*, checking Bella 's     arm     at a bookseller 's window ---                   
    ## [497]            --- _b_ *said* Venus, taking another     gulp    of tea and mournfully winking ---               
    ## [498]              --- *said* Bella, turning away her     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [499]               --- _b_ *said* Jenny, shaking her     head    and her emphatic little forefinger ---          
    ## [500]                  --- _b_ *said* Bradley, with a    frown    and a distant look before ---                   
    ## [501]                    --- *said* Mrs Lammle to the   skeleton  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [502]                     --- *said* Mr Lammle to the   skeleton  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [503]                  --- the *point* aside with his     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [504]                --- *said* Mr Boffin, laying his     hand    on Bella 's head again ---                      
    ## [505]                --- glowing *voice*, as Bella 's     hand    stole gradually up his waistcoat ---            
    ## [506]              --- a pitcher, and *conveying* his     face    to her rosy lips _b_ ---                        
    ## [507]               --- *says* Mrs Lammle, fixing her     eyes    on his face, to enforce ---                     
    ## [508]                      --- fixing her eyes on his     face   , to enforce what she *says* ---                 
    ## [509]              --- *says* Mrs Lammle, raising her     eyes    to his face again, and ---                      
    ## [510]               --- *says* Mrs Lammle, fixing his     eyes    with hers: which he would ---                   
    ## [511]       --- discreet young gentleman, standing on    tiptoe   to *whisper* _b_ _b_ _b_ ---                    
    ## [512]           --- _b_ *said* Riderhood, shaking his     head    with an air of thorough ---                     
    ## [513]                   --- _b_ *said* Wegg, with one     arm     a-kimbo and his head on ---                     
    ## [514]               --- in alarmed *appeal*, with his    hands    on his knees _b_ _b_ ---                        
    ## [515]               --- _b_ *said* Lizzie, fixing her     eyes    upon him with the look ---                      
    ## [516]            --- *said* Riderhood, turning on his     heel    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [517]             --- *said* young Hexam, shaking his     head    in a half-threatening manner _b_ ---            
    ## [518]         --- *said* John Rokesmith, touching her    cheek   , with a grave smile, as ---                     
    ## [519]            --- *said* Eugene, again shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [520]                     --- *said* the owner of the     hand    which had done this _b_ ---                     
    ## [521]               --- _b_ _b_ _b_ *said* Riderhood,   snapping  his fingers at him half ---                     
    ## [522]          --- _b_ *said* Riderhood, snapping his   fingers   at him half a dozen ---                         
    ## [523]               --- *said* the man: clenching his    hands   , and stamping furiously on the ---              
    ## [524]         --- _b_ *whispered* Oliver, folding his    hands    together _b_ _b_ _b_ _b_ ---                    
    ## [525]           --- *said* Oliver, without taking his     eyes    from the canvas _b_ _b_ ---                     
    ## [526]             --- *said* Sikes, putting his other     hand    to Oliver 's throat _b_ ---                     
    ## [527]             --- _b_ *said* Oliver, wringing his    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [528]                  --- _b_ *said* Nancy, pale and  breathless from the scuffle _b_ _b_ ---                    
    ## [529]                --- the child pressing his small    hands    together, and *speaking* with great ---         
    ## [530]                   --- _b_ _b_ _b_ *said* Sikes,   scowling  fiercely on his agreeable friend ---            
    ## [531]                  --- *said* the Jew, fixing his     eyes    on Oliver _b_ _b_ _b_ ---                       
    ## [532]             --- *said* this figure, turning his     head    towards the door _b_ _b_ ---                    
    ## [533]              --- *said* the matron, leaning her    elbow    on the table, and looking ---                   
    ## [534]               --- *said* Mr. Giles, nodding his     head   , approvingly _b_ _b_ _b_ _b_ ---                
    ## [535]            --- *said* Rose, smiling through her    tears    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [536]              --- *said* Mrs. Maylie, laying her    finger   on her lip, as she ---                          
    ## [537]                  --- _b_ *said* Mr. Bumble, his    teeth    *chattering* as he *spoke* _b_ ---              
    ## [538]            --- _b_ *said* Monks, with quivering     lip    , and glancing over his shoulder ---             
    ## [539]                --- _b_ *said* Sikes, fixing his     eyes    upon her, and muttering the ---                 
    ## [540]                --- _b_ she *said*, clasping her    hands    passionately before her face _b_ ---            
    ## [541]               --- _b_ *said* Sikes, turning his     face    to Crackit _b_ _b_ _b_ ---                      
    ## [542]                     --- he *said*, in a *voice*  tremulous  with emotion _b_ _b_ _b_ ---                    
    ## [543]              --- *said* Mr. Snodgrass, in whose    bosom    a blaze of poetry was ---                       
    ## [544]                    --- grasping the old lady 's     hand   , and *speaking* so loud that ---                
    ## [545]               --- *said* Mr. Jingle, fixing his     eyes    on the aunt 's face ---                         
    ## [546]            --- *said* his attendant, 'every man    slept    vere he fell down; we ---                       
    ## [547]                  --- _b_ *said* Mr. Tupman, his     face    suffused with a crimson glow ---                
    ## [548]             --- Tupman, *speaking* in a *voice*  tremulous  with emotion, and tucking up ---                
    ## [549]                --- _b_ *said* Job, smacking his     lips    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [550]               --- _b_ *says* he, a-squeezing my     hand    wery hard, and vispering in ---                 
    ## [551]              --- _b_ *said* Fogg, thrusting his    hands    into his trousers ' pockets, ---                
    ## [552]               --- *said* the lady, covering her     eyes    with her hands _b_ _b_ ---                      
    ## [553]                  --- Job, his eyes filling with    tears    as he *spoke* _b_ _b_ ---                       
    ## [554]              --- *said* Miss Nupkins, forcing a     tear    of very scanty proportions into ---             
    ## [555]                --- _b_ *said* Mr. Pickwick, his     eyes    glistening with delight at this ---             
    ## [556]                  --- _b_ _b_ *said* Bob Sawyer,   blinking  this last question _b_ _b_ ---                  
    ## [557]         --- *said* Serjeant Buzfuz, folding his     arms    emphatically, and turning half-round to ---     
    ## [558]           --- *said* Mr. Pickwick, grasping his     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [559]           --- *said* Mr. Winkle, trembling from     head    to foot _b_ _b_ _b_ ---                         
    ## [560]            --- *said* Mr. Winkle, extending his     hand    -- his teeth *chattering* all ---               
    ## [561]                   --- extending his hand -- his    teeth    *chattering* all the time he ---                
    ## [562]           --- *said* Mr. Pickwick, with beaming     eyes    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [563]         --- *said* the gentleman, thrusting his    hands    into his pockets, and looking ---               
    ## [564]               --- *said* Mr. Roker, pausing for    breath   when they reached another gallery ---           
    ## [565]                --- _b_ _b_ *said* Mr. Pickwick,   gasping   no less from excitement than ---                
    ## [566]               --- *said* Mr. Roker, shaking his     head    slowly from side to side, ---                   
    ## [567]             --- *said* Mr. Pickwick, laying his     hand    gently and compassionately on his ---           
    ## [568]                --- a *whisper*, and applied his    mouth    to the ear of his ---                           
    ## [569]               --- _b_ *said* Roker, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [570]               --- *said* Mr. Weller, wiping his   forehead  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [571]                 --- *said* Mr. Weller, with the    tears    still running down his cheeks, ---              
    ## [572]                   --- _b_ *said* Job, with real    tears    in his eyes, for once ---                       
    ## [573]            --- Pickwick, who had been evidently    roused   by his friend 's *appeal* ---                   
    ## [574]              --- can *communicate* to the human     face    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [575]                  --- Mr. Ben Allen, setting his    teeth    together, and *speaking* more like ---          
    ## [576]              --- *said* Bob Sawyer, rubbing his    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [577]           --- *said* Mr. Pickwick, smacking his     lips    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [578]              --- *said* Mr. Pickwick taking her     hand    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [579]               --- *said* Mr. Weller, wiping his   forehead  _b_ _b_ _b_ _b_ _b_ ---                         
    ## [580]              --- *said* Mr. Weller, nodding his     head    with a satisfied air _b_ ---                    
    ## [581]            --- Pickwick and *whispering* in his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [582]           --- *said* Mr. Pickwick, clearing his    throat   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [583]                 --- _b_ she *said*, raising her     hand    to Mr. Lorry as he ---                          
    ## [584]               --- _b_ *said* Mr. Cruncher, with unconscious inconsistency _b_ _b_ _b_ _b_ ---               
    ## [585]             --- _b_ *said* Stryver, nodding his     head    over him as he reviewed ---                     
    ## [586]               --- _b_ *said* Darnay, upon whose     ear     the mournful *voice* struck with ---            
    ## [587]             --- _b_ *said* Stryver, shaking his     head    in his bullying way _b_ ---                     
    ## [588]            --- _b_ *said* Stryver, squaring his    elbows   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [589]                     --- the mender of roads, on    tiptoe   and in a low *voice* ---                        
    ## [590]                  --- _b_ *said* Defarge, in his     ear     _b_ _b_ _b_ _b_ _b_ ---                         
    ## [591]          --- *said* madame, extending her right     hand   , for emphasis _b_ _b_ _b_ ---                   
    ## [592]                --- _b_ *said* madame, drawing a    breath   and nodding her head with ---                   
    ## [593]              --- *said* Mr. Lorry, clearing his    throat   _b_ _b_ _b_ _b_ _b_ ---                         
    ## [594]              --- *said* Mr. Lorry, clasping his    hands    _b_ _b_ _b_ _b_ _b_ ---                         
    ## [595]                --- _b_ *said* Miss Pross, whose     eyes    were red with felicity _b_ ---                  
    ## [596]              --- *said* Miss Pross, nodding her     head    emphatically _b_ _b_ _b_ _b_ ---                
    ## [597]                 --- his *story*, and laying his     hand    on hers _b_ _b_ _b_ ---                         
    ## [598]               --- excusing herself, with a pale     face    and in a faltering *voice* ---                  
    ## [599]             --- *said* Mr. Cruncher, wiping his   forehead  with his arm, as an ---                         
    ## [600]           --- *said* Madame Defarge, laying her     hand    with a slight frown on ---                      
    ## [601]               --- _b_ *said* Miss Pross, wildly    crying   _b_ _b_ _b_ _b_ _b_ ---

``` r
# "X5.1+" - "Attention"
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("X5.1+"), context = 0)
y
```

    ## [ 1]                     --- Mr. Bucket has read his    face    with the greatest *attention* all ---    
    ## [ 2]    --- elder, *concentrating* his strong steady    brow    upon him and smiling confidently ---     
    ## [ 3]      --- scrutinising it *attentively*, while a breathless silence reigned around; for he ---       
    ## [ 4]                     --- he had eyed his smiling    face    from time to time *intently* ---         
    ## [ 5]      --- replied Traddles, on whose *attentive*    face    a thoughtful shade had stolen ---        
    ## [ 6]                 --- at the *attentive* and stem    face    opposed to her _b_ _b_ ---               
    ## [ 7]                      --- with his hat under his     arm   , as he *addressed* *himself* equally --- 
    ## [ 8]                         --- with the end at his    mouth   and still *observant* of me ---          
    ## [ 9] --- at the *attentive*, uncomplainingly shocked    face    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [10]            --- *attentively* in Mr Pecksniff 's    face    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [11]                   --- *herself* to John on this    head    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [12]                          --- his hand on Tom 's    wrist  , to bespeak his *attention*, and ---     
    ## [13]           --- Mr Inspector, with an *attentive*     ear    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [14]               --- his *attention* by fixing his    head    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [15]                    --- went on slowly, with his    eyes    narrowly *observant* of the two ---      
    ## [16]              --- at Mr. Pickwick 's *attentive*    face    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [17]                    --- his hands clasped at his    back   , like a docile and *attentive* ---       
    ## [18]                       --- with her hands on his   breast  , and the inquiring and *attentive* ---

``` r
# "N3.8" - "Measurement: Speed"
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("N3.8"), context = 0)
y
```

    ## Warning in max(nchar(x$N, type = "chars")): no non-missing arguments to max; returning -Inf

    ## [1] --- --- 
    ## [0] --- ---

``` r
# "O1.2-" - "Substances and materials generally: Liquid -"
y <- corp_concordance(long_sus_surface, nodes = nodes, collocates= c("O1.2-"), context = 0)
y
```

    ## [ 1]           --- _b_ she returned, *drying* her    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 2]      --- Mrs. Bagnet, hurriedly *drying* her    eyes   on the hem of her ---                    
    ## [ 3]               --- said my aunt, *drying* her    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 4]                 --- _b_ here she *dried* her    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 5]             --- Mrs Chick, *drying* both her    eyes   at once with great care ---              
    ## [ 6]                 --- Rosa, as she *dried* her    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 7]       --- _b_ returned Rachael, *drying* her    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 8]                  --- _b_ _b_ she *dried* her   tears   quickly _b_ _b_ _b_ _b_ ---              
    ## [ 9]          --- said the traveller, pulling his moustache *dry* with his hand, for ---             
    ## [10]             --- his moustache *dry* with his    hand  , for he had dipped it ---                
    ## [11]          --- said Mr Pecksniff, *drying* his   hands   upon his handkerchief, and looking ---   
    ## [12]          --- said Mrs Nickleby, *drying* her   tears   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [13] --- continued Madame Mantalini, *drying* her    eyes  , and speaking with great indignation --- 
    ## [14]     --- continued Mrs Nickleby, *drying* her    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [15]             --- resignation as she shook her    head   and *dried* her eyes _b_ ---             
    ## [16]                 --- her head and *dried* her    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [17]                --- _b_ began Bradley, with a   mouth   so *dry* that he had ---                 
    ## [18]      --- Georgiana, sobbing and *drying* her    face  , and then searching in a ---             
    ## [19]         --- returned Mr. Lorry, *drying* his    eyes   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [20]             --- Pross, striving to *dry* her    eyes   and compose herself _b_ _b_ ---

How this document was generated
===============================

This document is written in
[rmarkdown](https://cran.r-project.org/package=rmarkdown). The intension
is to use [knitr](https://cran.r-project.org/package=knitr) to generate
either `html` or `pdf` versions of the document. The advantage of
`rmarkdown` is that `R` code examples can be embedded in the document –
the code samples being executed and the results generated when the
document is ‘compiled’. Details of the citation syntax can be found in
the [pandoc documentation](http://pandoc.org/MANUAL.html#citations).
Details of equation numbering can be found in the [MathJax
documentation](http://mathjax.readthedocs.io/en/latest/tex.html#automatic-equation-numbering).
Combining code with documentation is a form of [literate
programming](https://www-cs-faculty.stanford.edu/~knuth/lp.html).

In a linux environment the `html` document can be generated on the
command liner like this:

``` bash
Rdev -e "rmarkdown::render('DNov_quotes_long_sus.Rmd')"
```
