-   [Data](#data)
    -   [Get the corp\_text objects](#get-the-corp_text-objects)
    -   [Create a data.table where each column is a set of types for the
        tokens](#create-a-data.table-where-each-column-is-a-set-of-types-for-the-tokens)
    -   [Corpus size](#corpus-size)
-   [Unmatched tokens](#unmatched-tokens)
-   [Analysis: 1. Comparing manually chosen, specific body part terms +
    “lexical” collocates in DNov quotes
    vs. non-quotes](#analysis-1.-comparing-manually-chosen-specific-body-part-terms-lexical-collocates-in-dnov-quotes-vs.-non-quotes)
    -   [Figure 1: Plot of specific, manually chosen body part terms
        +“lexical” collocates in DNov quotes
        vs. non-quotes](#figure-1-plot-of-specific-manually-chosen-body-part-terms-lexical-collocates-in-dnov-quotes-vs.-non-quotes)
-   [Analysis: 2. Comparing B1 + all “lexical” collocates in DNov quotes
    vs. non-quotes](#analysis-2.-comparing-b1-all-lexical-collocates-in-dnov-quotes-vs.-non-quotes)
    -   [Number of (lexical) types & tokens in B1 &
        examples](#number-of-lexical-types-tokens-in-b1-examples)
        -   [Quotes](#quotes)
        -   [Non-quotes](#non-quotes)
    -   [Concordances of “lexical”
        collocates](#concordances-of-lexical-collocates)
        -   [Concordances: Non-quotes](#concordances-non-quotes)
        -   [Figure 2: Plot of B1 +“lexical” collocates in DNov quotes
            vs. non-quotes](#figure-2-plot-of-b1-lexical-collocates-in-dnov-quotes-vs.-non-quotes)
-   [Analysis: 3. Comparing B1 + all semantic types in DNov quotes
    vs. non-quotes](#analysis-3.-comparing-b1-all-semantic-types-in-dnov-quotes-vs.-non-quotes)
    -   [Figure 3: Plot of B1 + “semantic tag collocates” in DNov quotes
        vs. non-quotes](#figure-3-plot-of-b1-semantic-tag-collocates-in-dnov-quotes-vs.-non-quotes)
    -   [Concordances of semantic tag
        collocates](#concordances-of-semantic-tag-collocates)
        -   [Concordances of semantic tag collocates:
            Quotes](#concordances-of-semantic-tag-collocates-quotes)
        -   [Concordances of “semantic tag collocates”:
            Non-quotes](#concordances-of-semantic-tag-collocates-non-quotes)
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

non_quotes_files <- list.files("./api-output-sem-tagged/DNov/nonquote_corp_text_objects/", full.names = TRUE)
non_quotes_objects <- lapply(non_quotes_files, readRDS)
non_quotes_text <- corp_text_rbindlist(non_quotes_objects)
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
non_quotes_type_store <- data.frame(
    lc_tokens = tolower(non_quotes_text$tokens$token),
    semantic_tags = stri_extract_first(non_quotes_text$tokens$type, regex = "^([A-Z]\\d+(?:\\.\\d+)*[+-]?)"),
    stringsAsFactors = FALSE
)
```

Corpus size
-----------

(Currently counts *b*)

Quotes

``` r
#Count tokens without the co-occurrence barriers (i.e. ssubset boundaries) _b_ (NA)
sum(quotes_text$tokens$token!="_b_", na.rm = TRUE)
```

    ## [1] 1424857

Non-quotes

``` r
#Count tokens without the co-occurrence barriers (i.e. ssubset boundaries) _b_ (NA)
sum(non_quotes_text$tokens$token!="_b_", na.rm = TRUE)
```

    ## [1] 2478456

Unmatched tokens
================

The Z99 tag contains “unmatched” tokens. These can be looked up like
this for the quotes (but take up a lot of space):

``` r
#a <- corp_type_lookup(quotes_text)
#a[type == "Z99"]$tokens
```

And like this for the nonquotes

``` r
#b <- corp_type_lookup(non_quotes_text)
# b[type == "Z99"]$tokens
```

Analysis: 1. Comparing manually chosen, specific body part terms + “lexical” collocates in DNov quotes vs. non-quotes
=====================================================================================================================

``` r
quotes_text$tokens$type <- with(quotes_type_store, lc_tokens)
quotes_text$tokens$type[is.na(quotes_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers
non_quotes_text$tokens$type <- with(non_quotes_type_store, lc_tokens)
non_quotes_text$tokens$type[is.na(non_quotes_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers

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
head(non_quotes_text$tokens, 20)
```

    ##     idx       type start end      token
    ##  1:   1       <NA>    13  15        _b_
    ##  2:   2       <NA>    17  19        _b_
    ##  3:   3       <NA>    21  23        _b_
    ##  4:   4       <NA>    25  27        _b_
    ##  5:   5       <NA>    29  31        _b_
    ##  6:   6     london    33  38     London
    ##  7:   7 michaelmas    41  50 Michaelmas
    ##  8:   8       term    52  55       term
    ##  9:   9     lately    57  62     lately
    ## 10:  10       over    64  67       over
    ## 11:  11        and    70  72        and
    ## 12:  12        the    74  76        the
    ## 13:  13       lord    78  81       Lord
    ## 14:  14 chancellor    83  92 Chancellor
    ## 15:  15    sitting    94 100    sitting
    ## 16:  16         in   102 103         in
    ## 17:  17    lincoln   105 111    Lincoln
    ## 18:  18         's   113 114         's
    ## 19:  19        inn   116 118        Inn
    ## 20:  20       hall   120 123       Hall

``` r
# the set of nodes and collocates we are interested in
nodes <- c('eye', 'eyes', 'forehead', 'hand', 'hands', 'head', 'shoulder')
nodes
```

    ## [1] "eye"      "eyes"     "forehead" "hand"     "hands"    "head"     "shoulder"

``` r
#co-occurrences
quotes_surface <- corp_surface(quotes_text, span = "5LR", nodes = nodes)
non_quotes_surface <- corp_surface(non_quotes_text, span = "5LR", nodes = nodes)

# compare quotes vs. non-quotes
results <- corp_coco(quotes_surface, non_quotes_surface, nodes = nodes)
```

Figure 1: Plot of specific, manually chosen body part terms +“lexical” collocates in DNov quotes vs. non-quotes
---------------------------------------------------------------------------------------------------------------

``` r
plot(results)
```

![](DNov_quotes_non-quotes_files/figure-markdown_github/body_parts_DNov_quotes_vs_non_quotes_lexical-1.png)

Analysis: 2. Comparing B1 + all “lexical” collocates in DNov quotes vs. non-quotes
==================================================================================

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
non_quotes_text$tokens$type <- with(non_quotes_type_store, ifelse(grepl("^B1", semantic_tags), semantic_tags, lc_tokens))
non_quotes_text$tokens$type[is.na(non_quotes_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers
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
# All "token types" tagged as B1 in quotes
unique(tolower(a[type == "B1"]$tokens))
```

    ## [1] "hearing, brains, finger, hand, born, head, sleeping, livers, wake, tired, go, to, bed, forehead, hair, tear, skin, sleep, heart, cheeks, ears, eyes, cheek, breathed, hands, blood, veins, wrist, hip, lips, face, back, room, consciousness, tire, mouth, asleep, lap, chest, lungs, snoring, teeth, teeth, throat, bones, breathing, eye, breath, body, legs, waist, breast, hearts, heads, ear, beard, birth, necks, skulls, tongue, bite, neck, bodily, knuckles, unconscious, blue-eyed, puts, goes, shoulders, sucked, feet, endurance, slumbers, waking, nose, foot, breathe, shoeless, knees, ankles, limbs, thirsty, swallow, hip, marrow, marrow, fist, marrows, nap, dozing, arms, wide, awake, hand, thirst, brain, faces, rouse, eyelids, slumbering, bile, complexion, shiver, profile, fingers, secreted, sleeps, arm, rousing, arms, tears, roused, bone, emaciated, going, ankle, bronchial, insensible, up, shoulder, flesh, gave, skins, brow, fringe, slept, spit, went, limb, crying, gone, eyebrows, wake, fast, bleed, put, bronzed, beard, wakes, unborn, sleep, faces, gore, tires, sleepy, falling, skull, hair's-breadth, noses, slumber, tooth, gnaws, face., backs, fall, snores, tush, drowsy, blood-vessels, anatomical, bodies, in, beards, thumb, licked, biting, waking, physical, ear., nimbler, go, rouse, bit, thirsts, soles, lip, cells, tongues, sleeping, bladder, wrists, tear, bare-footed, elbow, nerve, woke, awoke, wince, ribs, rib, bites, bites, leg, biled, blood, heel, frowned, liver, free, bosom, breathing-time, physically, face, fingers, toes, moustachios, bald, eyebrow, chin, stomach, knee, spine, bitten, thinness, blood-relation, spluttered, passage, swallowing, nerves, frown, organ, skeletons, skeleton, inhaling, fanny, tiring, bones, gored, biles, turnspits, jaws, give, snore, heart, lacerating, numbness, elbows, pins, and, needles, gall, liver, sleepless, brow, snapped, slumbered, head, unwound, yawn, hymen, breathed, blood-vessel, body, off, haunch, awake, bosoms, back, build, pulse, pitch-fork, shivers, round, bone, flabby, fore-foot, sole, gnawed, magnifying-glass, shivering, sweat, finger-nails, spluttering, tired, joints, hunchback, benumbed, hands, brows, sinews, snored, fallen, barefoot, anatomist, gone, bellies, bite, tiptoe, paunch, swallowed, bleeding, foreheads, chests, thirsty., born, bust, thumbs, nimble, palm, mouths, legs, looked, secrete, palms, vein, codicil, kidney, torpor, baldness, one-eyed, joint, skinny, anatomy, hairs, endurances, spat, unsaid, alabama, quaffed, snores, hearts, organ-loft, lick, holds, its, toe, births, looks, gastric, tip-toe, pimples, limb, toe, asleep, gasping, dimple, belly, jugular, bled, thumb, moustaches, orbs, pimples, organs, thirsting, unsay, waken, sneezed, cell, frowning, bloods, b-o-t, bot, fists, swallow, eyelashes, bodily, throats, laps, inhaled, nervous, system, collar-bone, complexions, tears, necks, sneezing, waists, lashes, thirsty, secreting, shivering, gnawing, sniffing, sniff, lies, ca-daverous, look, bloodshot, sneeze, arm, falls, jowl, mole, livered, shivered, unwind, bodies, born., snap, codicil, skulls, cuticle, gulp, anatomy, stomachs, unwinds, numbed, chins, thumbnail, sweats, sweating, blood-money, drowsiness, unsay, heart., nape, tooth-powder, suck, bile, instrumental, pore, flesh, bowels, cheek, suck, snooze, respiration, eyes, eye, weed, gasp, bare-facedest, knuckle, beat, mustachios, snoozing, bleeds, tiptoes, biling, heads, soles, tremulous, blown, out, doze, given, breathes, eyed, frowns, muscles, panting, perspiring, ocular, gasped, sleepy, tongue, scowl, agility, hind-quarters, muscular, swallowed, breathless, moustache, blink, eyelid, turpin, perspiration, eye-, browed, thighs, hips, scowling, exhalations, visage, hand."

### Non-quotes

``` r
b <- corp_type_lookup(non_quotes_text)

# Number of tokens tagged as B1 in non-quotes
nrow(non_quotes_text$tokens[type=="B1"])
```

    ## [1] 42877

``` r
# Top 20 frequency of (lexical) types tagged as B1
freq_list <- (as.data.frame(sort(table(non_quotes_text$tokens[type=="B1"]$token), decreasing = TRUE)))
head(freq_list, 20)
```

    ##        Var1 Freq
    ## 1      head 3883
    ## 2      hand 3823
    ## 3      face 3572
    ## 4      eyes 3287
    ## 5     hands 1833
    ## 6     heart 1186
    ## 7       arm 1174
    ## 8       eye  876
    ## 9      hair  846
    ## 10     arms  805
    ## 11     back  738
    ## 12     lips  677
    ## 13    tears  660
    ## 14     feet  589
    ## 15    mouth  508
    ## 16   breast  505
    ## 17 shoulder  502
    ## 18     legs  489
    ## 19     foot  457
    ## 20     nose  428

``` r
# All "token types" tagged as B1 in non-quotes
unique(tolower(b[type == "B1"]$tokens))
```

    ## [1] "face, feet, foot, foot, eyes, throats, toes, fingers, shivering, heart, head, heads, faces, brain, born, brains, fleshing, hand, frown, legs, back, sleeping, wake, spits, hair, breast, physical, elbow, dozes, lips, complexion, brow, finger, cheek, tears, bosom, sleep, hands, forehead, frowning, chin, arm, body, panting, drowsy, neck, skull, room, hearing, biting, heel, knees, fast, asleep, arms, crying, noses, awoke, bald, mouth, going, to, unconscious, tired, pouting, lap, slumbered, awake, teeth, bones, chests, bones, cadaverous, shoulders, breath, throat, eyebrows, hairs, veins, skin, shoulder, hearts, tiptoe, perspiration, blood-relation, gone, bed, waist, skeleton, slept, waists, bleed, snort, sleeps, wakes, eyeball, pitchfork, ears, dozing, tire, yawn, gnaw, gasp, thirsty, foreheads, nose, consciousness, cheeks, fist, droppings, gasping, eye, consanguinity, chest, thumb, snoring, palm, skins, tongues, bone, flesh, backs, elbows, beard, ear, lip, tongue, licking, palms, arms, go, bodies, headless, jaws, anatomy, breasts, limb, tear, leg, busts, blue-eyed, flabby, sucking, knee, blood, awakes, bite, bodily, went, birth, marrows, vein, shoeless, pant, nerves, breathless, frowned, gnawing, thirstier, joints, spit, marrow, chins, eyelash, breathing, insensible, fall, limbs, organ, purses, swallows, gulp, moustache, thighs, gasps, slumber, eyelashes, eyebrow, goes, muscles, breathe, knuckles, contraction, collation, hip, bit, held, his, dozed, tooth, nimble, nocturnal, visage, thumb-nail, shiver, woke, up, out, wide, swallowing, tremulous, appendages, boned, freckled, tanned, three-legged, thigh, impassiveness, snorts, sleepy, shivered, blink, round, sniff, necks, lies, in, tissue-paper, sleepless, stomachic, waking, bloodshot, respiration, brows, appendage, muscle, hips, breast-pocket, endurance, breathed, escutcheons, eyed, swallow, blinks, bitten, dimple, nape, profile, wrists, breathes, falls, pimples, emaciated, shivers, pulse, muscular, blowing, sole, doze, orb, fallen, fringe, skeletons, blown, tendon, ligament, swig, trimmed, eyelids, finger-nails, nap, tears, yawns, pores, scowl, wrist, hilltops, cell, mouths, dilatation, soles, eyelid, rouse, swallowed, roused, lashes, cheekbone, breaths, nimbly, rousing, drowsiness, stomach, nerve, splutter, liver, heart, given, ankles, ocular, thigh-bone, skulls, anatomical, shins, hiccup, fists, agility, natal, twinkling, toe, sneezed, antlers, tiring, yawned, hiccoughed, waking, holding, her, yawning, slumbers, wakefulness, panted, nerved, slumbering, thirst, grey-eyed, snapping, snore, their, guttural, sucked, bosoms, gulping, physically, lungs, dimples, beard, beards, falling, puckered, bearding, snapped, snored, pore, spat, scowling, panting, bleeding, nervous, system, spider-like, secreted, sniffs, exhaled, unwound, licked, heads, gnaws, thirsted, cells, barefooted, gasped, face, sleep, guard-rooms, dead, the, world, thirsting, lapped, jaw, pins, and, needles, ironical, passages, tired, gnawed, gall, pulses, sinews, ankle, spleen, spine, quaffed, blooded, head, frowns, sleepiness, snorting, visages, orally, inhaling, half, blinking, chiffonier, nostrils, sleep-walking, kidney, thinness, build, throat, ringlets, blinking, sleepy-headed, kidneys, sneezing, haunch, pursing, blood, beat, wince, wincing, sniffing, unsaid, pouted, stayed, baldness, thumbs, hearts, looking, tan, unsay, snivel, cuirasses, organs, unconscious, numbed, behind, our, licks, awakening, unrefreshed, erection, hill-top, giving, nostril, tip-toe, winced, bow, steeple-chase, free, bones, bust, sniffed, awaking, awaking, refraction, knock-knee, secreting, snorted, lobes, scalp, cranium, breasting, bowels, eyes, breath, ringlet, hair's-breadth, barefoot, breasting, girt, secrete, sneeze, breastbone, beards, ribs, dental, overslept, marrow-bones, naps, rousing, belching, pregnant, furrowed, waken, unborn, skinny, rib, bled, awake, unwind, orbs, breathe, mole, hill-tops, bronzed, nerving, lash, hand., somnambulism, collations, inhales, groins, creeper, pouts, off, squat, ankle-bone, shoulder-blades, stoning, shouldering, palate, haired, appanage, drowsy, gulped, bites, gulps, picture-cards, gore, stolidity, cell, one-eyed, fanny, looked, joint, spitting, tendons, uncoil, fangs, hymen, spluttering, freckles, antennae, thumb, stomachs, knuckling, knuckled, body, hands, legged, hand, birth, codicil, perspirations, fertilization, torpor, sneezes, facial, perspiring, bleary, blinked, suck, blue-eyed, keen-eyed, lunged, rooms, breathings, belly, nasal, insteps, perspiring, puckering, hairsbreadth, knuckle, roused, court-cards, sleeping-, entrails, face, fertility, bronchial, exhaling, inhalation, exhalation, bosom, eye, organ, falling, give, endurances, veined, veining, dozing, inhaled, collar-bone, instep, oral, pungency, bile, lick, lobe, thirsts, hiccups, quavering, blear-eyed, quaffing, phalanx, scowled, sinew, sweat, lips, sucking-pig, profiles, erections, armpits, pursed, arteries, organ-loft, toe, licks, distention, back, jugular, awoke, pout, invisibility, beating, antler, twinklings, moustachios, corporal, lacerate, put, scowls, hiccuped, tires, unwinding, spinal, wakening, snores, exhalations, wake, under-lip, cheek-bones, benumbed, jowl, shivering, fingernails, shin, inhale, complexions, shoulder-blade, fast, mouth-organ, on, all, fours, jowl, snap, two-handed, dismal, arm, torso, body, stomach, huffing, nose, molars, bodies, bald, clotting, conscious, osteologists, anatomist, chiromancy, rouses, deglutition, clots, well-built, nimbler, drowsiest, sweated, spluttered, howler, fishbone, fang, eye-brows, laps, gave, picture-card, cock-fighting, hunchback, wakened, bloods, knock-kneed, blood-shot, arm-pits, blood-vessel, mouths, slumber, waked, gasping, bleeds, snortings, tic, appendix, emaciation, steeplechase, respired, turpin, bald-headed, contractions, cheekbones, champing, blood, blood-money, livers, paunch, bum, ear, escutcheon, hold, blood-vessels, tissue, guard-room, moustaches, sweaty, look, physical, breathing, bare-foot"

``` r
# the set of nodes and collocates we are interested in
nodes <- unique(grep("^B1", c(quotes_text$tokens$type, non_quotes_text$tokens$type), value = TRUE))
nodes
```

    ## [1] "B1"

``` r
#co-occurrences
quotes_surface <- corp_surface(quotes_text, span = "5LR", nodes = nodes)
non_quotes_surface <- corp_surface(non_quotes_text, span = "5LR", nodes = nodes)

# compare
results <- corp_coco(quotes_surface, non_quotes_surface, nodes = nodes)
```

Concordances of “lexical” collocates
------------------------------------

These are concordances of the B1 tag with specific “lexical” collocates
(e.g. “rubbing”) - chosen from the plot. At this point we are mainly
interested in the collocates of body part terms/the B1 tag in
non-quotes, so have created concordances for this corpus only.

### Concordances: Non-quotes

``` r
# replied
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("replied"), context = 0)
y
```

    ## [  1]               --- _b_ he *replied*, pressing my     arm    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [  2]           --- _b_ *replied* Caddy, crossing her    hands   confidentially upon my arm _b_ ---           
    ## [  3]               --- _b_ he *replied*, folding his    arms    upon his broad chest and ---                 
    ## [  4]           --- chair, whispered something in his     ear   . Mr. Vholes *replied* aloud -- ---           
    ## [  5]                --- now *replied* with a burning    face    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [  6]         --- he slowly *replied*, roughening his    head    more and more _b_ _b_ ---                    
    ## [  7]                        --- It was indeed a glad   hearing  to him, he *replied* _b_ ---                 
    ## [  8]              --- *replied* the nian, waving his    hand    and turning on his heel ---                  
    ## [  9]      --- *replied* fiercely, imitating with his    hand    the thrust of a sword ---                    
    ## [ 10]               --- _b_ he *replied*, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 11]            --- *replied*, menacing her with his    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 12]             --- he *replied*, spreading out his    hands   before the fire _b_ _b_ ---                  
    ## [ 13]          --- she *replied*, wagging her ancient    head   , for good. There was a ---                   
    ## [ 14]         --- _b_ Gashford *replied*, casting his    eyes    upon his papers _b_ _b_ ---                  
    ## [ 15]              --- George *replied* by laying his    hand    upon the shoulder of his ---                 
    ## [ 16]        --- *replied* the secretary, nursing his     leg    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 17]             --- _b_ she *replied*, wringing her    hands   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 18]            --- _b_ *replied* Em'ly, shaking her    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 19]           --- Micawber hysterical, and she shed    tears   as she *replied* _b_ _b_ ---                 
    ## [ 20] --- my appearance, generally *replied*, without   hearing  what I had to say, ---                       
    ## [ 21]          --- the chimney-piece, and folding her    hands   upon her folded skirts, *replied* ---        
    ## [ 22]            --- work, and *replied*, folding her    hands   upon one another, and looking ---            
    ## [ 23]      --- _b_ *replied* Peggotty, trembling from    head    to foot _b_ _b_ _b_ ---                      
    ## [ 24]                  --- _b_ he *replied*, with his    head    thrown back in an easy-chair ---             
    ## [ 25]             --- _b_ *replied* Dora, slapping my    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 26]         --- he *replied*, patiently shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 27]      --- *replied* Traddles, on whose attentive    face    a thoughtful shade had stolen ---            
    ## [ 28]               --- _b_ he *replied*, shaking his    head   , seriously _b_ _b_ _b_ _b_ ---               
    ## [ 29]          --- *replied* the Captain, putting his    hand    on Walter 's shoulder _b_ ---                
    ## [ 30]       --- *replied* Doctor Blimber, rubbing his    chin    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 31]                --- _b_ _b_ *replied* his Uncle,   rousing  himself from a temporary abstraction ---     
    ## [ 32]           --- *replied* the Major, shutting one     eye   , putting his head on one ---                 
    ## [ 33]              --- _b_ *replied* Rob, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 34]                   --- the least effect upon his    face   , *replied* _b_ _b_ _b_ _b_ ---               
    ## [ 35]                    --- _b_ *replied* the man of    teeth   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 36]        --- _b_ *replied* Cleopatra, shaking her    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 37]               --- _b_ he *replied*, shaking his    head    mournfully _b_ _b_ _b_ _b_ ---               
    ## [ 38]  --- *replied*, attiring herself, with fumbling   fingers  _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 39]                     --- or at least, turned her    head    towards her when addressed; *replied* ---    
    ## [ 40]          --- *replied* the Captain, meeting her    eyes    in confusion _b_ _b_ _b_ ---                 
    ## [ 41]          --- *replied* the Captain, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 42]          --- _b_ *replied* Walter, grasping his    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 43]                   --- said on Mr. Crisparkle 's    face   , *replied* -- to Mr. Crisparkle, ---         
    ## [ 44]             --- good gentleman *replied* with a    snort  , which might mean yes, or ---                
    ## [ 45]            --- she *replied*, glancing over her  shoulder  as he slouched after us ---                  
    ## [ 46]                     --- learn a lesson from his    face   , and slowly *replied* _b_ _b_ ---            
    ## [ 47]          --- _b_ *replied* Wemmick, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 48]      --- _b_ *replied* Estella, disengaging her     arm   , and moving to the great ---                 
    ## [ 49]               --- _b_ he *replied*, holding his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 50]                         --- by the shake of the    head    that *replied* to him _b_ ---                
    ## [ 51]            --- Baptist *replied* that he should    sleep   as long as he would, ---                     
    ## [ 52]          --- gentleman *replied* by kissing the   fingers  of his right hand, and ---                   
    ## [ 53]           --- Barnacle *replied* that they grew    tired  , got dead beat, got lamed, ---               
    ## [ 54]               --- _b_ _b_ *replied* his friend,   yawning  and stretching himself _b_ _b_ ---           
    ## [ 55]                       --- as he pressed his hot    hands   together, and *replied*, with humility ---   
    ## [ 56]    --- _b_ *replied* Pecksniff, with moistening    eyes    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 57]              --- _b_ *replied* Tom, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 58]                --- *replied* Tom Pinch, who was breathless with the haste he had ---                    
    ## [ 59]            --- palpitations, and turning up her    eyes    *replied* in a faint voice ---               
    ## [ 60]                  --- face, and casting down his    eyes    again, *replied* _b_ _b_ _b_ ---             
    ## [ 61]             --- _b_ _b_ *replied* Nicholas, his    heart   swelling as he spoke _b_ ---                 
    ## [ 62]           --- _b_ _b_ *replied* Kate, shrinking    back    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 63]          --- *replied* the stranger, moving his    eyes    towards the baron, but not ---               
    ## [ 64]          --- *replied* Mrs Squeers, nodding her    head    at Nicholas, and eyeing him ---              
    ## [ 65]           --- *replied* the youth, pressing his    hands   together, as though to control, ---          
    ## [ 66]         --- _b_ *replied* Nicholas, shaking his    head    mournfully _b_ _b_ _b_ _b_ ---               
    ## [ 67]            --- *replied* Smike, clinging to his    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 68]                   --- but merely *replied* by a    gasp   , which, according to the action ---          
    ## [ 69]            --- two forefingers, and tapping his    nose    with the apex thereof, *replied* (---        
    ## [ 70]        --- *replied* Lord Frederick, fixing his    eyes    on Miss Nickleby _b_ _b_ ---                 
    ## [ 71]       --- _b_ *replied* Nicholas, extending his    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 72]          --- *replied* Mr Crummles, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 73]         --- *replied* Mr Lillyvick, shaking his    head    nervously _b_ _b_ _b_ _b_ ---                
    ## [ 74]         --- *replied* Mrs Nickleby, tossing her    head   , and looking prodigiously sly _b_ ---        
    ## [ 75]          --- *replied* Sir Mulberry, laying his    hand    on her arm _b_ _b_ ---                       
    ## [ 76]            --- _b_ *replied* Smike, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 77]         --- *replied* Mr Folair, scratching his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 78]  --- *replied* Ralph, impatiently extending his    hand    for the bills _b_ _b_ ---                    
    ## [ 79]       --- _b_ *replied* Squeers, scratching his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 80]    --- *replied* Newman, suddenly thrusting his    face    into that of Squeers _b_ ---                 
    ## [ 81]           --- _b_ *replied* Smike, pressing his    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 82]          --- *replied* brother Ned, nodding his    head    as a man thoroughly determined ---           
    ## [ 83]         --- *replied* Mrs Nickleby, tossing her    head    and looking at the ashes ---                 
    ## [ 84]        --- *replied* Sir Mulberry, striking his    hand    upon the table. _b_ _b_ ---                  
    ## [ 85]            --- _b_ *replied* Sir Mulberry Hawk,   biting   his lip, and pointing to ---                 
    ## [ 86]         --- _b_ *replied* Squeers, feasting his    eyes    upon the countenance of Smike ---            
    ## [ 87]        --- *replied* Mr Squeers, scratching his    nose    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 88]         --- *replied* Miss Squeers, shaking her    head    vehemently _b_ _b_ _b_ _b_ ---               
    ## [ 89]            --- _b_ *replied* John, stopping his    mouth   again, the instant he had ---                
    ## [ 90]         --- _b_ *replied* Smike, trembling from    head    to foot _b_ _b_ _b_ ---                      
    ## [ 91]          --- _b_ *replied* Nicholas, taking his    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 92]         --- *replied* the stranger, folding his    hands   together _b_ _b_ _b_ _b_ ---                 
    ## [ 93]           --- *replied* the keeper, shaking his    head    so emphatically that he was ---              
    ## [ 94]   --- *replied* the Yorkshireman, extending his    mouth   from ear to ear _b_ ---                      
    ## [ 95]                  --- at him with a contemptuous    frown  , and *replied* with a sneer, ---             
    ## [ 96]             --- immovable aspect, and his fixed     eye    very fixed indeed, *replied*, suiting ---    
    ## [ 97]          --- _b_ *replied* Gride, arresting his    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 98]        --- _b_ *replied* Nicholas, clearing his   throat   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 99]               --- pony *replied* by shaking his    head   . It was plain that the ---                   
    ## [100]                        --- with the baby in his    arms   , and *replied* aloud _b_ _b_ ---             
    ## [101]           --- *replied* Quilp, shrugging up his  shoulders _b_ _b_ _b_ _b_ _b_ ---                      
    ## [102]             --- _b_ *replied* Nell, turning her    head    aside, and speaking softly. _b_ ---          
    ## [103]                --- *replied* Kit with his whole    heart   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [104]             --- as he *replied*, with trembling    lips    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [105]                       --- arm round the girl 's    waist  . But, she only *replied* _b_ ---             
    ## [106]                --- _b_ To conclude, smacked his    lips   , as if all three *replied* ---               
    ## [107]                    --- affect the fruits of the    sweat   of his brow -- *replied*, ---                
    ## [108]                         --- of the sweat of his    brow    -- *replied*, unreservedly _b_ _b_ ---       
    ## [109]         --- *replied*, beginning to conceal her   elbows   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [110]           --- *replied*, hooking her two little   fingers  in one another, and addressing ---           
    ## [111]           --- _b_ *replied* Eugene, shaking his    head    blankly, after pausing again to ---          
    ## [112]          --- she *replied* through her starting    tears   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [113]        --- Lavvy, sitting with defiantly folded    arms   , *replied* (but not audibly _b_ ---          
    ## [114]                    --- Venus shook his shock of    hair   , as he *replied* _b_ _b_ ---                 
    ## [115]                    --- Venus shook his shock of    hair    as he *replied* _b_ _b_ ---                  
    ## [116]                --- much disturbed, and with his    hand    fluttering about his forehead, *replied* --- 
    ## [117]               --- his hand fluttering about his  forehead , *replied* _b_ _b_ _b_ _b_ ---               
    ## [118]            --- *replied* Mr Boffin, nodding his    head    soothingly, as who should say, ---           
    ## [119]           --- *replied* Alfred, showing all his    teeth   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [120]               --- of quickened breathing in his  nostrils ; the schoolmaster *replied*, in a ---        
    ## [121]                 --- *replied* Oliver, in a low,  tremulous voice _b_ _b_ _b_ _b_ ---                    
    ## [122]                    --- _b_ _b_ Bumble shook his    head   , as he *replied* _b_ _b_ ---                 
    ## [123]               --- _b_ _b_ *replied* Oliver: the    tears   standing in his eyes as ---                  
    ## [124]                     --- _b_ _b_ _b_ *replied* a  tremulous voice. _b_ _b_ _b_ _b_ ---                   
    ## [125]           --- *replied* Sikes: appearing at the    head    of the stairs, with a ---                    
    ## [126]             --- *replied* the woman, laying her    hand    over the other 's mouth ---                  
    ## [127]         --- *replied* the matron, inclining her    head    to catch the words, as ---                   
    ## [128]             --- *replied* the girl, raising her    head    languidly _b_ _b_ _b_ _b_ ---                
    ## [129]           --- *replied* Mr. Bumble, shading his    eyes    with his hand, and surveying ---             
    ## [130]             --- *replied* the girl, turning her    face    aside, and forcing a laugh ---               
    ## [131]                 --- _b_ _b_ *replied* the girl,  shivering, and as she did so, ---                      
    ## [132]             --- *replied* the girl, shaking her    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [133]              --- *replied* the girl, waving her    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [134]            --- *replied* the girl, wringing her    hands   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [135]          --- _b_ _b_ *replied* Oliver, shedding    tears   of delight _b_ _b_ _b_ ---                   
    ## [136]        --- *replied* Mrs. Bolter, extending her    hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [137]             --- _b_ *replied* Fagin shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [138]             --- *replied* the girl, shaking her    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [139]          --- _b_ *replied* Sikes, clenching his    teeth   and turning white at the ---                 
    ## [140]          --- _b_ *replied* Noah, scratching his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [141]                --- *replied*, looking up with a    face    retaining no human expression but ---        
    ## [142]              --- *replied* the man, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [143]              --- Snodgrass seized his friend 's    hand    warmly, as he enthusiastically *replied* --- 
    ## [144]               --- his greatcoat thrown over his     arm   , he *replied* in the affirmative. ---        
    ## [145]              --- *replied* Mr. Snodgrass; and a    tear    trembled on his sentimental eyelid, ---      
    ## [146]                    --- applied his elbow to his     eye    as he *replied*, " Gone, Tom, ---            
    ## [147]                   --- _b_ _b_ _b_ *replied* the  one-eyed  bagman _b_ _b_ _b_ _b_ ---                   
    ## [148]              --- *replied* by pointing with his    thumb   over his shoulder, and Mr. ---               
    ## [149]       --- *replied* Mr. Weller, with astonished    eyes   . 'It 's the old _b_ ---                      
    ## [150]                  --- elder Mr. Weller shook his    head   , as he *replied* with a ---                  
    ## [151]                   --- _b_ Mr. Grummer shook his    head   , and *replied* _b_ _b_ _b_ ---               
    ## [152]       --- *replied* Jackson, slowly shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [153]           --- *replied* Mr. Weller, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [154]              --- _b_ *replied* Sam, shaking his    head    dubiously; 'nothin' less than a ---          
    ## [155]          --- _b_ *replied* Arabella, drying her    tears   with her handkerchief. She would ---         
    ## [156]                  --- the money with a trembling    hand   , and *replied* that he did ---               
    ## [157]          --- _b_ *replied* George, wringing the    heads   off half a dozen shrimps, ---                
    ## [158]              --- _b_ _b_ *replied* the cobbler,   biting   the end of his pipe ---                      
    ## [159]              --- _b_ *replied* Job, shaking his    head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [160]       --- *replied* Master Bardell, opening his    eyes    very wide as he delivered ---                
    ## [161]       --- *replied* Master Bardell, shaking his    head   , and applying himself to the ---             
    ## [162]       --- *replied* Mr. Pickwick, thrusting his    head    out of the window _b_ ---                    
    ## [163]                   --- _b_ _b_ _b_ *replied* the  one-eyed  man _b_ _b_ _b_ _b_ ---                      
    ## [164]            --- *replied* the boy, expanding his    mouth   to the whole breadth of ---                  
    ## [165]             --- _b_ _b_ *replied* Mr. Pickwick,  shivering _b_ _b_ _b_ _b_ _b_ ---                      
    ## [166]                       --- the pie. He fixed his    eyes    on Mary, and *replied* _b_ ---

``` r
# returned
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("returned"), context = 0)
y
```

    ## [  1]                   --- of being *returned* on the     hands     of her patron saint that ---               
    ## [  2]             --- _b_ *returned* Miss Jellyby with     tears     in her eyes _b_ _b_ ---                    
    ## [  3]         --- *returned* Miss Jellyby, shaking her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [  4]         --- *returned* Miss Jellyby, opening her      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [  5]               --- _b_ he *returned*, shaking his      head    , which he could do to ---                  
    ## [  6]   --- *returned* Richard, carelessly tossing his      hair     from his forehead _b_ _b_ ---              
    ## [  7]              --- _b_ *returned* my guardian, his      face     irradiated by the gentleness and ---       
    ## [  8]                 --- _b_ I *returned*, raising my      head     from my work to look ---                   
    ## [  9]               --- _b_ she *returned*, drying her      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 10]          --- _b_ *returned* Charley, putting her      head     forward and folding her hands ---          
    ## [ 11]          --- *returned* Mr. Skimpole, his genial      face     irradiated by the comicality of ---        
    ## [ 12]               --- _b_ he *returned*, shaking his      head    . _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 13]                         --- When she lay down to     sleep    , and not before, I *returned* ---          
    ## [ 14]        --- *returned* Mr. Woodcourt, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 15]           --- *returned* Mr. George, folding his      arms     upon his breast with perfect ---           
    ## [ 16] --- *returned* inquiringly, raising his pleasant    eyebrows   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 17]        --- *returned* the locksmith, shaking his      head    , and smiling _b_ _b_ _b_ ---               
    ## [ 18]        --- *returned* the locksmith, rubbing his     hands     and warming them _b_ _b_ ---               
    ## [ 19]              --- *returned* Mrs Varden, with her      eyes     upon the print _b_ _b_ ---                 
    ## [ 20]           --- little cupboard, *returned* with a   thigh-bone , which in former times must ---            
    ## [ 21]             --- *returned* the other, waving his      hand     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 22]            --- *returned* the other, leaning his      arm      upon the chimney-piece, and turning ---    
    ## [ 23]              --- *returned* the son, raising his      head     for a moment, and then ---                 
    ## [ 24]                --- _b_ he *returned* between his     teeth    , as he motioned her aside ---              
    ## [ 25]                   --- be near something that was     awake     and glad -- he *returned* ---              
    ## [ 26]            --- *returned* the other, raising his      head     a little from the cushion ---              
    ## [ 27]        --- *returned* the locksmith, shaking his      head     again _b_ _b_ _b_ _b_ ---                  
    ## [ 28]           --- _b_ *returned* John, elevating his    eyebrows  , and lowering his voice to ---             
    ## [ 29]            --- *returned* the man, thrusting his     tongue    into his cheek _b_ _b_ ---                 
    ## [ 30]            --- *returned* the other, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 31]              --- *returned* Sir John, fixing his      eyes     upon him _b_ _b_ _b_ ---                   
    ## [ 32]          --- *returned* his friend, dropping his      hand    , and looking at Gashford for ---           
    ## [ 33]          --- *returned* Mr Haredale, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 34]                   --- the remotest corner of the      cell    ; but although he *returned* them ---       
    ## [ 35]                     --- smote it with his ironed     hands    . The man *returned* to lock ---            
    ## [ 36]               --- _b_ *returned* Sir John, whose      face     cleared up when he saw ---                 
    ## [ 37]             --- *returned* Sir John, tapping his    forehead   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 38]                --- _b_ _b_ *returned* my mother,    pouting    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 39]          --- *returned* Mr. Dick, scratching his      ear      with his pen, and looking ---              
    ## [ 40]              --- *returned* my aunt, shaking her      head     at him _b_ _b_ _b_ ---                     
    ## [ 41]            --- _b_ *returned* Uriah, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 42]       --- *returned* Mrs. Markleham, shaking her      head     and her fan _b_ _b_ ---                    
    ## [ 43]              --- he *returned*, looking over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 44]         --- *returned* Miss Mowcher, shaking her      head     violently _b_ _b_ _b_ _b_ ---              
    ## [ 45]                  --- had been affected almost to     tears    . I *returned* thanks, and hoped ---        
    ## [ 46]               --- *returned* my host nodding his      head     with an air of toleration ---              
    ## [ 47]           --- _b_ _b_ *returned* Mr. Waterbrook,    pursing    up his mouth, and playing ---              
    ## [ 48]            --- he *returned*, rubbing his double      chin     again _b_ _b_ _b_ _b_ ---                  
    ## [ 49]       --- *returned* Miss Mowcher, squeezing her     hands     upon her heart one over ---                
    ## [ 50]                --- _b_ *returned* Dora, with her      hand     on julia 's _b_ _b_ ---                    
    ## [ 51]           --- *returned* Agnes, raising her soft      eyes     to mine _b_ _b_ _b_ ---                    
    ## [ 52]                --- *returned* my aunt, taking my      arm      _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 53]              --- and *returned* the elevation of    eyebrows   with which he said " 'Wielding ---         
    ## [ 54]               --- _b_ he *returned*, pressing my      hand     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 55]           --- _b_ *returned* Mr. Micawber, whose      face     clouded at this reference _b_ ---          
    ## [ 56]                  --- _b_ _b_ she *returned*, her      eyes     filled with tears _b_ _b_ ---              
    ## [ 57]             --- *returned*, her eyes filled with     tears     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 58]                         --- of a father; but her      eyes     *returned* to her mother 's ---            
    ## [ 59]                  --- *returned* to her mother 's      face     immediately, and she neither moved ---     
    ## [ 60]               --- _b_ *returned* the child, with     tears     springing to her eyes _b_ ---              
    ## [ 61]                  --- the boy *returned*, she was    sleeping   peacefully _b_ _b_ _b_ _b_ ---             
    ## [ 62]             --- _b_ *returned* Paul, folding his      arms     (they were hardly long enough ---          
    ## [ 63]               --- *returned* the pressure of his      hand    , and thanked him. _b_ _b_ ---              
    ## [ 64]           --- _b_ *returned* Walter, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 65]                     --- But this figure with its      head     upon its hand *returned* so ---            
    ## [ 66]                       --- with its head upon its      hand     *returned* so often, and remained ---      
    ## [ 67]           --- *returned* the Captain, giving his      hand     another squeeze _b_ _b_ _b_ ---            
    ## [ 68]             --- there soon *returned* the placid      face    , the softened voice, the loving ---        
    ## [ 69]              --- *returned* old Sol, rubbing his     hands     slowly, and considering the matter ---     
    ## [ 70]           --- _b_ *returned* Toodle, shaking his      head     with a face of great ---                   
    ## [ 71]            --- *returned* the Major, kissing his      hand     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 72]                --- he *returned*, bearing on his      arm      the same elegantly dressed and ---         
    ## [ 73]         --- *returned* her visitor, pressing her      hand     hastily _b_ _b_ _b_ _b_ ---                
    ## [ 74]              --- _b_ she *returned*, nodding her      head     at the fire _b_ _b_ ---                    
    ## [ 75]          --- *returned*, sitting with her folded      arms    , and knitted brows, and compressed ---     
    ## [ 76]                   --- _b_ and stretching out her      arms    , she *returned* the caress of ---          
    ## [ 77]                         --- the use of her right      hand     *returned*; and showing it to ---          
    ## [ 78]            --- _b_ *returned* Susan, shaking her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 79]           --- *returned* his wife, immoveable in      eye     , and voice, and attitude _b_ ---           
    ## [ 80]                    --- _b_ She determined not to       go      to bed until Edith *returned*, ---         
    ## [ 81]                     --- She determined not to go       to      bed until Edith *returned*, and ---        
    ## [ 82]                      --- determined not to go to      bed      until Edith *returned*, and if ---         
    ## [ 83]                   --- first touch of Florence 's      arm     , and they *returned* with the ---          
    ## [ 84]             --- _b_ *returned* the Grinder, with     tears     in his eyes _b_ _b_ ---                    
    ## [ 85]            --- *returned* Mr Toots, grasping his      hand     fervently, 'I shall certainly be ---       
    ## [ 86]           --- *returned* her guardian, for whose      ear      the timid emphasis was much ---            
    ## [ 87]                       --- ring. With this in his      hand    , he *returned* to his chair. ---           
    ## [ 88]  --- *returned* the Philanthropist, squaring his      arms     still more, as he frowned ---              
    ## [ 89]           --- *returned* Helena, with a mantling      face    . _b_ _b_ _b_ _b_ _b_ (---                  
    ## [ 90]                     --- again, and he turned his      back    . The boat had *returned*, and ---          
    ## [ 91]             --- not possibly have *returned* the     skull    , after moralizing over it, without ---     
    ## [ 92]             --- _b_ *returned* Estella, with her      eyes     on me instead _b_ _b_ ---                  
    ## [ 93]               --- _b_ he *returned*, shaking his      head     at me with a deliberate ---                
    ## [ 94]          --- *returned* Mr. Jaggers, turning his      eyes     upon me coolly, and taking ---             
    ## [ 95]               --- out as a *returned* transport.     Waking   , I never lost that fear. ---               
    ## [ 96]        --- _b_ *returned* Drummle, pretending to      yawn    , but equally determined _b_ _b_ ---        
    ## [ 97]                 --- hands, and crushed her white      hair    , and *returned* to this cry ---            
    ## [ 98]                --- he *returned*, drawing a long     breath    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 99]                --- *returned* into the house and      went     to bed. _b_ _b_ _b_ ---                    
    ## [100]         --- *returned* Mrs. Sparsit, shaking her      head     with her State humility _b_ ---            
    ## [101]              --- _b_ *returned* Tom, chafing his      face     on his coat-sleeve, as if ---              
    ## [102]           --- _b_ *returned* Sissy, clasping her     hands     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [103]                      --- slept in his chair. Her      eyes     *returned* to that corner, and ---         
    ## [104]                      --- his arm, and kissed her     cheek    . She *returned* the kiss, but ---          
    ## [105]            --- _b_ *returned* Sissy, shaking her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [106]           --- _b_ *returned* Rachael, drying her      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [107]         --- *returned* John Baptist, closing his      eyes     and giving his head a ---                  
    ## [108]                     --- and seemed to prefer his      jaws    , to which he *returned* as ---             
    ## [109]               --- _b_ she *returned*, fixing her      eyes     upon him _b_ _b_ _b_ ---                   
    ## [110]              --- having them *returned* upon his     hands     by a dozen agents in ---                   
    ## [111]                          --- _b_ He seemed to be     dozing    when she *returned*, and she ---           
    ## [112]               --- would be *returned* upon their     hands     from divers parts of the ---               
    ## [113]            --- *returned* Mrs Gowan, shaking her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [114]              --- _b_ she *returned*, raising her      eyes     frankly to his face _b_ ---                
    ## [115]                 --- *returned* the son, over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [116]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny    , with an appearance of amiably ---         
    ## [117]       --- *returned* Gowan, touching the painted      face     with his brush in the ---                  
    ## [118]                   --- she *returned* in the same     breath    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [119]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny     (in a tone suggesting that ---             
    ## [120]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [121]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [122]              --- _b_ _b_ *returned* the careless     Fanny     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [123]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [124]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny    , kissing her _b_ _b_ _b_ ---               
    ## [125]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny    , rather sharply _b_ _b_ _b_ ---            
    ## [126]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [127]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny    , taking him up short upon ---              
    ## [128]              --- *returned* Doyce, with his grey      eye      looking kind and bright _b_ ---            
    ## [129]            --- _b_ *returned* Doyce, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [130]                  --- *returned* the grasp of his      hand    , and, casting a farewell look ---          
    ## [131]                      --- as though he dusted his     hands    , *returned*, very much against his ---     
    ## [132]                   --- _b_ _b_ _b_ _b_ *returned*     Fanny    , with great indignation _b_ _b_ ---        
    ## [133]             --- _b_ *returned* John, turning the     wrist     backwards and forwards in the ---          
    ## [134]            --- _b_ *returned* John, brushing his      hand     across his eyes _b_ _b_ ---                
    ## [135]                    --- it sounded into Arthur 's     heart    , his sense of weakness *returned*. ---     
    ## [136]           --- *returned* her father, raising his      hand     mildly _b_ _b_ _b_ _b_ ---                 
    ## [137]          --- *returned* Mrs Todgers, nodding her      head     with mysterious intelligence _b_ _b_ ---   
    ## [138]               --- Mr Pecksniff *returned* with a   breathless  rapidity, strange to observe in ---        
    ## [139]                   --- Mark, while Mark, with his      head     reclining on his hand, *returned* ---      
    ## [140]                    --- his head reclining on his      hand    , *returned* the compliment in a ---        
    ## [141]                       --- have seen him, had his consciousness *returned*, but hiding, as it ---          
    ## [142]           --- *returned* the doctor, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [143]       --- *returned* the gentleman, affecting to      yawn     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [144]              --- *returned* the man, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [145]     --- *returned* Montague, without raising his      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [146]              --- had invested herself with these   appendages  she *returned* to her chair, ---           
    ## [147]           --- _b_ *returned* Martin, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [148]            --- _b_ *returned* Martin, waving his      hand    , and moving towards the door ---           
    ## [149]       --- *returned* Miss Pecksniff, tossing her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [150]             --- minutes, he *returned*, with his      legs     thoroughly stretched, if the hue ---       
    ## [151]   --- _b_ *returned* Madame Mantalini, evidently    pouting    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [152]                   --- and *returned* it into her      hand    , the light from a neighbouring ---         
    ## [153]                     --- about the corners of his     mouth    , *returned* no show of answer ---          
    ## [154]             --- *returned* Mr Folair, waving his      hand     in deprecation of any further ---          
    ## [155]            --- _b_ _b_ *returned* the tragedian,    scowling   upwards _b_ _b_ _b_ _b_ ---                
    ## [156]          --- _b_ *returned* Squeers, rubbing his     knees     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [157]            --- *returned* the other, nodding his      head     gravely _b_ _b_ _b_ _b_ ---                
    ## [158]         --- *returned* Sir Mulberry, tossing his      arm      restlessly upon the coverlet. _b_ ---      
    ## [159]       --- *returned* his Mentor, disengaging his      arm      _b_ _b_ _b_ _b_ _b_ ---                    
    ## [160]                --- prophecy, so agreeable to his      ears    , Arthur *returned* no answer than ---      
    ## [161]          --- _b_ *returned* Squeers, rubbing his     knees     still harder _b_ _b_ _b_ ---               
    ## [162]             --- answer was *returned*. Newman 's      arm      could no longer be restrained; ---         
    ## [163]      --- *returned* brother Charles, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [164]               --- _b_ *returned* Tim, wiping his      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [165]         --- _b_ *returned* Nicholas, meeting his      eye      _b_ _b_ _b_ _b_ _b_ ---                    
    ## [166]            --- child *returned*, her light brown      hair     hanging loose about her neck, ---          
    ## [167]          --- *returned*, looking anxiously in my      face     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [168]            --- *returned* the child, kissing her     cheek     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [169]              --- _b_ *returned* Nell, drying her      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [170]            --- *returned* the child with tearful      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [171]            --- *returned* Mr Slum, elevating his      hand     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [172]             --- _b_ *returned* Dick, keeping his      eye      upon him, and waving the ---               
    ## [173]                  --- _b_ _b_ *returned* Kit, his      eyes     sparkling with delight _b_ _b_ ---         
    ## [174]        --- *returned* the gentleman, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [175]             --- found herself enveloped when she      woke    , *returned* to his seat, whence ---        
    ## [176]             --- messenger soon *returned* at the      head     of a long row of ---                       
    ## [177]          --- *returned* the child, with downcast      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [178]                --- shut it softly, *returned* on     tiptoe   , and said in a whisper ---                 
    ## [179]          --- _b_ *returned* Sampson, rubbing his     hands     feebly; you disturb our friends. ---       
    ## [180]         --- *returned* slowly, being pretty well    breathed   with his run _b_ _b_ ---                   
    ## [181]                --- he *returned*, bearing in his      hand     a lamp _b_ _b_ _b_ ---                     
    ## [182]                --- rose and *returned* home, and      went     to bed, murmuring to himself ---           
    ## [183]                --- and *returned* home, and went       to      bed, murmuring to himself _b_ ---          
    ## [184]                 --- *returned* home, and went to      bed     , murmuring to himself _b_ _b_ ---          
    ## [185]            --- *returned* the other, meeting his      eye      _b_ _b_ _b_ _b_ _b_ ---                    
    ## [186]               --- *returned* Mr Boffin, with his      hand     still to his chin _b_ ---                  
    ## [187]                     --- _b_ _b_ Lizzie shook her      head     again, and *returned*, with a ---          
    ## [188]      --- *returned* Lavinia, coolly, tossing her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [189]                --- _b_ _b_ *returned* Miss Wren,    snapping   her fingers in a volley ---                
    ## [190]           --- *returned* Miss Wren, snapping her    fingers    in a volley of impatient ---               
    ## [191]         --- _b_ *returned* Lizzie, releasing the      hand    , and laying her own lightly ---            
    ## [192]        --- _b_ *returned* Pleasant, dropping her      arms     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [193]             --- *returned* Bella, with a burning      face     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [194]         --- *returned* his sister, detaining his      hand     as he withdrew it _b_ ---                  
    ## [195]            --- *returned* Lizzie, with a burning      face     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [196]           --- *returned* Mrs Wilfer, turning her      eyes     upon her youngest born, with ---           
    ## [197]        --- _b_ *returned* Sophronia, shaking her      head    , and smiling her best smile ---            
    ## [198]            --- _b_ *returned* Bella, tossing her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [199]             --- _b_ *returned* Wegg, shaking his      head     at once observantly, thoughtfully, and --- 
    ## [200]               --- scene departed from before her      eyes    ; when it *returned*, she found ---         
    ## [201]        --- _b_ *returned* Bradley with quivering      lips     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [202]                    --- _b_ _b_ Again shaking her      head    , she *returned* _b_ _b_ _b_ ---            
    ## [203]                   --- _b_ _b_ _b_ he *returned*,   swallowing  a bit of the cottage ---                   
    ## [204]            --- _b_ *returned* Lavvy, folding her      arms     and leaning back in her ---                
    ## [205]            --- *returned* Mr Boffin, with folded     hands     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [206]             --- _b_ *returned* Wegg, shaking his      head     sagaciously, and bestowing a wooden ---    
    ## [207]          --- _b_ *returned* Bella, pretending to      pout     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [208]          --- *returned* the dressmaker, with her      eyes     upon her work _b_ _b_ ---                  
    ## [209]                       --- Lord bless my soul and      body     ! ' *returned* Mr Inspector _b_ ---        
    ## [210]         --- _b_ *returned* Bella, with quivering      lips     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [211]      --- *returned* the dress-maker, tossing her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [212]                --- his being *returned* upon the     hands     of the parish should be ---                
    ## [213]                          --- of a violent fit of     crying   . Under this impression he *returned* ---   
    ## [214]                 --- long, that Oliver raised his      head    , and *returned* his steady look. ---       
    ## [215]                    --- the girl *returned*, in a   breathless  state, to report that there ---            
    ## [216]                --- of ascertaining, with his own      eyes    , that Sikes had not *returned*, ---        
    ## [217]           --- *returned* Mrs. Maylie, laying her      hand     upon his shoulder _b_ _b_ ---              
    ## [218]       --- *returned* the robber, suppressing his     breath    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [219]              --- nearly an hour, *returned* with      eyes     swollen with weeping. All these ---        
    ## [220]                          --- _b_ The door of the      cell     opened, and the attendants *returned* ---  
    ## [221] --- innumerable difficulties, and *returned*, on      foot    , to his native place. _b_ ---              
    ## [222]           --- Pickwick *returned* by kissing his      hand     to the lady. _b_ _b_ ---                   
    ## [223]                      --- the fever left him, and consciousness *returned*, he awoke to find ---           
    ## [224]        --- him, and consciousness *returned*, he     awoke     to find himself rich and ---               
    ## [225]               --- and whispered something in his      ear     . To this, the magistrate *returned* ---    
    ## [226]              --- whence he shortly *returned* on     tiptoe   , and informed Mr. Perker and ---           
    ## [227]           --- which burst spontaneously from his      lips    , as he *returned* the fixed ---            
    ## [228]             --- message, the fat boy *returned*,   slumbering  as peaceably in his dickey, ---            
    ## [229]    --- concentrated expression *returned* to his    forehead  , he seemed to become conscious ---         
    ## [230]           --- *returned* Miss Pross, shaking her      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [231]       --- *returned* that gentleman, shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [232]           --- husband *returned* amicably to the     bosom     of Saint Antoine, while a ---              
    ## [233]         --- *returned* madame, with her extended      hand     in strong action _b_ _b_ ---               
    ## [234]           --- _b_ *returned* madame, lifting her    eyebrows   a little _b_ _b_ _b_ ---                   
    ## [235]             --- *returned* Mr. Lorry, drying his      eyes     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [236]          --- _b_ *returned* Carton, stamping his      foot     _b_ _b_ _b_ _b_ _b_ ---

``` r
# cried
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("cried"), context = 0)
y
```

    ## [  1]          --- that solitary friend upon my    bosom   , *cried* myself to sleep. Imperfect ---      
    ## [  2]           --- my bosom, *cried* myself to    sleep   . Imperfect as my understanding of ---        
    ## [  3]            --- up and smiling through her     tear    's, *cried* _b_ _b_ _b_ ---                  
    ## [  4]       --- was nursing stretched forth its     arms    and *cried* out to be ---                    
    ## [  5]        --- *cried* Charley with a heaving    heart    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [  6]       --- *cried* Charley. But Charley 's     face    fell in the height of ---                    
    ## [  7]                  --- worn out, and when I    awoke    I *cried* afresh to think ---                
    ## [  8]          --- *cried* my guardian with his     hand    in his pocket _b_ _b_ ---                    
    ## [  9]         --- *cried* the girl, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 10]        --- *cried* the girl, pressing her     hair    back with her hands _b_ ---                  
    ## [ 11]              --- otherwise at all. When I     went    to bed, I *cried*. I ---                     
    ## [ 12]                   --- at all. When I went      to     bed, I *cried*. I am ---                     
    ## [ 13]                   --- all. When I went to     bed    , I *cried*. I am bound ---                   
    ## [ 14]    --- *cried* Barnaby, glancing over his   shoulder  _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 15]         --- *cried* Miggs, with a flushed     face    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 16]        --- _b_ *cried* Miggs, rubbing her    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 17]       --- _b_ *cried* Miggs, clasping her    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 18]     --- *cried* Mr Tappertit, standing on    tiptoe  , as if by that means ---                     
    ## [ 19]      --- *cried* Mr Haredale, drawing his    breath   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 20]                --- _b_ *cried* John, in a    drowsy   reverie _b_ _b_ _b_ _b_ ---                  
    ## [ 21]       --- *cried* his father, raising his   eyelids   in a languishing surprise _b_ ---            
    ## [ 22]         --- *cried* Miggs, turning on the    tears    again, previous to quitting the ---          
    ## [ 23]   --- *cried*, endeavouring with both her    hands    to push him off _b_ ---                      
    ## [ 24] --- *cried* the locksmith with brightened     eyes   , and sturdy, honest voice _b_ ---            
    ## [ 25]       --- _b_ *cried* Mr Willet, suddenly   rousing   himself, and turning round _b_ ---           
    ## [ 26]              --- _b_ _b_ _b_ *cried* Joe,   snapping  his fingers. And so they ---                 
    ## [ 27]         --- _b_ *cried* Joe, snapping his   fingers  . And so they parted. _b_ ---                 
    ## [ 28]                 --- and *cried* as if her    heart    would break. And yet such ---                
    ## [ 29]                    --- or one held up his    finger   and *cried* _b_ _b_ _b_ ---                  
    ## [ 30]         --- _b_ he *cried* with sparkling     eyes    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 31]          --- oaths; then wiped his heated     face    upon his neckerchief, and *cried* ---        
    ## [ 32]               --- the portal with a surly     eye    , and *cried* _b_ _b_ _b_ ---                 
    ## [ 33]         --- *cried* Sir John, raising his   eyebrows  _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 34]       --- *cried* Mrs Varden, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 35]      --- _b_ *cried* Barnaby, rubbing his    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 36]           --- _b_ he *cried*, patting her     hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 37]        --- *cried* Gashford with a solemn     face    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 38]   --- _b_ *cried* Barnaby with glistening     eyes   , as he clutched his pole ---                 
    ## [ 39]             --- her hands, *cried* with a    drowsy   mingling of the sacred and ---               
    ## [ 40]     --- _b_ *cried* Gashford, raising his   eyebrows  with an exclamation of surprise ---          
    ## [ 41]        --- _b_ *cried* Hugh, stamping his     foot    upon the ground _b_ _b_ ---                  
    ## [ 42]           --- *cried* the man, laying his     hand    upon his horse 's bridle ---                 
    ## [ 43]       --- *cried* outright, and wrung his    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 44]      --- *cried* John, turning his rueful     eyes    on Mr Haredale, who had ---                  
    ## [ 45]             --- *cried*, as she wrung her    hands   , what would they do or ---                   
    ## [ 46]       --- face, and still, with quickened    breath   and lessening colour, *cried* firmly ---     
    ## [ 47]      --- *cried* Miss Miggs, clasping her    hands    distractedly _b_ _b_ _b_ _b_ ---             
    ## [ 48]        --- _b_ *cried* Miggs, folding her    hands    and looking upwards with a ---               
    ## [ 49]      --- *cried* the man, unclenching her    hands   , and pushing her roughly off, ---            
    ## [ 50]         --- _b_ she *cried*, clasping her    hands   , and looking upward _b_ _b_ ---              
    ## [ 51]           --- he *cried*, starting to his     feet    with a terrible scream _b_ ---               
    ## [ 52]       --- *cried* Hugh, raising his right     arm     aloft, and looking upward like ---           
    ## [ 53]           --- she *cried*, with her whole    heart    and soul in her earnest ---                  
    ## [ 54]           --- running into Mr Haredale 's     arms   , *cried* out _b_ _b_ _b_ ---                 
    ## [ 55]         --- smote his thigh, elevated his   eyebrows , opened his mouth, and *cried* ---           
    ## [ 56]     --- elevated his eyebrows, opened his    mouth   , and *cried* in a loud ---                   
    ## [ 57]               --- down the corners of her    mouth   , and *cried*, in an ascending ---            
    ## [ 58]     --- *cried*, abruptly pointing in his     face   , and stepping back _b_ _b_ ---               
    ## [ 59]      --- *cried* Peggotty, holding up her    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 60]    --- counterpane, and *cried* myself to    sleep   . _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 61]           --- *cried*, and wore myself to    sleep   , and awoke and *cried* again. ---            
    ## [ 62]             --- wore myself to sleep, and    awoke    and *cried* again. When I ---                
    ## [ 63]          --- *cried* my aunt, shaking her     head    and her fist at the ---                      
    ## [ 64]               --- have held him round the     neck    and *cried* _b_ _b_ _b_ ---                  
    ## [ 65]     --- *cried* Mr. Peggotty, rolling his     head    in an ecstasy at the ---                     
    ## [ 66]                --- she *cried*, as if her    heart    would break _b_ _b_ _b_ ---                  
    ## [ 67]        --- _b_ *cried* Agnes, putting her    hands    before her face, as her ---                  
    ## [ 68]    --- *cried* Miss Mowcher, wringing her    hands    impatiently, as she went to ---              
    ## [ 69]                --- _b_ When Dora hung her     head    and *cried*, and trembled, my ---            
    ## [ 70]        --- _b_ *cried* Uriah, shaking his     head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 71]            --- alone; and *cried* upon my   shoulder , and said I had been ---                     
    ## [ 72]       --- _b_ *cried* Emily, clasping her    hands    together _b_ _b_ _b_ _b_ ---                 
    ## [ 73]        --- she *cried*, with her clenched     hand   , quivering as if it only ---                 
    ## [ 74]          --- he *cried*, with a frightful     face    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 75]    --- _b_ *cried* Mr. Micawber, shedding    tears    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 76] --- she *cried*, bursting into passionate    tears    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 77]        --- she *cried*, tearing her black     hair    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 78]     --- _b_ *cried* Traddles, opening his     eyes    in his old way _b_ ---                       
    ## [ 79]       --- _b_ *cried* Walter, putting his     face    in at the door _b_ ---                       
    ## [ 80]           --- too, who *cried* herself to    sleep    so mournfully, had lost as ---               
    ## [ 81]              --- a bright colour, and her     eyes    sparkling joyfully: and *cried* _b_ ---      
    ## [ 82]       --- _b_ *cried* Susan, wringing her    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 83]      --- _b_ *cried* Walter, pressing the     hand    of John Carker the Junior ---                
    ## [ 84]          --- _b_ *cried* Florence, with a     face    of terror _b_ _b_ _b_ ---                    
    ## [ 85]        --- *cried* the Captain, putting a     hand    to each side of his ---                      
    ## [ 86]         --- *cried* Edith, with a burning     brow   , and the same bitter emphasis ---            
    ## [ 87]            --- _b_ _b_ _b_ *cried* Susan,  breathless _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 88]     --- _b_ *cried* Florence, winding her     arm     round her neck, and returning ---            
    ## [ 89]  --- _b_ *cried* Cleopatra, squeezing his     hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 90]        --- *cried* Mr Toots, whose tender    heart    was moved by the Captain ---                 
    ## [ 91]            --- and *cried*, and wrung her    hands   , and stood at a little ---                   
    ## [ 92]            --- dream, she *cried* out and    awoke   , she thought. A soft voice ---               
    ## [ 93]             --- _b_ *cried* Rob, with his     legs    trembling under him _b_ _b_ ---              
    ## [ 94]              --- _b_ *cried* the soft and    nimble   Carker, at her side in ---                   
    ## [ 95]         --- *cried* Rob, pushing away her     hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 96]       --- *cried* Mr Dombey, striking his     hand    upon the table _b_ _b_ ---                   
    ## [ 97]     --- _b_ *cried* Florence, putting her    hands    together, and speaking wildly _b_ ---        
    ## [ 98]                 --- The bald man with the    beard    observed it, and *cried* out. ---            
    ## [ 99]             --- _b_ _b_ she *cried*, with     eyes    that seemed to sparkle fire. ---             
    ## [100]      --- *cried* Florence, falling on her    bosom    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [101]  --- *cried* Mr. Grewgious, smoothing his     head    triumphantly _b_ _b_ _b_ _b_ ---             
    ## [102]         --- *cried* Joe, opening his blue     eyes    wide _b_ _b_ _b_ _b_ ---                     
    ## [103]             --- wall there, and leaned my   forehead  on it and *cried*. As ---                    
    ## [104]       --- *cried* Biddy, with an exultant     face    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [105]           --- soothing way, while with my     face    upon my sleeve I *cried* ---                 
    ## [106]       --- *cried*, getting up, putting my     arm     round her neck, and giving ---               
    ## [107]                 --- for holding on by the    elbows   - *cried* out exultingly _b_ _b_ ---         
    ## [108]             --- The old man, following my     eyes   , *cried* with great triumph _b_ ---          
    ## [109]            --- seeing in the gentleman 's     face    that Yes was wrong, *cried* ---              
    ## [110]    --- *cried* Mr. Bounderby, shaking his     head    with obstinate cunning _b_ _b_ ---           
    ## [111]     --- *cried* Mrs. Sparsit, nodding her     head    a great many times, as ---                   
    ## [112]    --- _b_ *cried* Bounderby, shaking his     head   , with a whistle _b_ _b_ ---                  
    ## [113]     --- *cried* Mrs. Pegler, clasping her    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [114]         --- She *cried*, with her clasped    hands    lifted above her head, that ---              
    ## [115]     --- *cried* the landlady, raising her     eyes    from her work, opening them ---              
    ## [116]       --- _b_ *cried* Lagnier, giving his     head    a twirl _b_ _b_ _b_ ---                      
    ## [117]   --- *cried* Little Dorrit, covering her    tears    with her hands _b_ _b_ ---                   
    ## [118]           --- _b_ _b_ _b_ *cried* Affery,    waking   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [119]       --- *cried* Mr Meagles, rubbing his    hands    with a relish _b_ _b_ ---                    
    ## [120] --- *cried* Mistress Affery, wringing her    hands    in this last uneasy dream ---                
    ## [121]               --- _b_ _b_ _b_ _b_ *cried*    Fanny    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [122]               --- _b_ _b_ _b_ _b_ *cried*    Fanny    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [123]          --- his shoulder, and raised her     arm     towards his neck; *cried* out ---            
    ## [124]            --- raised her arm towards his     neck   ; *cried* out _b_ _b_ _b_ ---                 
    ## [125]              --- and then, drawing a long    breath  , *cried* _b_ _b_ _b_ _b_ ---                 
    ## [126]               --- _b_ _b_ _b_ _b_ *cried*    Fanny   , affrighted and bursting into tears ---      
    ## [127]               --- _b_ _b_ _b_ _b_ *cried*    Fanny   , piteously _b_ _b_ _b_ _b_ ---               
    ## [128]     --- already occupied in soothing her;    Fanny   , who had *cried* out twice ---               
    ## [129]               --- _b_ _b_ _b_ _b_ *cried*    Fanny    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [130]             --- window, and fell upon her    bosom    and *cried* there. Fanny laughed ---         
    ## [131]          --- her bosom and *cried* there.    Fanny    laughed at first; but soon ---               
    ## [132]               --- _b_ _b_ _b_ _b_ *cried*    Fanny   , half tolerant and half impatient ---        
    ## [133]               --- _b_ _b_ _b_ _b_ *cried*    Fanny    with an air of resignation ---               
    ## [134]               --- _b_ _b_ _b_ _b_ *cried*    Fanny   . _b_ _b_ _b_ _b_ _b_ ---                     
    ## [135]      --- _b_ *cried* Pancks, grinding his    teeth    in remorse _b_ _b_ _b_ ---                   
    ## [136]                    --- _b_ _b_ _b_ _b_ He    roused   himself, and *cried* out. And ---            
    ## [137]         --- her apron, and trembling from     head    to foot, here *cried* out ---                
    ## [138]            --- and trembling from head to     foot   , here *cried* out _b_ _b_ ---                
    ## [139]           --- _b_ he *cried*, lifting his   eyebrows , folding his arms, and leaning ---           
    ## [140]    --- _b_ *cried* Affery, unstopping her    mouth    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [141]          --- _b_ *cried* Mr Meagles, more  breathless than before _b_ _b_ _b_ ---                  
    ## [142]         --- *cried* Mercy, holding up her    finger   archly _b_ _b_ _b_ _b_ ---                   
    ## [143]     --- *cried* Mr Pecksniff, smiting his   forehead  _b_ _b_ _b_ _b_ _b_ ---                      
    ## [144]     --- *cried* Tigg, gravely nodding his     head    as if some ground of ---                     
    ## [145]     --- _b_ _b_ *cried* Spottletoe, still   gasping   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [146]          --- *cried* Tom, screwing up his    mouth   , and nodding _b_ _b_ _b_ ---                 
    ## [147]         --- _b_ *cried* Tigg, kissing his     hand    again, and beginning to follow ---           
    ## [148]        --- *cried* Mr Tapley, shaking his     head    expressively enough, and looking (in ---     
    ## [149]      --- *cried* Mrs Todgers, raising her     eyes    and shaking her head _b_ ---                 
    ## [150]        --- _b_ *cried* Mr Pecksniff whose     eyes    had in the meantime wandered ---             
    ## [151]             --- words as pierced his very    heart   , the two Miss Pecksniffs *cried* ---         
    ## [152]     --- *cried* Mr Pecksniff, rubbing his     hair    up very stiff upon his ---                   
    ## [153]       --- palsied head, winked his watery     eyes   , and *cried* in his whistling ---            
    ## [154]  --- *cried* Mr Pecksniff, trembling from     head    to foot, and trying to ---                   
    ## [155]      --- _b_ *cried* Martin, clapping his     hand    upon his mouth _b_ _b_ ---                   
    ## [156]           --- _b_ _b_ *cried* the father,  breathing  on his cold hands, and ---                   
    ## [157]          --- and he *cried*, striking his     hand    passionately upon the table as ---           
    ## [158]    --- *cried* Mr Pecksniff, pressing his     hand   . And then he took a ---                      
    ## [159]            --- _b_ *cried* Martin, as his     eye     rested on a great plan ---                   
    ## [160]   --- _b_ *cried* Charity, with sparkling     eyes    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [161]        --- _b_ *cried* Merry, nodding her     head    and giggling very much _b_ ---               
    ## [162]     --- *cried* the secretary, laying his     hand   , with growing familiarity, upon the ---      
    ## [163]         --- _b_ *cried* Tigg, kissing his     hand    in honour of the sex ---                     
    ## [164]       --- *cried* Mr Bailey, squaring his     arms    with a sudden emotion _b_ ---                
    ## [165]       --- _b_ *cried* Jonas, stamping his     foot    upon the ground _b_ _b_ ---                  
    ## [166]         --- *cried* Mrs Gamp, raising her    hands    and turning up her eyes ---                  
    ## [167]    --- _b_ *cried* Mr Pecksniff, shedding    tears    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [168]      --- *cried* the tollman, folding his     arms   , and spreading his legs _b_ ---              
    ## [169]       --- _b_ *cried* Cherry, shaking her     head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [170]        --- _b_ *cried* Martin, waving his     hand    to two thin figures on ---                   
    ## [171]             --- easy ! when he folded his     arms    they *cried* with one accord, ---            
    ## [172]         --- _b_ *cried* Tom, slapping his     leg     to give the greater force ---                
    ## [173]        --- _b_ *cried* Jonas, shading his     eyes   , for the moment, from the ---                
    ## [174]        --- *cried* Jonas, throwing up his    hands    wildly _b_ _b_ _b_ _b_ ---                   
    ## [175]     --- *cried* Mr Pecksniff, shaking his     head    in pity _b_ _b_ _b_ ---                      
    ## [176]        --- _b_ *cried* Jonas, raising his     head   , and staring at her _b_ ---                  
    ## [177]      --- *cried* old Martin, clasping his    hands    and lifting up his eyes ---                  
    ## [178]        --- brandy bottle by mistake, went      to     sleep, woke, shivered, and *cried*, ---      
    ## [179]            --- bottle by mistake, went to    sleep   , woke, shivered, and *cried*, as ---         
    ## [180]            --- by mistake, went to sleep,     woke   , shivered, and *cried*, as their ---         
    ## [181]         --- mistake, went to sleep, woke,   shivered , and *cried*, as their feelings ---          
    ## [182]             --- *cried* the guard, on his     legs    in a minute, and running ---                 
    ## [183]   --- *cried* Nicholas, staggering to his     feet    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [184]      --- *cried* the figure, gnashing his    teeth   . _b_ _b_ _b_ _b_ _b_ ---                     
    ## [185]          --- _b_ he *cried*, covering his     face    with his cracked and horny ---               
    ## [186]        --- _b_ _b_ *cried* his companion,  shivering  _b_ _b_ _b_ _b_ _b_ ---                      
    ## [187]         --- _b_ _b_ *cried* Miss Squeers,    biting   her lips, and trembling with ---             
    ## [188]      --- *cried* Miss Squeers, biting her     lips   , and trembling with very jealousy ---        
    ## [189]    --- *cried* the sister, laying violent    hands    upon Mrs Kenwigs, and holding ---            
    ## [190]      --- *cried* Miss Knag, elevating her    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [191]              --- _b_ _b_ she *cried*, her    heart    swelling with anger _b_ _b_ ---              
    ## [192]    --- _b_ *cried* Nicholas, clasping her     hand    so tight in the tumult ---                   
    ## [193]        --- *cried* his wife, flinging her     arms    about him _b_ _b_ _b_ ---                    
    ## [194]     --- *cried* Mrs Crummles, raising her    hands    in astonishment _b_ _b_ _b_ ---              
    ## [195]    --- _b_ *cried* Newman, scratching his     head    with an air of great ---                     
    ## [196]       --- _b_ *cried* Newman, passing his    hands    hastily over the back and ---                
    ## [197]   --- _b_ *cried* Nicholas, clenching his     fist    and suddenly changing his tone ---           
    ## [198]  --- *cried* Mr Mantalini, displaying his    teeth    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [199]       --- _b_ *cried* Mr Mantalini, whose     face    lengthened considerably at this handsome --- 
    ## [200]    --- _b_ *cried* Nicholas, grasping his     hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [201]                 --- face and black in the   forehead , coughed, *cried*, got better, went ---      
    ## [202]     --- *cried* Mr Mantalini, turning his     head    towards his wife _b_ _b_ ---                 
    ## [203]        --- *cried* John, laying his heavy     hand    upon his chest _b_ _b_ ---                   
    ## [204]      --- _b_ _b_ *cried* Smike, shrinking     back    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [205]       --- *cried* old Arthur, raising his    hands    and eyes in admiration _b_ ---               
    ## [206]       --- *cried* old Arthur, raising his    hands    with an imploring gesture, and ---           
    ## [207]     --- *cried* Arthur Gride, rubbing his    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [208]          --- _b_ _b_ *cried* the invalid,   gasping   and catching for breath _b_ ---              
    ## [209]     --- *cried* Arthur Gride, shading his     eyes    with his hand _b_ _b_ ---                    
    ## [210]       --- _b_ *cried* Arthur, rubbing his    hands    and affecting to laugh _b_ ---               
    ## [211]       --- _b_ *cried* Kate, with flashing     eyes    and the red blood mantling ---               
    ## [212]     --- *cried* Nicholas, rising from his     knee    and confronting them, but still ---          
    ## [213]         --- *cried* Ralph, foaming at the    mouth    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [214]          --- _b_ she *cried*, folding her     arms    and wagging her head _b_ ---                 
    ## [215]       --- _b_ *cried* Newman, standing on    tiptoe   to look over Tim 's ---                      
    ## [216]              --- _b_ _b_ *cried* the poor     body    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [217]     --- *cried* Mr Swiveller, tapping his     nose    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [218]       --- _b_ *cried* Nelly, clasping her     hand    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [219]         --- *cried* the old man, suddenly   rousing   himself from his state of ---                
    ## [220]                --- The baby in the cradle     woke    up and *cried*; the boy ---                  
    ## [221]               --- baby in the cradle woke      up     and *cried*; the boy in ---                  
    ## [222]            --- gently as they shook their    heads   , and others *cried* to the ---               
    ## [223]             --- *cried* Kit with a rueful     face    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [224]               --- treading on his wife 's     toes    to see whether she *cried* ---               
    ## [225]                --- her, tapped her on the     neck   , and *cried* playfully _b_ _b_ ---           
    ## [226]    --- *cried* the governess, raising her     eyes    to the sky _b_ _b_ ---                       
    ## [227]          --- hard blows with her clenched     hand   . The victim *cried*, but in ---              
    ## [228]       --- Little Jacob applauded till his    hands    were sore; Kit *cried* 'an-kor' ---          
    ## [229]        --- _b_ *cried* Quilp, nodding his     head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [230]      --- _b_ *cried* Quilp, extending his     arms    as if about to embrace ---                   
    ## [231]              --- _b_ *cried* Brass with a    sneeze   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [232]     --- *cried* Mr Swiveller, raising his     eyes    to the ceiling _b_ _b_ ---                   
    ## [233]            --- the desk with her clenched     fist   , and *cried* _b_ _b_ _b_ ---                 
    ## [234]       --- _b_ *cried* Sampson, laying his     hand    on one shoulder, while Mr ---                
    ## [235]       --- _b_ *cried* Kit, trembling from     head    to foot _b_ _b_ _b_ ---                      
    ## [236]     --- _b_ *cried* Sampson, clasping his    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [237]          --- _b_ *cried* Kit, raising his     eyes    and looking imploringly about him ---        
    ## [238]        --- *cried* the dwarf, rubbing his    hands    violently _b_ _b_ _b_ _b_ ---                
    ## [239]        --- _b_ *cried* Brass, shaking his     head    and frowning heavily _b_ _b_ ---             
    ## [240]        --- _b_ *cried* Brass, nodding his     head    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [241]        --- The Marchioness only shook her     head    mournfully, and *cried* again; whereupon --- 
    ## [242]     --- *cried* the dwarf, stretching his     neck    to obtain a better view ---                  
    ## [243]      --- _b_ *cried* Barbara. And Barbara    pouted   -- not sulkily, or in ---                    
    ## [244]           --- he *cried*, stooping on one     knee    and catching at his hand ---                 
    ## [245]             --- laughed at this, and then    pouted   and half *cried* _b_ _b_ ---                 
    ## [246]           --- *cried* Mr Boffin, with his     eyes    wide open _b_ _b_ _b_ ---                    
    ## [247]     --- *cried* Miss Podsnap, putting her   fingers   in her ears _b_ _b_ ---                      
    ## [248]              --- close, Yard arm and yard     arm     she lies; Again, *cried* I, ---              
    ## [249]        --- *cried*, poor thing, using her     hair    for a pocket-handkerchief _b_ _b_ ---        
    ## [250]      --- *cried* Fledgeby, with a mocking     lip     _b_ _b_ _b_ _b_ _b_ ---                      
    ## [251]       --- *cried* Miss Jenny, putting her     face    close to the old man ---                     
    ## [252]               --- seen sick Johnny in her     arms   , would they have *cried* for ---             
    ## [253]         --- tears, and stretching out her     arms   , *cried* _b_ _b_ _b_ _b_ ---                 
    ## [254]           --- she rocked herself upon her    breast  , and *cried*, and sobbed, and ---            
    ## [255]         --- *cried* Bella with a flashing     face    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [256]        --- *cried* Mr Riderhood, with his    hands    to his mouth. _b_ _b_ ---                    
    ## [257]   --- _b_ *cried* Georgiana, wringing her    hands    as she ran up to ---                         
    ## [258]                    --- _b_ As Pa bent his     head   , she *cried* over him a ---                  
    ## [259]         --- _b_ *cried* Bella, laying her     hand    upon his lips, with a ---                    
    ## [260]        --- *cried* Mr Boffin, shaking his     head    with an admiring air _b_ ---                 
    ## [261]       --- _b_ *cried* Bella, covering her     face    with her hands _b_ _b_ ---                   
    ## [262]               --- _b_ _b_ _b_ _b_ *cried*     Fang    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [263]            --- _b_ *cried* the new comer,  breathless with haste. _b_ _b_ _b_ ---                  
    ## [264]     --- *cried*, jumping fiercely up: her     face    flushed, and her eyes starting ---           
    ## [265]                 --- _b_ _b_ _b_ *cried* a  tremulous  voice in the rear _b_ ---                    
    ## [266]    --- _b_ *cried* Brittles, applying one     hand    to the side of his ---                       
    ## [267]           --- _b_ _b_ *cried* Oliver, his     face    brightening with pleasure _b_ _b_ ---        
    ## [268]           --- *cried* the man, fixing his     eyes    on Oliver, and suddenly recoiling ---        
    ## [269]  --- he *cried* impatiently, stamping his     foot    upon the ground _b_ _b_ ---                  
    ## [270]          --- *cried* Fagin, holding up is    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [271]    --- *cried* Fagin, extending his right     hand   , and turning to Mr. Bolter ---               
    ## [272]          --- *cried* the Jew, bending his     eyes    upon his pupil _b_ _b_ ---                   
    ## [273]        --- _b_ *cried* Nancy stamping her     foot    upon the ground _b_ _b_ ---                  
    ## [274]          --- *cried* Noah, curling up his     nose    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [275]              --- _b_ *cried* the Jew, his     eyes    flashing with rage _b_ _b_ ---               
    ## [276]  --- *cried* Oliver, eagerly clasping the     hand    of Rose, and pointing out ---                
    ## [277]      --- _b_ *cried* Oliver, throwing his     arms    about her neck _b_ _b_ ---                   
    ## [278]      --- Smorltork 's praise, shook their    heads    sagely, and unanimously *cried* _b_ ---      
    ## [279]       --- _b_ *cried* Mr. Pickwick, quite unconscious that there was anything the ---              
    ## [280]           --- _b_ *cried* Bob, wiping the    tears    out of his eyes, with ---                    
    ## [281]         --- _b_ *cried* Wardle, with open     arms    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [282]           --- words, he stretched out his     hand    again, hurriedly, and *cried* _b_ ---        
    ## [283]        --- *cried* Mr. Lorry, rubbing his     chin   , and looking at his visitor ---              
    ## [284]         --- _b_ *cried* she, wringing her    hands    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [285]              --- _b_ _b_ *cried* the same   scowling  red-cap _b_ _b_ _b_ _b_ ---                  
    ## [286]            --- _b_ _b_ *cried* Mr. Lorry,  breathless and confused _b_ _b_ _b_ ---                 
    ## [287]     --- *cried* Carton, striking his open     hand    on the table, as a ---                       
    ## [288]      --- *cried* Miss Pross, still wildly    crying   _b_ _b_ _b_ _b_ _b_ ---

``` r
# rejoined
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("rejoined"), context = 0)
y
```

    ## [ 1]   --- _b_ he *rejoined*, with widely-opened    eyes   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 2]    --- *rejoined*, endeavouring to draw her    arm    through his _b_ _b_ _b_ ---                 
    ## [ 3]            --- impulse, and with a swelling   breast  *rejoined* _b_ _b_ _b_ _b_ ---              
    ## [ 4]      --- *rejoined* his father, turning his    face   lazily towards him, and cracking ---        
    ## [ 5]           --- _b_ _b_ *rejoined* the other, breathing on his fictitious nose, and ---             
    ## [ 6]                     --- but he gave a great    gulp  , and mildly *rejoined* _b_ _b_ ---          
    ## [ 7] --- *rejoined* ecstatically, drawing up one    leg    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 8]          --- _b_ he *rejoined*, shaking his    head  , and looking very much dejected ---         
    ## [ 9]    --- _b_ *rejoined* Traddles, opening his    eyes   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [10]          --- and looking attentively in her    face  , *rejoined* _b_ _b_ _b_ _b_ ---             
    ## [11]     --- *rejoined* the Captain, shaking his    head   doubtfully, but regarding the desperate --- 
    ## [12]              --- _b_ Daniel Doyce shook his    head   gravely, and *rejoined* _b_ _b_ ---         
    ## [13]               --- _b_ Mr Dorrit knitted his   brows   and *rejoined*, after a moment ---          
    ## [14]        --- _b_ *rejoined* Doyce, laying his    hand   persuasively on his shoulder _b_ ---        
    ## [15]            --- he *rejoined*, with a slight   frown   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [16]   --- _b_ *rejoined* Squeers, thrusting his   hands   into his great-coat pockets _b_ ---         
    ## [17]             --- _b_ _b_ *rejoined* the boy,   crying  _b_ _b_ _b_ _b_ _b_ ---                     
    ## [18]    --- *rejoined* Mr Gregsbury, turning his    back   upon him _b_ _b_ _b_ ---                    
    ## [19]     --- _b_ *rejoined* Nicholas, laying his    hand   upon his shoulder _b_ _b_ ---               
    ## [20]      --- _b_ _b_ *rejoined* Nicholas, whose   breath  had been almost taken away ---              
    ## [21]     --- _b_ *rejoined* Nicholas, laying his    hand   upon the scrapbook _b_ _b_ ---              
    ## [22]  --- *rejoined* the manager, scratching his    head   with an air of some ---                     
    ## [23]    --- _b_ *rejoined* Nicholas, shaking his    head   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [24]   --- _b_ *rejoined* Mantalini, shaking his    head   again _b_ _b_ _b_ _b_ ---                   
    ## [25]     --- _b_ *rejoined* Nicholas, taking his    arm    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [26]       --- _b_ *rejoined* Ralph, folding his    arms   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [27]        --- _b_ _b_ *rejoined* Nicholas, his    lips   trembling as he formed the ---              
    ## [28]      --- _b_ *rejoined* Arthur, rubbing his   hands   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [29]     --- _b_ *rejoined* Ralph, elevating his  eyebrows and looking down upon his ---               
    ## [30]      --- _b_ *rejoined* Arthur, rubbing his   hands   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [31]      --- _b_ *rejoined* Gride, wringing his   hands   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [32]            --- *rejoined* that lady, with a    face   of unfathomable mystery _b_ _b_ ---         
    ## [33]          --- _b_ he *rejoined*, passing his    hand   across his brow _b_ _b_ ---                 
    ## [34] --- *rejoined* the schoolmaster shaking his    head   sorrowfully _b_ _b_ _b_ _b_ ---             
    ## [35]      --- he *rejoined*, raising his haggard    face   to hers, and regarding her ---              
    ## [36]          --- _b_ *rejoined* Brass, with his   teeth   chattering in his head _b_ ---              
    ## [37]      --- *rejoined* the child, clasping her   hands   earnestly _b_ _b_ _b_ _b_ ---               
    ## [38]      --- _b_ *rejoined* Brass, applying his    eye    to the other sleeve, and ---                
    ## [39]    --- fellow-man and partner with doubting    eyes  , and then *rejoined* stiffly _b_ ---        
    ## [40]  --- *rejoined* Eugene, tapping his palsied    head   with the fire- shovel, as ---               
    ## [41]             --- _b_ *rejoined* the Jew; his    eyes   glistening, and every muscle in ---         
    ## [42]       --- *rejoined* the other, nodding his    head   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [43]        --- _b_ *rejoined* Fagin, laying his    hand   upon the lock _b_ _b_ ---                   
    ## [44]           --- Pickwick turned slowly on his    heel  , and *rejoined* his friends. _b_ ---        
    ## [45]     --- *rejoined* the cobbler, shaking his    head   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [46]              --- _b_ _b_ _b_ *rejoined* the  one-eyed man _b_ _b_ _b_ _b_ ---                     
    ## [47]         --- _b_ *rejoined* Pott, laying his    hand   on Mr. Pickwick 's knee, ---                
    ## [48]        --- _b_ *rejoined* Mary, shaking her    head   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [49]     --- _b_ *rejoined* Stryver, nodding his    head   in a smoothing and final ---

``` r
# glancing
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("glancing"), context = 0)
y
```

    ## [ 1]             --- the child, *glancing* at the    face   upon her bosom _b_ _b_ ---                
    ## [ 2]                      --- on each side of his    head  , almost without *glancing* at him ---     
    ## [ 3]            --- interest and attention on his    face  , and *glancing* significantly at the ---  
    ## [ 4]              --- _b_ *Glancing* at the angry    eyes   which now avoid him and ---               
    ## [ 5]                --- of his finger, while that    eye    is still *glancing* over the ---          
    ## [ 6]               --- to the Maypole pressed his   finger  on his lips, and *glancing* ---           
    ## [ 7]                --- pressed his finger on his    lips  , and *glancing* at the young ---          
    ## [ 8]       --- cried Barnaby, *glancing* over his  shoulder _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 9]     --- *glancing* downward at his favourite   limbs   _b_ _b_ _b_ _b_ _b_ ---                   
    ## [10]                      --- sound of a horse 's    feet  , and *glancing* out at window, ---        
    ## [11]              --- other, putting money in his    hand  , and *glancing* at him steadfastly. ' --- 
    ## [12]         --- second bell-handle on the right-    hand   doorpost. After *glancing* at herself --- 
    ## [13]           --- chair, and *glancing* over his  shoulder at the reflection of his ---              
    ## [14]                --- by thrusting him with his    foot  , when, *glancing* at his upturned ---     
    ## [15]         --- when, *glancing* at his upturned    face  , he arrested himself in the ---           
    ## [16]           --- Mr Willet, *glancing* over his  shoulder at the organ in question ---              
    ## [17]                      --- could he see in any    face  , on *glancing* quickly round, the ---     
    ## [18]        --- *glancing* with no very approving    eyes   at Barnaby as he spoke ---                
    ## [19]            --- Hugh, shaking back his ragged    hair   and *glancing* towards the door ---       
    ## [20]            --- and *glancing* at his stained   wrist   for an instant, wrapped it, ---           
    ## [21]               --- Minnie looking on, and her    eye    *glancing* on her sweetheart, who ---     
    ## [22]                   --- down her head, and her    face   was covered with blushes. *Glancing* ---  
    ## [23]                    --- on each of her little   knees  , and *glancing* shrewdly at me ---        
    ## [24]       --- creature, *glancing* sharply at my    face  , and then peeping round at ---            
    ## [25]           --- that went *glancing* round his    head   in all directions _b_ _b_ ---             
    ## [26]                     --- meet in front of his    chin  , and *glancing* at me sideways ---        
    ## [27]          --- Micawber gave Mrs. Micawber his    arm   , and *glancing* at the heap ---           
    ## [28]               --- said my aunt, knitting her   brows   thoughtfully, and *glancing* at Agnes --- 
    ## [29]                      --- Sophy, shut up in a    back   room, *glancing* down from her ---        
    ## [30]                        --- shut up in a back    room  , *glancing* down from her work ---        
    ## [31]               --- not help *glancing* at her    face   as they went along -- ---                 
    ## [32]           --- said Walter, *glancing* at her    foot   _b_ _b_ _b_ _b_ _b_ ---                   
    ## [33]                  --- knew that the child was   awake   by occasionally *glancing* at his ---     
    ## [34]        --- by occasionally *glancing* at his    eye   , where the bright fire was ---            
    ## [35]           --- table, holding Florence by the    hand  , and *glancing* timidly from the ---      
    ## [36]             --- then *glancing* at the clock    face  , leaning all askew, against the ---       
    ## [37]                    --- murmur of the town -- breathing sweet scents; *glancing* sometimes at --- 
    ## [38]                       --- with a bend of his    head  , the younger lady *glancing* at ---       
    ## [39]               --- *glancing* at him, met his    eyes   _b_ _b_ _b_ _b_ _b_ ---                   
    ## [40]           --- *glancing* round at the bright   faces  , thought what was there she ---           
    ## [41]                --- feeling here, or keep his    eyes   from *glancing* gloomily at Florence ---  
    ## [42]           --- _b_ *glancing* at the downcast    eyes   of Florence, and not attempting ---       
    ## [43]         --- she replied, *glancing* over her  shoulder as he slouched after us ---               
    ## [44]          --- said Biddy, *glancing* over her  shoulder again _b_ _b_ _b_ _b_ ---                 
    ## [45]     --- landlord, *glancing* at the bandaged    arm    under my coat _b_ _b_ ---                 
    ## [46]          --- Louisa, after *glancing* at her    face  . 'Not rebels, nor yet rascals. ---        
    ## [47]                     --- and looked up in his    face   as she said, after *glancing* ---         
    ## [48]           --- often, *glancing* at the quiet    face   that bent over the work ---               
    ## [49]      --- significantly *glancing* at her and  snorting at her -- which was ---                   
    ## [50]                    --- up and down stairs of    feet  , such a *glancing* of lights, ---         
    ## [51]            --- after *glancing* at the happy    face   of Mr Pinch, was seized ---               
    ## [52]         --- *glancing* at Martin 's handsome    face   _b_ _b_ _b_ _b_ _b_ ---                   
    ## [53]            --- he thought, *glancing* at the    face   of the unconscious Tom _b_ ---            
    ## [54]            --- Mr Pecksniff, sticking up his    hair   and *glancing* at his bust ---            
    ## [55]               --- hair and *glancing* at his    bust   by Spoker _b_ _b_ _b_ ---                 
    ## [56]           --- not often, *glancing* over his  shoulder _b_ _b_ _b_ _b_ _b_ ---                   
    ## [57]           --- *glancing* once at Mary, whose    face   was now buried in her ---                 
    ## [58]             --- had been *glancing* over the  shoulder of another, stepped back to ---           
    ## [59]              --- not looking directly in her    face  , but *glancing* at her, as ---            
    ## [60]              --- stopped, when he raised his    head  , and *glancing* through the window, ---   
    ## [61]           --- Mr Cheggs, *glancing* over his  shoulder _b_ _b_ _b_ _b_ _b_ ---                   
    ## [62]       --- *glancing* at her proceedings with    eyes   of modest but hungry admiration ---       
    ## [63]                    --- _b_ _b_ Kit shook his    head  , and *glancing* slyly at his ---          
    ## [64] --- schoolmaster, *glancing* upward into his    face   _b_ _b_ _b_ _b_ _b_ ---                   
    ## [65]             --- the boy, *glancing* from her    eyes   to the brazier, which had ---             
    ## [66]        --- Bella, *glancing* downward at the    feet   in question _b_ _b_ _b_ ---               
    ## [67]           --- _b_ said Monks, with quivering    lip   , and *glancing* over his shoulder ---     
    ## [68]             --- lip, and *glancing* over his  shoulder _b_ _b_ _b_ _b_ _b_ ---                   
    ## [69]       --- Pickwick, *glancing* at her pretty    face   _b_ _b_ _b_ _b_ _b_ ---                   
    ## [70]           --- the Marquis, *glancing* at his   hands   _b_ _b_ _b_ _b_ _b_ ---                   
    ## [71]             --- Stryver the portly, with his   hands   in his waistband, *glancing* round ---    
    ## [72]           --- _b_ _b_ Besides the *glancing*   tears   that shone among the smiles ---           
    ## [73]                --- _b_ _b_ *Glancing* at his   hands  , which were discoloured by his ---        
    ## [74]                --- _b_ _b_ *glancing* at his   hands   again _b_ _b_ _b_ _b_ ---                 
    ## [75]        --- Mr. Cruncher, *glancing* over his  shoulder _b_ _b_ _b_ _b_ _b_ ---

``` r
# resting
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("resting"), context = 0)
y
```

    ## [  1]                     --- _b_ The old man 's     eye     *resting* on the empty bottle, ---          
    ## [  2]             --- his pipe supported in that     hand   , while his other hand, *resting* ---        
    ## [  3]             --- that hand, while his other     hand   , *resting* on his left leg, ---             
    ## [  4]            --- hand, *resting* on his left     leg    , squares his left elbow in ---              
    ## [  5]             --- a little forward, with one     arm     akimbo and the other *resting* ---          
    ## [  6]             --- the other *resting* on his     leg    , looking in a brown study ---               
    ## [  7]             --- his elbow on the cushioned     arm     and his forehead *resting* on ---           
    ## [  8]              --- the cushioned arm and his   forehead  *resting* on his hand; some ---             
    ## [  9]          --- his forehead *resting* on his     hand   ; some of those who were ---                 
    ## [ 10]                 --- the open letter in one     hand    and *resting* the broad knuckles ---        
    ## [ 11]           --- hand and *resting* the broad   knuckles  of the other on his ---                     
    ## [ 12]           --- the table, and *resting* his     head    upon his hand, began. He ---                
    ## [ 13]            --- *resting* his head upon his     hand   , began. He had not read ---                 
    ## [ 14]              --- *resting* one of his high  shoulders  against it and covertly rubbing ---         
    ## [ 15]               --- feel her *resting* on my     arm    , that the stained house-fronts put ---      
    ## [ 16]             --- younger still sat with his     head    *resting* on his hands, in ---              
    ## [ 17]             --- hard by, and *resting* his     chin    upon his hand, gazed upon ---               
    ## [ 18]            --- *resting* his chin upon his     hand   , gazed upon its rough and ---               
    ## [ 19]   --- said Barnaby, *resting* with crossed     arms    on his spade, and looking ---               
    ## [ 20]              --- on the bannister, and his    cheek    *resting* on his hand, with ---             
    ## [ 21]             --- his cheek *resting* on his     hand   , with his usual crafty aspect. ---          
    ## [ 22]            --- rolled lazily over upon his    breast  , and *resting* his chin upon ---            
    ## [ 23]          --- his breast, and *resting* his     chin    upon his hand in imitation ---              
    ## [ 24]            --- *resting* his chin upon his     hand    in imitation of the attitude ---            
    ## [ 25]        --- his bedstead: and *resting* his    elbows   on his knees, and his ---                   
    ## [ 26]           --- fleeting glimpse of the dark   eyelash  , almost *resting* on her flushed ---        
    ## [ 27]        --- almost *resting* on her flushed    cheek   , and of the downcast sparkling ---          
    ## [ 28]                --- I could not restrain my     eye     from *resting* for an instant ---           
    ## [ 29]                --- that I sat *resting* my     head    upon my hand, when the ---                  
    ## [ 30]              --- *resting* my head upon my     hand   , when the letter was half ---               
    ## [ 31] --- chimney-piece; and, *resting* her left    elbow    on her right arm, and ---                   
    ## [ 32]               --- the table; and, with his     chin    *resting* on one hand, tracked ---          
    ## [ 33]              --- his chin *resting* on one     hand   , tracked his course upon it ---             
    ## [ 34]                --- her arms crossed on her    breast  , and *resting* on each other, ---           
    ## [ 35]            --- his skeleton hands over his    mouth   , and the other *resting* on ---             
    ## [ 36]                     --- to meet my aunt 's     eyes   , which were *resting* on my ---             
    ## [ 37]             --- which were *resting* on my     face   . There was an anxious expression ---        
    ## [ 38]      --- which he delighted, *resting* his     head    calmly on his hand. That, ---               
    ## [ 39]               --- first moment of her dark     eyes    *resting* on me, I saw ---                  
    ## [ 40]                --- mine, - when I found my     eyes    *resting* on a countenance that ---         
    ## [ 41]             --- he sat down, *resting* his     head    upon one hand, and read ---                 
    ## [ 42]            --- *resting* his head upon one     hand   , and read it through. _b_ ---               
    ## [ 43]                 --- much; and sat with his     chin    *resting* on his hand, still ---            
    ## [ 44]              --- his chin *resting* on his     hand   , still cogitating and looking for ---       
    ## [ 45]                  --- of the fire, with his     hand    *resting* on his back, as ---               
    ## [ 46]        --- these things, and *resting* his     head    upon his arm, Perch the ---                 
    ## [ 47]            --- *resting* his head upon his     arm    , Perch the messenger, descending from ---   
    ## [ 48]          --- his pillow, and *resting* his     chin    wistfully on his folded hands. ---          
    ## [ 49]           --- her chamber window, with her     face    *resting* on her hand, sat ---              
    ## [ 50]              --- her face *resting* on her     hand   , sat looking out, and hardly ---            
    ## [ 51]                   --- _b_ _b_ She drew the     hand    which had been *resting* on ---             
    ## [ 52]              --- had been *resting* on his   shoulder , round his neck, and answered, ---          
    ## [ 53]        --- opposite the house; raising her     head    after *resting* it for a ---                
    ## [ 54]               --- The old woman leaned her    elbows   on the table, and *resting* ---             
    ## [ 55]           --- the table, and *resting* her     face    upon her two hands, made ---                
    ## [ 56]             --- made the inquiry, with his     chin    *resting* on his hand; and ---              
    ## [ 57]              --- his chin *resting* on his     hand   ; and at the same time ---                   
    ## [ 58]               --- yet. And again, with his     chin    *resting* on his hand, he ---               
    ## [ 59]              --- his chin *resting* on his     hand   , he leered at the picture ---               
    ## [ 60]                 --- the pillow. One of his     arms   , *resting* outside the bed, was ---         
    ## [ 61]                 --- but she stood with her     hand    *resting* on the chair, and ---             
    ## [ 62]            --- light, was *resting* on her     hand   . Florence advancing, doubtfully, all at --- 
    ## [ 63]                --- the wall, and, with his     chin    *resting* on them, watches. He ---          
    ## [ 64]        --- appearance, and that her weazen     chin    is *resting* on her hands, ---              
    ## [ 65]              --- the squalid bed, with his     head    *resting* on his left hand ---              
    ## [ 66]          --- before them; now, *resting* a     knee    or a shoulder; now, easing ---              
    ## [ 67]                  --- *resting* a knee or a   shoulder ; now, easing a belt or ---                  
    ## [ 68]               --- In an arm-chair, with an    elbow    *resting* on the table and ---              
    ## [ 69]              --- crossed on her stick, her     chin    *resting* on them, and her ---              
    ## [ 70]             --- *resting* on them, and her     eyes    on the fire. Sitting near ---               
    ## [ 71]        --- himself, and, *resting* with an    elbow    on one knee, and his ---                    
    ## [ 72]                  --- with her hands at her     ears   , and her head *resting* on ---              
    ## [ 73]                   --- at her ears, and her     head    *resting* on them. Presently, she ---       
    ## [ 74]         --- figure easily *resting* on the     arm     supported by that knee. They ---            
    ## [ 75]             --- and Little Dorrit was soon     fast    asleep with her head *resting* ---          
    ## [ 76]            --- Little Dorrit was soon fast    asleep   with her head *resting* on ---              
    ## [ 77]              --- soon fast asleep with her     head    *resting* on that sealed book ---           
    ## [ 78]          --- steamed out. Mrs Clennam, her     chin    *resting* on her hand, followed ---         
    ## [ 79]              --- her chin *resting* on her     hand   , followed him with attentive and ---        
    ## [ 80]         --- leaning back and *resting* her    elbow    on it negligently, fanned herself ---       
    ## [ 81] --- particularly *resting* upon Clennam 's     face    or any other. _b_ _b_ ---                   
    ## [ 82]           --- Mrs General, with her gloved    hands    *resting* on one another in ---             
    ## [ 83]            --- floor, drooped over it; the     arms    easily and peacefully *resting* on ---      
    ## [ 84]         --- *resting* on the coverlet; the     face    bowed down, so that the ---                 
    ## [ 85]                  --- upon her bosom, put a     hand    upon his head, and *resting* ---            
    ## [ 86]                    --- put a hand upon his     head   , and *resting* her cheek upon ---           
    ## [ 87]            --- his head, and *resting* her    cheek    upon that hand, nursed him ---              
    ## [ 88]          --- *resting* her cheek upon that     hand   , nursed him as lovingly, and ---            
    ## [ 89]           --- faint vibration of their own   tongues  , but newly *resting* from the ---           
    ## [ 90]      --- towards Martin, and *resting* his     chin    on the top of his ---                       
    ## [ 91]                 --- Mark, and sat with his     chin    *resting* on the back rail ---              
    ## [ 92]              --- his chin *resting* on the     back    rail of their little bench, ---             
    ## [ 93]        --- against the sash, *resting* his     head    upon his arms _b_ _b_ ---                   
    ## [ 94]            --- *resting* his head upon his     arms    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 95]          --- the street, and *resting* his     head    upon his arms _b_ _b_ ---                   
    ## [ 96]            --- *resting* his head upon his     arms    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 97]            --- his bottle *resting* on his     knee   , and gripped as tightly in ---              
    ## [ 98]            --- *resting* her saucer on the     palm    of her outspread hand, and ---              
    ## [ 99]                --- across a chair with his     arms    *resting* on the back; eating ---           
    ## [100]              --- his arms *resting* on the     back   ; eating nuts, and throwing the ---          
    ## [101]                  --- The old man, with his     chin    *resting* on his hand, paced ---            
    ## [102]              --- his chin *resting* on his     hand   , paced the room twice or ---                
    ## [103]          --- the handle, and *resting* his     chin    on them again. All his ---                  
    ## [104]                --- short to admit of their     feet    *resting* upon anything as they ---         
    ## [105]         --- than before; and *resting* her    elbow    on the table, covered her ---               
    ## [106]        --- said nothing, and *resting* his     head    upon his hand, subsided into ---            
    ## [107]            --- *resting* his head upon his     hand   , subsided into a kind of ---                
    ## [108]                 --- of the coach, with his     head    *resting* on his hands, and ---             
    ## [109]                --- He smiled and shook his     head   , and *resting* his chin upon ---            
    ## [110]            --- his head, and *resting* his     chin    upon his hand, fell a ---                   
    ## [111]            --- *resting* his chin upon his     hand   , fell a musing, and smiled ---              
    ## [112]                --- the desk, and his sharp cheek-bones *resting* on his hands, it ---              
    ## [113]             --- him, and remained with his     head    *resting* on one hand, and ---              
    ## [114]              --- his head *resting* on one     hand   , and his eyes fixed moodily ---             
    ## [115]              --- continued to sit with his     head    upon his hand; not *resting* ---            
    ## [116]                 --- with his head upon his     hand   ; not *resting* nor thinking, but ---        
    ## [117]           --- *resting* himself now on one     leg     and now on the other ---                    
    ## [118]         --- carelessly over the other, his     chin    *resting* on the palm of ---                
    ## [119]              --- his chin *resting* on the     palm    of his hand, his head ---                   
    ## [120]         --- upon two chairs, *resting* his     head    on his hand, and the ---                    
    ## [121]              --- *resting* his head on his     hand   , and the squinting man reposed ---          
    ## [122]            --- bloom, and *resting* in the    sleep    that knows no waking. _b_ ---               
    ## [123]    --- the furnace-door, and *resting* his     chin    upon his hands, watched the ---             
    ## [124]            --- *resting* his chin upon his    hands   , watched the flame as it ---                
    ## [125]             --- on the window-sill and his     head    *resting* on both his hands, ---            
    ## [126]             --- head *resting* on both his    hands   , that what between this attitude ---        
    ## [127]                --- stood afar off with his     head    *resting* on the arm by ---                 
    ## [128]              --- his head *resting* on the     arm     by which he held to ---                     
    ## [129]    --- Wegg delicately hinted, *resting* a     hand    on his stall, and bending ---               
    ## [130]      --- leaning back, attentive, with her    elbows   *resting* on the elbows of ---              
    ## [131]            --- her elbows *resting* on the    elbows   of her chair, and her ---                   
    ## [132]     --- the little creature, *resting* one     arm     upon the elbow of her ---                   
    ## [133]             --- *resting* one arm upon the    elbow    of her chair, *resting* her ---             
    ## [134]            --- of her chair, *resting* her     chin    upon that hand, and looking ---             
    ## [135]           --- *resting* her chin upon that     hand   , and looking vacantly before her ---        
    ## [136]           --- sparkled down among the fair     hair    *resting* on the dark hair; ---             
    ## [137]             --- hair *resting* on the dark     hair   ; and if it were not ---                     
    ## [138]              --- his stout stick, with his     chin    *resting* upon them, and with ---           
    ## [139]                  --- upon a chair with her    hands    *resting* on the back of ---                
    ## [140]             --- her hands *resting* on the     back    of it, and had never ---                    
    ## [141]        --- visitor sat down, *resting* his     chin    on his hand, with his ---                   
    ## [142]              --- *resting* his chin on his     hand   , with his eyes on the ---                   
    ## [143]               --- *resting* on his wife 's     arm    , and leaning heavily upon a ---             
    ## [144]                   --- in the bed, with his     head    *resting* on his trembling arm, ---         
    ## [145]        --- head *resting* on his trembling     arm    , he looked anxiously around _b_ ---         
    ## [146]           --- and, once more *resting* her    elbow    on the table, thought of ---                
    ## [147]                --- folded on them, and his     chin    *resting* on his thumbs, fixed ---          
    ## [148]              --- his chin *resting* on his    thumbs  , fixed his eyes, abstractedly, on ---       
    ## [149]              --- of living light, with one     hand    *resting* on the wooden slab ---            
    ## [150]  --- exclaimed Mr. Pickwick, *resting* his     chin    upon his hands _b_ _b_ ---                  
    ## [151]            --- *resting* his chin upon his    hands    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [152]              --- Here Mr. Jackson cast his     eye     on the parchment; and, *resting* ---        
    ## [153]      --- the parchment; and, *resting* his    hands    on the table, and looking ---               
    ## [154]             --- *resting* his hands on his     hips   , inspected him narrowly; while two ---      
    ## [155]             --- sat Mr. Alfred Jingle; his     head    *resting* on his hands, his ---             
    ## [156]            --- *resting* on his hands, his     eyes    fixed upon the fire, and ---                
    ## [157]  --- paragraphs; while Sam, sitting cross-    legged   on a chair and *resting* ---                
    ## [158]              --- a chair and *resting* his     arms    on the top rail, regarded ---               
    ## [159]           --- interest; and stood with his    hands    *resting* on the slab of ---                
    ## [160]               --- side, she leaning on his   shoulder , and he *resting* his arm ---               
    ## [161]         --- shoulder, and he *resting* his     arm     on the back of her ---                      
    ## [162]               --- *resting* his arm on the     back    of her chair, it was ---                    
    ## [163]          --- old pallet-bed, each with his     chin    *resting* on his hand, and ---              
    ## [164]              --- his chin *resting* on his     hand   , and his eyes intent on ---                 
    ## [165]            --- at the table, *resting* his   forehead  on his hands. The Spy ---

``` r
# pointing
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("pointing"), context = 0)
y
```

    ## [ 1]                --- large hats tied under the   chin  , for June; smooth-legged noblemen *pointing* --- 
    ## [ 2]                   --- out of window ? Is the   hand   not always *pointing* there ? So ---             
    ## [ 3]    --- most precious heirlooms, thousands of  fingers *pointing* at him, thousands of ---              
    ## [ 4]          --- *pointing* at him, thousands of   faces  sneering at him. But if ---                      
    ## [ 5] --- distinctly. Slightly *pointing* over his shoulder, Solomon elevated his eyebrows and ---           
    ## [ 6]    --- *pointing* towards Barnaby, shook his   head   and frowned _b_ _b_ _b_ ---                      
    ## [ 7]         --- serjeant, clapping Dennis on the   back  , and *pointing* after the officer ---            
    ## [ 8]        --- cried, abruptly *pointing* in his   face  , and stepping back _b_ _b_ ---                   
    ## [ 9]        --- secret opportunity of shaking his   head   darkly at me, and *pointing* ---                 
    ## [10]    --- angrily retorted, *pointing* his lean  finger  at me, against whom all ---                      
    ## [11]        --- when, *pointing* with her dimpled  finger , she looks into her nurse ---                    
    ## [12]                     --- he could yet see the  finger  *pointing* before him, and thought ---           
    ## [13]        --- she answered, *pointing* with her   hand   _b_ _b_ _b_ _b_ _b_ ---                          
    ## [14]       --- said, *pointing* with an imperious   hand   towards the door _b_ _b_ ---                     
    ## [15]         --- earnestly, and with a *pointing*   hand   towards them. That one seemed ---                
    ## [16]            --- *pointing* to Florence with a   hand   that slightly trembled for the ---               
    ## [17]              --- to reply, she stretched her    arm   out, *pointing* to the chair. ---                
    ## [18]              --- *pointing* to the chair. He    bit   his lip, frowned, laughed, and ---               
    ## [19]         --- said the Captain, *pointing* his   thumb  over his shoulder _b_ _b_ ---                    
    ## [20]            --- *pointing* his thumb over his shoulder _b_ _b_ _b_ _b_ _b_ ---                          
    ## [21]                 --- and *pointing* me out at    arm   's length _b_ _b_ _b_ ---                        
    ## [22]             --- Mrs Clennam, with her unbent  finger  again *pointing* to the door ---                 
    ## [23]          --- Saint Bernard, when the warning   arms   seemed to be all *pointing* ---                  
    ## [24]                   --- a confused bend of his   head  , after thus *pointing* him out ---               
    ## [25]         --- himself, and *pointing* with his  finger  to the door, informed him ---                    
    ## [26]                --- _b_ he said, fetching his  breath  at every word, and *pointing* ---                
    ## [27]       --- word, and *pointing* his trembling  finger  towards Lewsome _b_ _b_ _b_ ---                  
    ## [28]           --- other reply than thrusting his  tongue  into his cheek, and *pointing* ---               
    ## [29]            --- thrusting his tongue into his   cheek , and *pointing* the feather of ---               
    ## [30]           --- _b_ replied Sir Mulberry Hawk,  biting  his lip, and *pointing* to ---                   
    ## [31]            --- Sir Mulberry Hawk, biting his    lip  , and *pointing* to the door ---                  
    ## [32]                 --- _b_ said Ralph, 'by your  tongue ; and HIM' (*pointing* to Smike ---               
    ## [33]           --- Ralph, *pointing* out with his  finger  the man whom he addressed ---                    
    ## [34]          --- said Ralph, *pointing* with his  finger  towards the recess already mentioned ---         
    ## [35]           --- said Quilp *pointing* over his shoulder with his thumb _b_ _b_ ---                       
    ## [36]             --- or thrice: *pointing* to the  finger  and the needle at the ---                        
    ## [37]        --- man, *pointing* downward with his  finger . _b_ _b_ _b_ _b_ _b_ ---                         
    ## [38]         --- the house, *pointing* her little  finger  _b_ _b_ _b_ _b_ _b_ ---                          
    ## [39]       --- *pointing* backward over his right shoulder with his right thumb _b_ ---                     
    ## [40]    --- he expressively jerked his *pointing*  finger  in the direction the boat ---                    
    ## [41]       --- dropped, catching Potterson by the shoulder, and *pointing* to the half-door. ---            
    ## [42]       --- where the children with *pointing*   arms   had seemed to devote him ---                     
    ## [43]       --- cried Oliver, eagerly clasping the   hand   of Rose, and *pointing* out ---                  
    ## [44]           --- replied by *pointing* with his   thumb  over his shoulder, and Mr. ---                   
    ## [45]                 --- putting the reins in his   hand  , and *pointing* up a lane ---                    
    ## [46]             --- catching Mr. Pickwick by the    arm  , and *pointing* towards the stranger ---         
    ## [47]              --- _b_ _b_ *pointing* with his   hand   _b_ _b_ _b_ _b_ _b_ ---                          
    ## [48]         --- miserable creature fell upon his shoulder, sobbing and crying, and *pointing* ---          
    ## [49]           --- upon his shoulder, sobbing and  crying , and *pointing* to the fountain, ---             
    ## [50]                    --- the door, and put her    arm   on his, in *pointing* out ---

``` r
# lifted
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("lifted"), context = 0)
y
```

    ## [  1]             --- down. I *lifted* the heavy    head   , put the long dank hair ---               
    ## [  2]                  --- when I *lifted* up my    eyes    and saw my guardian standing ---          
    ## [  3]             --- smiled and *lifted* up his     arm    to touch him as he ---                    
    ## [  4]           --- from the witless, when their   hearts   are *lifted* up they know ---             
    ## [  5]           --- Gabriel *lifted* Toby to his    mouth  , and took a hearty draught. ---           
    ## [  6]             --- Sir John, who *lifted* his    hands   and eyebrows, as if deploring ---         
    ## [  7]             --- who *lifted* his hands and  eyebrows , as if deploring the intemperate ---      
    ## [  8]                   --- a post, and felt his    heart   *lifted* up with a brave ---              
    ## [  9]       --- nearest fire, some with *lifted*    faces   following their course upon the ---       
    ## [ 10]      --- shrugged his shoulders, shook his    head   , *lifted* up his hands; and ---           
    ## [ 11]              --- his head, *lifted* up his    hands  ; and with the same smooth ---             
    ## [ 12]             --- idiot, caged in his narrow    cell   , was as much *lifted* up ---              
    ## [ 13]              --- which she *lifted* up her    face    to mine, and did so. ---                  
    ## [ 14]          --- Poor Peggotty *lifted* up her    hands   and eyes, and only answered, ---          
    ## [ 15]              --- *lifted* up her hands and    eyes   , and only answered, in a ---              
    ## [ 16]                --- there, I *lifted* up my    eyes    to the window above it, ---               
    ## [ 17]           --- Doctor, who had *lifted* her    head    upon his knee, put her ---                
    ## [ 18]             --- *lifted* her head upon his    knee   , put her curls aside with ---             
    ## [ 19]              --- spoke, or *lifted* up her    eyes   . All this time, Mr. Wickfield ---         
    ## [ 20]                --- _b_ She *lifted* up her    head   , and looked darkly round at ---           
    ## [ 21]        --- great effort, just *lifted* his    head    far enough out of his ---                 
    ## [ 22]        --- affair; the horses arched their    necks   and *lifted* up their legs ---            
    ## [ 23]            --- necks and *lifted* up their    legs    as if they knew they ---                  
    ## [ 24]            --- but neither *lifted* up her    face   , nor spoke a word _b_ ---                 
    ## [ 25]             --- kitchen with her two short    arms    distressfully *lifted* up _b_ _b_ ---     
    ## [ 26]         --- she absolutely *lifted* up her    hand   , and struck it _b_ _b_ ---                
    ## [ 27]               --- letter, I *lifted* up my    eyes   , and meeting the thoughtful face ---      
    ## [ 28]            --- idle fingers. At length her    eyes    were *lifted* up to mine, ---             
    ## [ 29]                 --- in his chair, with his  eyebrows  *lifted* up as high as ---                
    ## [ 30]                --- his feet, and, with her    hands   imploringly *lifted*, fixed upon his ---  
    ## [ 31]   --- imploringly *lifted*, fixed upon his    face    the memorable look I had ---              
    ## [ 32]                --- _b_ She *lifted* up her    eyes   , and solemnly declared that she ---       
    ## [ 33]            --- boatman hoarsely said in my     ear   , and then *lifted* in and ---             
    ## [ 34]               --- I *lifted* up the leaden    hand   , and held it to my ---                    
    ## [ 35]          --- the innocence of her grateful    heart  , the child *lifted* up her ---            
    ## [ 36]              --- the child *lifted* up her    face    to his. Walter, bending down ---          
    ## [ 37]              --- and, rippling up into his  forehead , *lifted* the glazed hat: as ---          
    ## [ 38]             --- The figure *lifted* up its    head   , and rose, and coming to ---              
    ## [ 39]                --- _b_ _b_ *lifted* up his    head    again, and whistled to her ---            
    ## [ 40]             --- The father *lifted* up his    head    again, and whistled to her. ---           
    ## [ 41]              --- who never *lifted* up her    eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 42]                --- _b_ _b_ _b_ The cordial    face    she *lifted* up to his ---                
    ## [ 43]         --- Edith alone never *lifted* her    eyes    to any face at the ---                    
    ## [ 44]               --- *lifted* her eyes to any    face    at the table, and never ---               
    ## [ 45]           --- and beauty. She *lifted* her    hand    to the tiara of bright ---                
    ## [ 46]               --- he *lifted* up his cruel     arm   , and struck her, crosswise, with ---      
    ## [ 47]                 --- Now it *lifted* up its    head   , examining the lines and hollows ---      
    ## [ 48]           --- merely *lifted* up his heavy    eyes    to say it, and now ---                    
    ## [ 49]                  --- to be *lifted* off my    legs    and 'ave my braces bust ---               
    ## [ 50]                --- It then *lifted* up its    head   , to notice that the bereaved ---          
    ## [ 51]            --- us, but just *lifted* their    heads   and took a sleepy stare, ---              
    ## [ 52]                --- it would have served my    face    right, if I had *lifted* ---              
    ## [ 53]                   --- *lifted* it up by my    hair   , and knocked it against the ---           
    ## [ 54]           --- seen before, *lifted* up her    eyes    and looked archly at me, ---              
    ## [ 55]        --- The tempter merely *lifted* his  eyebrows ; but the whelp was obliged ---            
    ## [ 56]          --- added, having *lifted* up his    eyes    and looked about; for he ---              
    ## [ 57]          --- Mr. Gradgrind *lifted* up his    head   , and said to his daughter ---             
    ## [ 58]                   --- said so in the proud    eyes   , in the *lifted* nostril, in ---          
    ## [ 59]            --- proud eyes, in the *lifted*   nostril , in the handsome but compressed ---       
    ## [ 60]            --- She cried, with her clasped    hands   *lifted* above her head, that ---         
    ## [ 61]               --- she *lifted* up her dark    eyes    and made this unexpected answer ---       
    ## [ 62]      --- Marshalsea always *lifted* up his  eyebrows  at this point, and became ---             
    ## [ 63]            --- never *lifted* up his bowed    head   , never varied his shuffling gait ---      
    ## [ 64]               --- Speaking to him with her    eyes    *lifted* up to his, and ---               
    ## [ 65]              --- gentleman put his wife 's     arm    over his shoulder, *lifted* her ---       
    ## [ 66]                   --- wife 's arm over his  shoulder , *lifted* her up, and carried ---         
    ## [ 67]              --- where he had *lifted* her insensible from the floor. He foresaw ---            
    ## [ 68]                    --- He took them up and   inhaled  their fragrance, and he *lifted* ---      
    ## [ 69]               --- *lifted* them to his hot    head   , and he put them down ---                 
    ## [ 70]                --- _b_ _b_ He *lifted* her    hand    to his lips _b_ _b_ ---                   
    ## [ 71]               --- *lifted* her hand to his    lips    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 72]         --- charge had hardly *lifted* his    eyes    from the ground. _b_ _b_ ---              
    ## [ 73]                  --- he saw Jonas with his    hand    *lifted*, and the bottle clenched ---     
    ## [ 74]          --- whenever Ruth *lifted* up her    eyes   , did she let them fall ---                
    ## [ 75]               --- has not yet *lifted* its    face    to heaven that perseverance will ---      
    ## [ 76]                  --- he *lifted* her up on   tiptoe  , and kept her, for some ---               
    ## [ 77]         --- the old gentleman *lifted* his    legs    awkwardly once or twice, as ---           
    ## [ 78]         --- arm thrown carelessly over the    back   , and now and then *lifted* ---            
    ## [ 79]              --- *lifted* his glass to his    mouth   and drank a little punch, ---             
    ## [ 80]              --- lips, and that having her    eyes    *lifted* to the sky in ---                
    ## [ 81]             --- head and throwing open his    mouth  , he *lifted* up his voice ---             
    ## [ 82]             --- an instant to his bleeding    hand   . He *lifted* it to his ---                
    ## [ 83]                  --- He *lifted* it to his    mouth  , wiped it on his sleeve, ---              
    ## [ 84]                --- The Jew *lifted* up his    eyes   , and took in Eugene once ---              
    ## [ 85]                --- old man *lifted* up his    eyes    again, with one grave look ---            
    ## [ 86] --- softly raised the weather-stained grey    head   , and *lifted* her as high ---             
    ## [ 87]               --- the old man *lifted* his    head   , and looked distressfully at Fledgeby --- 
    ## [ 88]                --- old man *lifted* up his    eyes    once more to the little ---               
    ## [ 89]           --- but Bella, after hanging her    head    for a moment, *lifted* it ---             
    ## [ 90]           --- strength *lifted* him in her    arms    and laid him in the ---                   
    ## [ 91]         --- _b_ _b_ Lightwood *lifted* his    head    at the neck, and put ---                  
    ## [ 92]               --- *lifted* his head at the    neck   , and put a wine-glass to ---              
    ## [ 93]                    --- were but out of his    mouth   when John Harmon *lifted* his ---         
    ## [ 94]          --- when John Harmon *lifted* his   finger  , and Sloppy, who was now ---              
    ## [ 95]                --- cup, *lifted* it to his    nose    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 96]   --- two women-servants *lifted* up their    hands   and eyes, and supposed that ---           
    ## [ 97]            --- *lifted* up their hands and    eyes   , and supposed that Mr. Giles, ---         
    ## [ 98]            --- Mr. Grimwig *lifted* up his    head   , and converting one of the ---            
    ## [ 99]       --- company, and slowly *lifted* his    hand   , upon which every man (including ---      
    ## [100]       --- mottled countenance) drew a long   breath  , and *lifted* his tumbler to ---          
    ## [101]            --- *lifted* his tumbler to his    lips   . In one instant, the mottled-faced ---    
    ## [102]              --- met her glance. The young  forehead  *lifted* itself into that singular ---    
    ## [103]                --- arm that shook upon his  shoulder , *lifted* her a little, and ---           
    ## [104]              --- After a long silence, the    head    was *lifted* for another moment, ---      
    ## [105]               --- And when he *lifted* his    eyes    from it to the horizon ---                
    ## [106]        --- Madame Defarge met the *lifted*  eyebrows  and forehead with a cold, ---             
    ## [107]          --- met the *lifted* eyebrows and  forehead  with a cold, impassive stare ---          
    ## [108]               --- when she *lifted* up the    eyes    she had momentarily darkened with ---     
    ## [109]               --- *lifted* up to clasp her    arms    round his neck; and after ---             
    ## [110]               --- day, and he *lifted* his    foot    to put back one of ---                    
    ## [111]               --- stones of the street her    feet    had trodden, he *lifted* her ---          
    ## [112]                 --- _b_ _b_ As the patient    eyes    were *lifted* to his face, ---            
    ## [113]      --- women who scarcely *lifted* their    eyes    to look at it a ---

``` r
# laying
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("laying"), context = 0)
y
```

    ## [  1]              --- saw in Ada 's compassionate    eyes  , took the opportunity of *laying* ---    
    ## [  2]            --- tighter and *laying* down her    face   again upon my breast _b_ ---             
    ## [  3]                  --- to us, and *laying* his    hand   gently on her arm _b_ ---                
    ## [  4]        --- of occasionally *laying* the open    palm   of his broad brown hand ---              
    ## [  5]                --- *laying* his hands on the shoulders of his comrade before the ---            
    ## [  6]         --- veil altogether, and *laying* my    hand   on Richard 's sleeve and ---             
    ## [  7]           --- said my guardian, *laying* his    hand   emphatically on the sleeve of ---        
    ## [  8]             --- the window, and *laying* his    arm    across it, leaned his head ---           
    ## [  9]               --- looks at his questioner 's   knees   again, and concludes by *laying* ---     
    ## [ 10]            --- and concludes by *laying* his  profile  against the hoarding in a ---            
    ## [ 11]                  --- _b_ said I, *laying* my    face   against her forehead, for indeed ---     
    ## [ 12]             --- *laying* my face against her  forehead, for indeed I was crying ---             
    ## [ 13]                --- disturb it by *laying* my    hand   on his breast. But I ---                 
    ## [ 14]                  --- *laying* my hand on his   breast . But I found I did ---                   
    ## [ 15]           --- _b_ said Barnaby, *laying* his  fingers  upon his lips _b_ _b_ ---                
    ## [ 16]            --- *laying* his fingers upon his    lips   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 17]              --- the table, and *laying* his    hand   upon it heavily _b_ _b_ ---              
    ## [ 18]          --- said Mr Tappertit, *laying* his    hand   upon his breast _b_ _b_ ---              
    ## [ 19]               --- *laying* his hand upon his   breast  _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 20]              --- and *laying* his broad flat    hand   upon the table _b_ _b_ ---               
    ## [ 21]       --- the humble secretary, *laying* his    hand   upon his heart _b_ _b_ ---               
    ## [ 22]               --- *laying* his hand upon his   heart   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 23]           --- George replied by *laying* his    hand   upon the shoulder of his ---             
    ## [ 24]               --- *laying* his hand upon the  shoulder of his cringing secretary, and ---       
    ## [ 25]                --- her seat and *laying* her    hand   upon his shoulder _b_ _b_ ---            
    ## [ 26]               --- *laying* her hand upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 27]             --- the widow, *laying* both her   hands   upon his breast, and scarcely ---        
    ## [ 28]          --- that moment. Hugh, *laying* his   finger  on his nose, stepped back ---            
    ## [ 29]               --- *laying* his finger on his    nose  , stepped back into his former ---        
    ## [ 30]                  --- two men, and *laying* a    hand   upon the arm of each, ---                
    ## [ 31]                 --- *laying* a hand upon the    arm    of each, said, in a ---                  
    ## [ 32]              --- cried the man, *laying* his    hand   upon his horse 's bridle ---             
    ## [ 33]          --- _b_ added Barnaby, *laying* his    hand   upon the neck of Lord ---                
    ## [ 34]               --- *laying* his hand upon the    neck   of Lord George 's horse, ---             
    ## [ 35]             --- _b_ said Simon, *laying* his    hand   upon his breast, 'not a ---              
    ## [ 36]               --- *laying* his hand upon his   breast , 'not a _b_ _b_ _b_ ---                  
    ## [ 37]        --- more familiarly, and *laying* his   hands   upon his arm _b_ _b_ ---                 
    ## [ 38]              --- *laying* his hands upon his    arm    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 39]        --- _b_ said Barnaby, withdrawing his    hand   from the bird, and *laying* ---          
    ## [ 40]              --- _b_ said Hugh, *laying* his    hand   upon his head, and speaking ---          
    ## [ 41]               --- *laying* his hand upon his    head  , and speaking in a lower ---             
    ## [ 42]              --- _b_ asked Joe, *laying* his    hand   upon his sire 's shoulder, ---           
    ## [ 43]                --- the bed, and *laying* her    chin   upon her hands, and laughing, ---        
    ## [ 44]               --- *laying* her chin upon her   hands  , and laughing, said _b_ _b_ ---          
    ## [ 45]       --- interposed my mother, *laying* her  fingers  on my lips again _b_ ---                 
    ## [ 46]               --- *laying* her fingers on my    lips   again _b_ _b_ _b_ _b_ ---                
    ## [ 47]            --- never did. After *laying* his    head   on the desk for a ---                    
    ## [ 48]                --- she said, putting out her    hand  , and *laying* it affectionately on ---   
    ## [ 49]        --- *laying* it affectionately on the    hand   of her old servant _b_ ---               
    ## [ 50]              --- only going and *laying* her   cheek   against his rough whisker. That ---      
    ## [ 51]       --- flowery meadows, *laying* down our   heads   on moss at night, in ---                 
    ## [ 52]                --- *laying* her fan upon his    lips   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 53]               --- said my aunt, *laying* her    hand   with melancholy firmness on the ---      
    ## [ 54]                 --- _b_ _b_ _b_ *laying* her    head   upon his shoulder _b_ _b_ ---            
    ## [ 55]               --- *laying* her head upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 56]               --- said my aunt, *laying* her    hand   calmly on my shoulder _b_ ---            
    ## [ 57]              --- Traddles and I *laying* our   heads   together apart, while Mr. Dick ---       
    ## [ 58]            --- _b_ said Tiffey, *laying* his    hand   upon my arm, and shutting ---            
    ## [ 59]                --- *laying* his hand upon my    arm   , and shutting up both his ---            
    ## [ 60]  --- Wickfield again *laying* his irresolute    hand   upon the Doctor 's arm ---               
    ## [ 61]              --- said Mr. Dick, *laying* his   finger  on the side of his ---                   
    ## [ 62]           --- chair nearer, and *laying* one    hand   upon my knee _b_ _b_ ---                 
    ## [ 63]                --- *laying* one hand upon my    knee   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 64]          --- my aunt proceeded, *laying* her    hand   as usual on the back ---                 
    ## [ 65]        --- he continued, mildly *laying* his    head   on one side _b_ _b_ ---                  
    ## [ 66]         --- pippins, all *laying* their rosy   cheeks  close to it, and all ---                 
    ## [ 67]             --- said the child, *laying* his   hands   upon the elbows of his ---               
    ## [ 68]              --- *laying* his hands upon the   elbows  of his little chair, and ---             
    ## [ 69]                 --- son 's, and *laying* his    hand   gently on his back _b_ ---               
    ## [ 70]                --- _b_ he said, *laying* his    hand   on his shoulder _b_ _b_ ---              
    ## [ 71]                 --- *laying* his hand on his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 72]              --- he said gaily, *laying* his    hand   upon the old man 's ---                  
    ## [ 73]          --- _b_ said Florence, *laying* her    hand   timidly upon the old man ---             
    ## [ 74]                  --- of *laying* it near his   heart  , but was fain to put ---                 
    ## [ 75]             --- said the Major, *laying* his   finger  on his lips, and speaking ---            
    ## [ 76]               --- *laying* his finger on his    lips  , and speaking half apart to ---          
    ## [ 77]      --- The Captain, *laying* his ponderous    hand   upon his chest, to assist ---            
    ## [ 78]               --- _b_ he added, *laying* his    hand   gently on her arm, for ---               
    ## [ 79]           --- floor before her, clasping her   knees  , *laying* her head against them, ---     
    ## [ 80]         --- clasping her knees, *laying* her    head   against them, and still rocking ---      
    ## [ 81]             --- _b_ said Edith, *laying* her    hand   upon her breast, 'what is ---            
    ## [ 82]               --- *laying* her hand upon her   breast , 'what is not here. Never ---            
    ## [ 83]           --- and softly *laying* his velvet    hand  , as a cat might have ---                 
    ## [ 84]            --- _b_ she croaked, *laying* her    hand  , like a claw, upon his ---               
    ## [ 85]             --- _b_ said Alice, *laying* her    hand   upon her arm' and looking ---            
    ## [ 86]               --- of the last stage reeking,  panting , and *laying* their drooping heads ---   
    ## [ 87]     --- panting, and *laying* their drooping   heads   together dolefully at stable doors; ---  
    ## [ 88]           --- said the Captain, *laying* his    hand   on Mr Toots 's shoulder ---              
    ## [ 89]    --- Affianced, quickly *laying* her light    hand   upon his wrist _b_ _b_ ---               
    ## [ 90]         --- said Mr. Grewgious, *laying* his    hand   on Rosa 's, as the ---                   
    ## [ 91]          --- Englishmen -- of *laying* their   hands   each on the other 's ---                 
    ## [ 92]                --- it back, and *laying* her    hand   upon his chest, moves him ---            
    ## [ 93]               --- *laying* her hand upon his   chest  , moves him slightly from side ---        
    ## [ 94]               --- _b_ she said, *laying* her   hands  , one upon the other, on ---              
    ## [ 95]             --- took the liberty of *laying*   hands   upon it. _b_ _b_ _b_ ---                 
    ## [ 96]                  --- _b_ said I, *laying* my    hand   upon his knee _b_ _b_ ---                
    ## [ 97]                --- *laying* my hand upon his    knee   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 98]             --- _b_ said Biddy, *laying* her    hand   upon my arm, as I ---                    
    ## [ 99]                --- *laying* her hand upon my    arm   , as I was for running ---                
    ## [100]                  --- wound up by *laying* my    hand   upon his shoulder, and saying ---        
    ## [101]                --- *laying* my hand upon his  shoulder, and saying _b_ _b_ _b_ ---              
    ## [102]               --- voice, and *laying* a long   finger  on my breast in an ---                   
    ## [103]                --- _b_ said he, *laying* his    hand   on my arm in a ---                       
    ## [104]                  --- *laying* his hand on my    arm    in a suddenly altered and ---            
    ## [105]           --- said Mr. Jaggers, *laying* his    hand   upon my arm, and smiling ---             
    ## [106]                --- *laying* his hand upon my    arm   , and smiling openly _b_ _b_ ---          
    ## [107]               --- moment of his *laying* his    hand   on his cloak to identify ---             
    ## [108]                --- to side, and *laying* her    chin   upon the little hand as ---              
    ## [109]            --- and *laying* his closed right    hand  , with its peculiar suppleness of ---     
    ## [110]          --- of the Marshalsea, *laying* his    hand   upon his shoulder, and mildly ---        
    ## [111]               --- *laying* his hand upon his  shoulder, and mildly rallying him -- ---          
    ## [112]                --- _b_ said he, *laying* his    hand   on the shoulder of Jeremiah, ---         
    ## [113]                 --- *laying* his hand on the  shoulder of Jeremiah, who stopped and ---         
    ## [114]      --- her control. Softly withdrawing her    hand  , and *laying* it in her ---              
    ## [115]                 --- *laying* it in her other    hand  , she sat before him with ---             
    ## [116]           --- and his daughter, *laying* her    face   against his, encircled him in ---        
    ## [117]                 --- *laying* the tips of the  fingers  of her two little hands ---              
    ## [118]            --- over his pillow, *laying* her   cheek   against his. Sometimes she was ---       
    ## [119]         --- *laying* that plastic workman 's   thumb   of his on the lapel ---                  
    ## [120]         --- _b_ rejoined Doyce, *laying* his    hand   persuasively on his shoulder _b_ ---     
    ## [121]      --- window-seat, and *laying* his right    hand   upon the stocking _b_ _b_ ---            
    ## [122]             --- the young lady, *laying* her    hand   upon his arm _b_ _b_ ---                 
    ## [123]               --- *laying* her hand upon his    arm    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [124]          --- said Mr Pecksniff, *laying* his    hand   upon his breast, and dropping ---        
    ## [125]               --- *laying* his hand upon his   breast , and dropping his eyelids _b_ ---        
    ## [126]             --- came' said Tom, *laying* his    hand   upon the other 's arm ---                
    ## [127]          --- _b_ added Anthony, *laying* his    hand   upon his sleeve _b_ _b_ ---              
    ## [128]              --- the old pupil, *laying* one    hand   on each of Mr Pinch ---                  
    ## [129]          --- said Mr Pecksniff, *laying* his    hand   tenderly upon his kinsman 's ---         
    ## [130]          --- great feeling, and *laying* her    hand   upon her arm _b_ _b_ ---                 
    ## [131]               --- *laying* her hand upon her    arm    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [132]        --- cried the secretary, *laying* his    hand  , with growing familiarity, upon the ---  
    ## [133]           --- she said; timidly *laying* her    hand   upon his shoulder, and bending ---       
    ## [134]               --- *laying* her hand upon his  shoulder, and bending her head down ---           
    ## [135]        --- inquired his sister, *laying* her    hand   upon his shoulder _b_ _b_ ---            
    ## [136]               --- *laying* her hand upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [137]      --- resumed John Westlock, *laying* his    hand   on Tom 's wrist, to ---                  
    ## [138]                --- as Mrs Gamp, *laying* her    chin   against the cool iron of ---             
    ## [139]                --- the old man, *laying* his    hand   with unusual earnestness on Mr ---       
    ## [140]      --- further explanation by *laying* her    hand   upon his lips, and betraying ---         
    ## [141]               --- *laying* her hand upon his    lips  , and betraying a soft embarrassment. --- 
    ## [142]            --- said old Martin, *laying* his    hand   on Chuffey 's sleeve _b_ ---             
    ## [143]            --- so rash, and *laying* violent   hands   upon a quantity of stone ---             
    ## [144]          --- _b_ said Nicholas, *laying* his    hand   upon his shoulder _b_ _b_ ---            
    ## [145]               --- *laying* his hand upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [146]            --- _b_ said Newman, *laying* his    hand   upon the lappel of his ---               
    ## [147]          --- _b_ said Nicholas, *laying* his    hand   on Newman 's shoulder _b_ ---            
    ## [148]       --- cried the sister, *laying* violent   hands   upon Mrs Kenwigs, and holding ---        
    ## [149]               --- said the lad, *laying* his    hand   timidly on that of Nicholas ---          
    ## [150]               --- the hint, and *laying* his   finger  on his lip, sunk his ---                 
    ## [151]               --- *laying* his finger on his    lip   , sunk his voice still lower. ---         
    ## [152]      --- _b_ rejoined Nicholas, *laying* his    hand   upon his shoulder _b_ _b_ ---            
    ## [153]               --- *laying* his hand upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [154]      --- _b_ rejoined Nicholas, *laying* his    hand   upon the scrapbook _b_ _b_ ---           
    ## [155]       --- replied Sir Mulberry, *laying* his    hand   on her arm _b_ _b_ ---                   
    ## [156]                 --- *laying* his hand on her    arm    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [157]                --- old man, and *laying* her    arm    upon his shoulder _b_ _b_ ---            
    ## [158]                --- *laying* her arm upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [159]          --- aloud. But, Newman *laying* his   finger  upon his lips, she had ---               
    ## [160]             --- *laying* his finger upon his    lips  , she had the presence of ---             
    ## [161]                   --- 's *laying* his or her    chin   on the shoulder of the ---               
    ## [162]             --- _b_ said Ralph, *laying* his    hand   on the arm of the ---                    
    ## [163]                 --- *laying* his hand on the    arm    of the Yorkshire schoolmaster _b_ ---    
    ## [164]                --- the old man, *laying* his    hand   on the shoulder of Nicholas, ---         
    ## [165]                 --- *laying* his hand on the  shoulder of Nicholas, and walking him ---         
    ## [166]                 --- _b_ _b_ _b_ *laying* his   finger  on the sleeve of his ---                 
    ## [167]       --- brother Charles, gently taking her    hand   in his, and *laying* her ---             
    ## [168]                 --- in his, and *laying* her    head   upon his arm _b_ _b_ ---                 
    ## [169]               --- *laying* her head upon his    arm    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [170]          --- _b_ said Nicholas, *laying* his    hand   upon his shoulder _b_ _b_ ---            
    ## [171]               --- *laying* his hand upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [172]          --- said Mrs Nickleby, *laying* her    hand   on Kate 's _b_ _b_ ---                   
    ## [173]          --- the old gentleman, *laying* his   finger  on his nose, with an ---                 
    ## [174]               --- *laying* his finger on his    nose  , with an air of familiarity, ---         
    ## [175]         --- as brother Charles, *laying* his    hand   upon his shoulder, bade him ---          
    ## [176]               --- *laying* his hand upon his  shoulder, bade him walk with him, ---             
    ## [177]           --- cried John, *laying* his heavy    hand   upon his chest _b_ _b_ ---               
    ## [178]          --- the old gentleman, *laying* his    hand   upon his heart _b_ _b_ ---               
    ## [179]               --- *laying* his hand upon his   heart   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [180]                --- _b_ he said, *laying* his    hand   on Newman 's _b_ _b_ ---                 
    ## [181]                       --- had seemed to be a  slumber , and *laying* his hand in ---            
    ## [182]              --- a slumber, and *laying* his    hand   in his, prayed, as the ---               
    ## [183]          --- the old gentleman, *laying* his    hand   upon his brother 's shoulder ---         
    ## [184]             --- said the child, *laying* her   finger  on her lip and looking ---               
    ## [185]               --- *laying* her finger on her    lip    and looking round _b_ _b_ ---            
    ## [186]                --- _b_ he said, *laying* his    hand   gently on her head. 'Your ---            
    ## [187]                 --- the old man *laying* his    hand   upon her mouth _b_ _b_ ---               
    ## [188]               --- *laying* his hand upon her   mouth   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [189]          --- the old gentleman, *laying* his    hand   upon her head, and smiling ---           
    ## [190]               --- *laying* his hand upon her    head  , and smiling sadly _b_ _b_ ---           
    ## [191]             --- nothing -- and, *laying* her    head   upon his arm, patted her ---             
    ## [192]               --- *laying* her head upon his    arm   , patted her fair cheek with ---          
    ## [193]          --- _b_ cried Sampson, *laying* his    hand   on one shoulder, while Mr ---            
    ## [194]                 --- *laying* his hand on one  shoulder, while Mr Swiveller pounced upon ---     
    ## [195]           --- said Brass, *laying* his right    hand   on his waistcoat, and looking ---        
    ## [196]       --- gentleman rising, and *laying* his    hand   on Kit 's shoulder _b_ ---               
    ## [197]              --- that side, and *laying* his    hand   on the gunwale of Gaffer ---             
    ## [198]                    --- in one another on his  shoulder, and *laying* her rich brown ---         
    ## [199]              --- and *laying* her rich brown   cheek   against them as she looked ---           
    ## [200]           --- took it, *laying* a hesitating    hand   on a corner of the ---                   
    ## [201]       --- light interruption, and *laying* a    hand   upon Eugene 's shoulder, as ---          
    ## [202]        --- her opportunity, and *laying* her    hand   persuasively on her arm _b_ ---          
    ## [203]       --- _b_ returned Lizzie, releasing the    hand  , and *laying* her own lightly ---        
    ## [204]                     --- or two of her nimble   hands  , as that she herself *laying* ---        
    ## [205]              --- that she herself *laying* a   cheek   on one of the dark ---                   
    ## [206]             --- said Mr Boffin, *laying* his    hand   protectingly on Bella 's head ---        
    ## [207]             --- said Mr Boffin, *laying* his    hand   on Bella 's head again ---               
    ## [208]               --- _b_ _b_ *laying* her round   cheek   upon her plump left arm, ---             
    ## [209]            --- she repressed by *laying* her    hand   on her neat methodical boddice ---       
    ## [210]            --- _b_ cried Bella, *laying* her    hand   upon his lips, with a ---                
    ## [211]               --- *laying* her hand upon his    lips  , with a proud look _b_ ---               
    ## [212]              --- _b_ said John, *laying* his    hand   on hers _b_ _b_ _b_ ---                  
    ## [213]            --- loud crash; and, *laying* his    hand   on a bread knife which ---               
    ## [214]               --- said the Jew, *laying* his    hand   upon it after a short ---                
    ## [215]           --- sudden stop; and, *laying* his   finger  on his lip, drew his ---                 
    ## [216]               --- *laying* his finger on his    lip   , drew his companions back again, ---     
    ## [217]           --- a hoarse whisper; *laying* his   finger  on the side of his ---                   
    ## [218]          --- replied the woman, *laying* her    hand   over the other 's mouth ---              
    ## [219]          --- stouter man, smoothing down his    hair  , and *laying* a pair of ---              
    ## [220]           --- said Mrs. Maylie, *laying* her    hand   on Oliver 's head _b_ ---                
    ## [221]           --- said Mrs. Maylie, *laying* her   finger  on her lip, as she ---                   
    ## [222]               --- *laying* her finger on her    lip   , as she looked steadily into ---         
    ## [223]       --- returned Mrs. Maylie, *laying* her    hand   upon his shoulder _b_ _b_ ---            
    ## [224]               --- *laying* her hand upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [225]             --- _b_ said Harry, *laying* his    hand   upon his arm _b_ _b_ ---                 
    ## [226]               --- *laying* his hand upon his    arm    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [227] --- preliminary proceeding *laying* bare his    head  , the expert lady, clasping him ---       
    ## [228]              --- said the girl, *laying* her    hand   upon his shoulder _b_ _b_ ---            
    ## [229]               --- *laying* her hand upon his  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [230]                 --- _b_ _b_ _b_ *Laying* his   skinny  forefinger upon his lip, the ---         
    ## [231]             --- _b_ said Fagin, *laying* his    hand   on Noah 's knee _b_ ---                  
    ## [232]         --- asked Master Bates, *laying* his    hand   on Noah 's arm _b_ ---                   
    ## [233]         --- _b_ rejoined Fagin, *laying* his    hand   upon the lock _b_ _b_ ---                
    ## [234]                 --- to him, and *laying* his    hand   upon his head _b_ _b_ ---                
    ## [235]               --- *laying* his hand upon his    head   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [236]           --- said the turnkey, *laying* his    hand   upon his breast to keep ---              
    ## [237]               --- *laying* his hand upon his   breast  to keep him down _b_ ---                 
    ## [238]    --- ejaculated Mr. Pickwick, *laying* his    hand   upon his note-book. The driver ---       
    ## [239]                    --- bright eye and a neat   ankle  , was *laying* a very clean ---           
    ## [240]           --- that morning; and *laying* his   finger  on a particular paragraph, threw ---     
    ## [241]                --- *laying* the blame on the shoulders of Mr. Nupkins. Accordingly, when ---    
    ## [242]                 --- _b_ _b_ _b_ *Laying* his    hand   on the mulberry collar of ---            
    ## [243]          --- said Mr. Pickwick, *laying* his    hand   gently and compassionately on his ---    
    ## [244]          --- _b_ rejoined Pott, *laying* his    hand   on Mr. Pickwick 's knee, ---             
    ## [245]           --- _b_ added Perker, *laying* his    hand   on Mr. Pickwick 's shoulder ---          
    ## [246]               --- lady, by *laying* a brawny    hand   upon his chest, and sending ---          
    ## [247]            --- of their wives *laying* their   heads   upon their pillows; that, they ---       
    ## [248]         --- of their children *laying* their   heads   upon their pillows; in short, ---        
    ## [249]               --- or theirs, any *laying* of   heads   upon pillows at all, unless ---          
    ## [250]          --- said Lucie, softly *laying* her    hand   on his. _b_ _b_ _b_ ---                  
    ## [251]           --- Mr. Lorry, gently *laying* his    hand   on the Doctor 's arm ---                 
    ## [252]              --- nearer to him, *laying* her    head   upon his breast, and raising ---         
    ## [253]               --- *laying* her head upon his   breast , and raising her eyes to ---             
    ## [254]              --- his story, and *laying* his    hand   on hers _b_ _b_ _b_ ---                  
    ## [255]         --- Doctor, rising, and *laying* his    hand   upon her shoulder _b_ _b_ ---            
    ## [256]               --- *laying* his hand upon her  shoulder _b_ _b_ _b_ _b_ _b_ ---                  
    ## [257]        --- said Madame Defarge, *laying* her    hand   with a slight frown on ---

``` r
# raising
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("raising"), context = 0)
y
```

    ## [  1]         --- dejected bow, departed. *Raising* my      eyes      as he went out, I ---                        
    ## [  2]                 --- Ada then, *raising* her blue      eyes      tenderly to his face _b_ ---                 
    ## [  3]                 --- _b_ I returned, *raising* my      head      from my work to look ---                     
    ## [  4]                       --- George one poke in the      back     . The trooper *raising* his head, ---         
    ## [  5]              --- back. The trooper *raising* his      head     , she makes another poke at ---               
    ## [  6]             --- to her, without himself stirring      hand      or foot or *raising* his ---                 
    ## [  7]             --- without himself stirring hand or      foot      or *raising* his voice _b_ ---               
    ## [  8]         --- Mr. Skimpole, *raising* his laughing      eyes      in playful astonishment _b_ _b_ ---          
    ## [  9]        --- Sir Leicester observes; *raising* his      eyes      to his face _b_ _b_ ---                      
    ## [ 10]               --- and *raising* them towards her     breast    , bows down his head, and ---                 
    ## [ 11]                     --- _b_ said I, *raising* my      eyes      to his _b_ _b_ _b_ ---                       
    ## [ 12] --- returned inquiringly, *raising* his pleasant    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 13]           --- traveller at length, *raising* his      head      and the lantern together _b_ ---             
    ## [ 14]                --- said the guest, *raising* his      eyes      to John 's fat face ---                      
    ## [ 15]              --- cried his father, *raising* his     eyelids    in a languishing surprise _b_ ---            
    ## [ 16]              --- returned the son, *raising* his      head      for a moment, and then ---                   
    ## [ 17]                  --- it out, when, *raising* her      head     , she saw him standing silently ---           
    ## [ 18]                --- said, at length *raising* his      eyes      to the ceiling with the ---                  
    ## [ 19]                   --- _b_ he said, *raising* his    eyebrows    with as indolent an expression ---           
    ## [ 20]            --- returned the other, *raising* his      head      a little from the cushion ---                
    ## [ 21]                   --- _b_ he said, *raising* his      head      to look after him _b_ ---                    
    ## [ 22]           --- Mr Chester, *raising* his delicate      hand      imploringly _b_ _b_ _b_ _b_ ---              
    ## [ 23]             --- said his lordship, *raising* his      head      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 24]                --- cried Sir John, *raising* his    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 25]      --- said Gashford, stealthily *raising* his      eyes     , and letting them drop again ---             
    ## [ 26]            --- _b_ cried Gashford, *raising* his    eyebrows    with an exclamation of surprise ---          
    ## [ 27]                --- his person, and *raising* his      eyes      to the ceiling, looked all ---               
    ## [ 28]            --- guard, and, without *raising* his      eyes     , that he tried to wave ---                   
    ## [ 29]          --- little court, without *raising* his      head      or changing his attitude in ---              
    ## [ 30]              --- he said, *raising* his manacled      hand     , and shaking it _b_ _b_ ---                  
    ## [ 31]        --- door, and involuntarily *raising* his       arm      to defend himself, stared at ---             
    ## [ 32]                --- _b_ asked Hugh, *raising* his      head     , with such a fierce expression, ---          
    ## [ 33]              --- _b_ growled Hugh, *raising* his      head      to look at him with ---                      
    ## [ 34]                 --- said Sir John, *raising* his      hand      in deprecation of his delivering ---         
    ## [ 35]                  --- the wall; and *raising* his      eyes      to the locksmith 's face ---                 
    ## [ 36]                     --- *raising* his cup to his      lips      with a perfectly steady hand, ---            
    ## [ 37]              --- cried Hugh, *raising* his right       arm      aloft, and looking upward like ---           
    ## [ 38]             --- said Dolly, *raising* her pretty      face      to his _b_ _b_ _b_ ---                       
    ## [ 39]             --- turf. *Raising* himself upon his      hands    , he gazed at him for ---                     
    ## [ 40]         --- Mr. Wickfield scarcely *raising* his      eyes      from the ground. When we, ---                
    ## [ 41]             --- said Mr. Micawber, *raising* his    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 42]               --- _b_ _b_ *raising* her cheerful      face      from the music she is ---                    
    ## [ 43]            --- remained so; seldom *raising* his      eyes     , unless to rest them for ---                 
    ## [ 44]            --- said Dora, slightly *raising* her    eyebrows   , and shaking her head _b_ ---                
    ## [ 45]           --- returned Agnes, *raising* her soft      eyes      to mine _b_ _b_ _b_ ---                      
    ## [ 46]                  --- _b_ _b_ *Raising* his great      hands     until they touched his chin, ---             
    ## [ 47]                   --- he almost closed his small      eyes     , while the hurried *raising* of ---          
    ## [ 48]              --- hurried *raising* of his grisly      hand      to his chin betrayed some ---                
    ## [ 49]                     --- a little while, with her      chin      upon her hand. Slowly *raising* ---          
    ## [ 50]                       --- with her chin upon her      hand     . Slowly *raising* her eyes to ---            
    ## [ 51]               --- her hand. Slowly *raising* her      eyes      to mine, she said _b_ ---                    
    ## [ 52]             --- _b_ said Florence, *raising* her      eyes      from her work _b_ _b_ ---                    
    ## [ 53]            --- _b_ pursued Walter, *raising* his      eyes      with a look of entreaty ---                  
    ## [ 54]              --- by slightly *raising* his right      hand      in a deprecatory manner, as ---              
    ## [ 55]                   --- the old man, *raising* his    eyebrows   , and his spectacles with them ---            
    ## [ 56]                  --- _b_ he added, *raising* his      eyes      from his plate, and casting ---              
    ## [ 57]                --- said Mr Dombey, *raising* his      head      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 58]        --- daughter slightly turned her graceful      head     , and *raising* her eyebrows by ---           
    ## [ 59]             --- graceful head, and *raising* her    eyebrows    by a hair's-breadth, as if ---               
    ## [ 60]                  --- *raising* her eyebrows by a hair's-breadth, as if her cousin Feenix ---                 
    ## [ 61]              --- Mr Toots, *raising* his flushed      face     , 'it 's of no consequence' ---               
    ## [ 62]              --- _b_ she answered, *raising* her      head     , and trembling in her energy ---             
    ## [ 63]               --- subject -- when, *raising* her      eyes     , she saw her standing in ---                 
    ## [ 64]               --- brilliant eyes intent upon her      face     , until Florence *raising* her own, ---       
    ## [ 65]          --- _b_ answered Harriet, *raising* her      eyes      to his face, 'I am ---                       
    ## [ 66]         --- moodily, when Harriet, *raising* her      eyes      from the work on which ---                   
    ## [ 67]            --- opposite the house; *raising* her      head      after resting it for a ---                   
    ## [ 68]                    --- _b_ _b_ _b_ *raising* the      hand      she pressed upon her bosom, ---              
    ## [ 69]       --- stiff neckcloth, without *raising* his      eyes      from the table-cloth. As to ---              
    ## [ 70]           --- Dombey bows, without *raising* his      eyes     , and is silent _b_ _b_ ---                   
    ## [ 71]                    --- _b_ _b_ _b_ *Raising* her      eyes      swiftly from their moody gaze ---            
    ## [ 72]                --- last words, and *raising* his      eyes      from the doorpost, said them ---             
    ## [ 73]         --- world, unchanged. *Raising* the same      face      to his, as on that ---                       
    ## [ 74]          --- Mr. Crisparkle, *raising* his right      hand      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 75]            --- said Biddy, quietly *raising* her    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 76]              --- _b_ said Estella, *raising* her      eyes      after a silence _b_ _b_ ---                  
    ## [ 77]             --- windows, I thought, *raising* my      eyes      to them as they rocked, ---                  
    ## [ 78]             --- _b_ Stephen began, *raising* his      eyes      from the floor, after a ---                  
    ## [ 79]                  --- the faithful fulness of her      heart    , and modestly said, *raising* her ---        
    ## [ 80]             --- and modestly said, *raising* her      eyes      appealingly to her new friend ---            
    ## [ 81]            --- cried the landlady, *raising* her      eyes      from her work, opening them ---              
    ## [ 82]                --- One moment; for she recovered     breath     in the act of *raising* ---                  
    ## [ 83]                 --- pale fire, and *raising* her      eyes      again to the face which ---                  
    ## [ 84]                    --- _b_ _b_ _b_ *Raising* his      eyes      thus one day, he was ---                     
    ## [ 85]              --- _b_ she returned, *raising* her      eyes      frankly to his face _b_ ---                  
    ## [ 86]                          --- in a moment had his      hand      at the sash, *raising* it. ---               
    ## [ 87]                  --- the sash, *raising* it. His      eyes      looked so very sinister, as ---              
    ## [ 88]                           --- with a wave of his      hand     , and sobbed out, *raising* his ---           
    ## [ 89]                --- and sobbed out, *raising* his      face      and shaking his melancholy head ---          
    ## [ 90]                     --- _b_ _b_ In *raising* her      eyes      with these words, she observed ---           
    ## [ 91]                --- said Mr Dorrit, *raising* his    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 92]           --- _b_ said Cavalletto, *raising* his      eyes      piously _b_ _b_ _b_ _b_ ---                  
    ## [ 93]             --- said Mrs Sparkler, *raising* her      eyes      to him after another minute ---              
    ## [ 94]                 --- _b_ said Clennam, waving his      hand      without *raising* his sunken head ---        
    ## [ 95]            --- hand without *raising* his sunken      head      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 96]            --- said Little Dorrit, *raising* her      eyes      to his _b_ _b_ _b_ ---                       
    ## [ 97]           --- returned her father, *raising* his      hand      mildly _b_ _b_ _b_ _b_ ---                   
    ## [ 98]                 --- _b_ said Mark, *raising* his    eyebrows    with a look of the ---                       
    ## [ 99]            --- exclaimed the lady, *raising* her      hands     and clasping them _b_ _b_ ---                
    ## [100]             --- cried Mrs Todgers, *raising* her      eyes      and shaking her head _b_ ---                 
    ## [101]              --- _b_ she answered, *raising* her      head      after a short silence, and ---               
    ## [102]             --- Martin, *raising* himself on his      elbow    , and looking angrily at his ---              
    ## [103]             --- the amiable Jonas, *raising* his      eyes      from yesterday 's newspaper _b_ ---          
    ## [104]                 --- _b_ added Tom, *raising* his      eyes      to his benefactor 's face ---                
    ## [105]                   --- and the sun. *Raising* her      eyes      in the expectation of seeing ---             
    ## [106]                      --- act of *raising* to her      lips     , and turned round with a ---                 
    ## [107]                --- cried Mrs Gamp, *raising* her      hands     and turning up her eyes ---                  
    ## [108]             --- *raising* their glasses to their      lips     , when their hands stopped midway, ---        
    ## [109]            --- said his companion, *raising* his      head     , and looking at him, but ---                 
    ## [110]     --- returned Montague, without *raising* his      eyes      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [111]               --- _b_ cried Jonas, *raising* his      head     , and staring at her _b_ ---                  
    ## [112]              --- come, prevent his *raising* his      head      again. _b_ _b_ _b_ _b_ ---                   
    ## [113]                 --- her task: only *raising* her      head      occasionally, to look with unspeakable ---   
    ## [114]           --- Nicholas, *raising* himself on his       arm     , looked among the prostrate forms ---        
    ## [115]            --- _b_ asked Nicholas, *raising* his      eyes      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [116]            --- cried Mrs Crummles, *raising* her      hands     in astonishment _b_ _b_ _b_ ---              
    ## [117]              --- *raising* his wine-glass to his      lips     , and looking round upon his ---              
    ## [118]                --- _b_ said Ralph, *raising* his      eyes      to the schoolmaster 's face ---              
    ## [119]              --- could not forbear *raising* his      eyes      to his face again. Grafted ---               
    ## [120]                --- _b_ said Ralph, *raising* his      eyes      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [121]                 --- _b_ said Kate, *raising* her      face      again _b_ _b_ _b_ _b_ ---                    
    ## [122]             --- _b_ repeated John, *raising* his      eyes      to the ceiling _b_ _b_ ---                   
    ## [123]        --- Mantalini, *raising* himself upon his      elbow     _b_ _b_ _b_ _b_ _b_ ---                      
    ## [124]                   --- covering his eyes with his      hand     , and once more *raising* his ---             
    ## [125]              --- cried old Arthur, *raising* his      hands     and eyes in admiration _b_ ---               
    ## [126]              --- Arthur, *raising* his hands and      eyes      in admiration _b_ _b_ _b_ ---                
    ## [127]              --- cried old Arthur, *raising* his      hands     with an imploring gesture, and ---           
    ## [128]            --- scream, and Newman, *raising* his      eyes     , saw that it had been ---                    
    ## [129]             --- deep sullen gloom. *Raising* his      eyes     , and looking vacantly into this ---          
    ## [130]           --- perfectly still, not *raising* his    frowning    eyes from the ground, and ---                
    ## [131]            --- still, not *raising* his frowning      eyes      from the ground, and covering ---            
    ## [132]                          --- _b_ _b_ _b_ _b_ _b_    hiccuped    Mr Squeers, *raising* his eye ---            
    ## [133]           --- hiccuped Mr Squeers, *raising* his       eye      to the ceiling _b_ _b_ ---                   
    ## [134]                  --- on her chair, *raising* her      eyes      at intervals in mute appeal ---              
    ## [135]             --- _b_ _b_ Frequently *raising* her      eyes      to the trees whence these ---                
    ## [136]                --- said Mr Codlin, *raising* his      head     , and yawning. Then observing that ---        
    ## [137]                   --- *raising* the glass to his      lips      and looking at the dwarf ---                 
    ## [138]                 --- the stout man, *raising* his      eyes      from his cards for the ---                   
    ## [139]           --- he rejoined, *raising* his haggard      face      to hers, and regarding her ---               
    ## [140]           --- cried the governess, *raising* her      eyes      to the sky _b_ _b_ ---                       
    ## [141]               --- the silence, and *raising* his      eyes      to the ceiling with a ---                    
    ## [142]           --- moody silence, often *raising* his      eyes      to Mr Swiveller 's face, ---                 
    ## [143]              --- added the lawyer, *raising* his      eyes      to the ceiling _b_ _b_ ---                   
    ## [144]                --- when the child, *raising* her      head      from the ground over which ---               
    ## [145]            --- cried Mr Swiveller, *raising* his      eyes      to the ceiling _b_ _b_ ---                   
    ## [146]                 --- _b_ cried Kit, *raising* his      eyes      and looking imploringly about him ---        
    ## [147]               --- said Miss Brass, *raising* her      head     , with which she had hitherto ---             
    ## [148]              --- Inspector moved nothing but his      eyes     , as he now added, *raising* ---              
    ## [149]            --- _b_ asked Mortimer, *raising* his    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [150]                    --- _b_ _b_ _b_ *Raising* her      head     , she looks contemptuously in his ---         
    ## [151]               --- said Miss Bella, *raising* her      eyes      from her book, when he ---                   
    ## [152]                --- length he said, *raising* his      eyes      to the master 's face ---                    
    ## [153]                   --- the old man, *raising* his      eyes      from the ground with his ---                 
    ## [154]          --- _b_ exclaimed Eugene, *raising* his      eyes      to the ceiling _b_ _b_ ---                   
    ## [155]                --- _b_ said Bella, *raising* her      eyes      to his, after a little ---                   
    ## [156]                --- _b_ said Bella, *raising* her    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [157]                  --- _b_ she said, *raising* her      eyes      to Bella 's _b_ _b_ ---                      
    ## [158]        --- _b_ Bella involuntarily *raising* her      eyes     , when this sudden reference was ---          
    ## [159]               --- says Mrs Lammle, *raising* her      eyes      to his face again, and ---                   
    ## [160]                 --- knowing way of *raising* his    eyebrows    when their eyes by any ---                   
    ## [161]            --- *raising* his eyebrows when their      eyes      by any chance met, as ---                    
    ## [162]                     --- *raising* his ale to his      lips      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [163]               --- said Mr. Bumble, *raising* his      hands     and eyes with most impressive ---            
    ## [164]              --- Bumble, *raising* his hands and      eyes      with most impressive solemnity _b_ ---       
    ## [165]       --- Mrs. Sowerberry, piously *raising* her      eyes      to the kitchen ceiling _b_ ---               
    ## [166]             --- the old gentleman, *raising* his      hands     instinctively _b_ _b_ _b_ _b_ ---            
    ## [167]               --- _b_ said Oliver, *raising* his      eyes      beseechingly _b_ _b_ _b_ _b_ ---             
    ## [168]            --- looking on, without *raising* his      eyes      from the ground _b_ _b_ ---                  
    ## [169]               --- said the beadle, *raising* his      hand      with a show of authority ---                 
    ## [170]               --- space; and then, *raising* his      head     , and heaving a gentle sign, ---              
    ## [171]               --- echoed the girl, *raising* her      eyes     , and averting them again, the ---            
    ## [172]              --- replied the girl, *raising* her      head      languidly _b_ _b_ _b_ _b_ ---                
    ## [173]               --- down the garden, *raising* his      eyes      every instant to the sick ---                
    ## [174]                  --- and break almost over their      heads    , having subsided, Monks, *raising* his ---   
    ## [175]        --- having subsided, Monks, *raising* his      face      from the table, bent forward ---             
    ## [176]                  --- said the Jew, *raising* his    eyebrows    _b_ _b_ _b_ _b_ _b_ ---                      
    ## [177]                    --- or left, or *raising* his      eyes      to the sky, or lowering ---                  
    ## [178]                           --- a deep gash in her    forehead   ; but *raising* herself, with difficulty, --- 
    ## [179]         --- answered Monks without *raising* his      eyes      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [180]       --- foremost one, *raising* her shrivelled      hand      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [181]               --- Pott, *raising* herself in the      arms      of her attendant _b_ _b_ ---                 
    ## [182]                      --- he was *raising* to his      lips      at the moment, and so ---                    
    ## [183]             --- said Mr. Pickwick, *raising* his      head      and hammering the table _b_ ---              
    ## [184]                      --- he was *raising* to his      lips     , with such exquisite facetiousness, that --- 
    ## [185]                     --- and *raising* him in her      arms      to show him the glistening ---               
    ## [186]                   --- now and then *raising* his      head      to watch the flight of ---                   
    ## [187]              --- green gate, when, *raising* his      eyes     , he beheld a crowd pouring ---               
    ## [188]                  --- said Mrs. W., *raising* her      eyes      to Sam 's face, with ---                     
    ## [189]                --- of his clients; *raising* his      head      from the paper, he said, ---                 
    ## [190]                --- woman than just *raising* his      head      and remarking that she had ---               
    ## [191]                           --- to get upon Sam 's      back     ; and Sam gently *raising* himself ---        
    ## [192]                --- and, *raising* himself on his      elbow    , he took a more lengthened ---               
    ## [193]                         --- once, to draw a long     breath    , but without *raising* his face ---          
    ## [194]            --- breath, but without *raising* his      face      from the vessel, which, in ---               
    ## [195]               --- towards Sam, and *raising* his      hands     and eyes in token of ---                     
    ## [196]                  --- and *raising* his hands and      eyes      in token of the unspeakable ---              
    ## [197]               --- said Mr. Weller, *raising* his      hand      in a deprecatory manner _b_ ---              
    ## [198]                 --- the wall. Soon *raising* his      head      again, he struck twice or ---                
    ## [199]                  --- _b_ she said, *raising* her      hand      to Mr. Lorry as he ---                       
    ## [200]           --- said Madame Defarge, *raising* her    eyebrows    with a cool business air ---                 
    ## [201]            --- Doctor of Beauvais, *raising* his      hand      towards the moon _b_ _b_ ---                 
    ## [202]                    --- nearer to him, laying her      head      upon his breast, and *raising* ---           
    ## [203]                     --- laying her head upon his     breast    , and *raising* her eyes to ---               
    ## [204]                --- his breast, and *raising* her      eyes      to his _b_ _b_ _b_ ---                       
    ## [205]    --- Defarge, inquisitively *raising* her dark    eyebrows   . _b_ _b_ _b_ _b_ _b_ ---

``` r
# opening
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("opening"), context = 0)
y
```

    ## [  1]              --- us again, and *opening* his     arms   , made us sit down side ---                
    ## [  2]     --- returned Miss Jellyby, *opening* her     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [  3]          --- _b_ said Charley, *opening* her     eyes    and smiling _b_ _b_ _b_ ---               
    ## [  4]      --- Jellyby as frequently *opening* his    mouth    after dinner without saying anything. --- 
    ## [  5]        --- says Sir Leicester, *opening* his     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [  6]           --- says Mr. Bucket, *opening* his     arms    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [  7]              --- _b_ _b_ _b_ Approaching the     cell   , they find the door *opening* ---         
    ## [  8]           --- side in silence. *Opening* his     eyes    by and by, he said ---                    
    ## [  9]           --- the trouble of *opening* their     lips    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 10]               --- off, and, by *opening* his     eyes    much wider than usual, to ---             
    ## [ 11]             --- _b_ said John, *opening* his     eyes    wide _b_ _b_ _b_ _b_ ---                  
    ## [ 12]        --- exclaimed his wife, *opening* her     eyes    very wide and looking round ---           
    ## [ 13]         --- _b_ said Gashford, *opening* his     eyes    to their utmost width _b_ ---             
    ## [ 14]             --- 's kitchen, *opening* into a     back    yard; with a pigeon-house on ---          
    ## [ 15]              --- her own), and *opening* her     arms    wide, took my curly head ---              
    ## [ 16]         --- several times, and *opening* her    mouth    as if she were going ---                  
    ## [ 17]                 --- _b_ said I, *opening* my     eyes   . For this was a new ---                   
    ## [ 18]           --- preventing the spring with his    thumb    from *opening* far, looked in ---         
    ## [ 19]           --- Mr. Barkis, *opening* both his     eyes    as wide as he possibly ---                
    ## [ 20]      --- eyes, and disdainfully inclined her     head   ; then, slowly *opening* her eyes, ---     
    ## [ 21]         --- head; then, slowly *opening* her     eyes   , resumed _b_ _b_ _b_ _b_ ---              
    ## [ 22]             --- of Mrs. Micawber washing her    hands   , and hurriedly *opening* and shutting --- 
    ## [ 23]         --- _b_ said Traddles, *opening* his     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 24]      --- Murdstone opened it - *opening* her    mouth    a little at the same ---                  
    ## [ 25]        --- _b_ exclaimed Dora, *opening* her     eyes    wide _b_ _b_ _b_ _b_ ---                  
    ## [ 26]     --- _b_ rejoined Traddles, *opening* his     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 27]        --- _b_ cried Traddles, *opening* his     eyes    in his old way _b_ ---                    
    ## [ 28]            --- began to sound. *Opening* his     eyes   , he found that it was ---                 
    ## [ 29]           --- the Commander, getting off the    chest   , and *opening* the lid _b_ ---            
    ## [ 30]       --- when Florence, *opening* her heavy     eyes   , lay at first, looking without ---        
    ## [ 31]               --- and sofas with their dirty    fists   , touzling the feather beds, *opening* --- 
    ## [ 32]            --- paper with a prettily knitted     brow   , but not *opening* it _b_ ---             
    ## [ 33]   --- alternately *opening* and shutting the    palms    of his hands as he ---                    
    ## [ 34]               --- now, *opening* the door to     spit    stiffly over their high stocks, ---       
    ## [ 35]            --- cried Joe, *opening* his blue     eyes    wide _b_ _b_ _b_ _b_ ---                  
    ## [ 36]                 --- smile on my *opening* my     eyes   , and said _b_ _b_ _b_ ---                 
    ## [ 37]          --- _b_ said Estella, *opening* her    hands    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 38]              --- and out, *opening* more red     eyes    in the gathering fog than ---             
    ## [ 39]            --- until the last. *Opening* his     arms    wide he took her by ---                   
    ## [ 40]        --- _b_ said Bounderby, *opening* his     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 41]          --- cried the landlady, raising her     eyes    from her work, *opening* them ---         
    ## [ 42]           --- said Mr Meagles, *opening* his     eyes    with a fresh discovery _b_ ---            
    ## [ 43]           --- was *opening* and shutting his    hands    like valves; so conscious all ---         
    ## [ 44]      --- Packed their purchases in solitude.    Fanny    *opening* her reticule, as they ---       
    ## [ 45]         --- so. Edward, beyond *opening* his    mouth    in amazement, had not opened ---          
    ## [ 46]   --- spontaneous affections of his daughter    Fanny   , and as *opening* a family ---            
    ## [ 47]              --- the better *opening* of her     eyes   , tell her what had passed ---             
    ## [ 48]               --- you mean by *opening* your     eyes    so wide at me, but ---                    
    ## [ 49]       --- Mercy concurred in *opening* their     eyes    uncommonly wide at this announcement, --- 
    ## [ 50]                   --- as was conveyed in his  breathing  very hard, and *opening* his ---          
    ## [ 51]             --- very hard, and *opening* his     eyes    very wide, and nodding his ---            
    ## [ 52]                --- _b_ _b_ _b_ *opening* his     eyes    wide, and standing on tiptoe ---          
    ## [ 53]       --- from the background, *opening* her     eyes    very wide, and shaking her ---            
    ## [ 54]           --- said the barber, *opening* his     eyes   , and putting on his raven ---             
    ## [ 55]                --- very act of *opening* his     eyes    indolently, he nodded again. In ---       
    ## [ 56]         --- _b_ Mark inquired, *opening* his     eyes    still wider _b_ _b_ _b_ ---               
    ## [ 57]          --- an involuntary *opening* of his     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 58]         --- his intention, and *opening* his     lips    to speak again, Jonas set ---             
    ## [ 59]             --- looked forward, with a heavy    heart   , to the *opening* of her ---              
    ## [ 60]          --- his seat, without *opening* his     lips    in reply. Squeers, casting a ---          
    ## [ 61]      --- asked Mrs Wititterly, *opening* her     eyes    for an instant, and shutting ---          
    ## [ 62]                --- the view of *opening* the    chest    and strengthening the muscles of ---      
    ## [ 63]    --- exclaimed Mr Mantalini, *opening* his     eyes    at the sound of Ralph ---                 
    ## [ 64]             --- the table, and *opening* his     eyes    to their full width. _b_ ---              
    ## [ 65]                   --- took the mug under his     arm    , and *opening* his eyes very ---          
    ## [ 66]               --- his arm, and *opening* his     eyes    very wide, looked on, in ---              
    ## [ 67]                 --- Mr Bray, putting out his     hand   , and *opening* and shutting his ---       
    ## [ 68]          --- *opening* and shutting his bony   fingers   with irritable impatience _b_ _b_ ---     
    ## [ 69]         --- said Mrs Nickleby, *opening* her     eyes    in great astonishment. _b_ _b_ ---        
    ## [ 70]          --- door himself, and *opening* his     eyes    too to their utmost width, ---            
    ## [ 71]              --- _b_ Once more *opening* his    mouth    and shutting his eyes, and ---            
    ## [ 72]       --- Quilp, stretching out his clenched     hand    and *opening* it as if ---                
    ## [ 73]            --- the sick child, *opening* his     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 74]                  --- a fur cap *opening* his     eyes    and looking wild and stupefied ---        
    ## [ 75]      --- charming creature was *opening* her     lips    to speak in reply, when ---               
    ## [ 76]                --- _b_ _b_ _b_ *Opening* her     eyes    at last, from a very ---                  
    ## [ 77]             --- pipe and looked with beaming     eyes    into the *opening* world before ---       
    ## [ 78]          --- _b_ she repeated, *opening* her     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 79]                 --- of hot tea, shutting his     eyes    at every gulp, and *opening* ---          
    ## [ 80]               --- shutting his eyes at every     gulp   , and *opening* them again in ---          
    ## [ 81]                --- _b_ _b_ _b_ *Opening* her     eyes    again, and seeing her husband ---         
    ## [ 82]       --- *opening* and closing Georgiana 's     arms    like a pair of compasses, ---             
    ## [ 83]       --- himself; and without *opening* his     eyes    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 84]           --- the horse. *Opening* his heavy     eyes   , he slowly broke into a ---               
    ## [ 85]           --- the experiment of shutting her     eyes    and *opening* them again, still ---       
    ## [ 86]        --- point, knowingly shutting a green     eye     and *opening* a red one, ---              
    ## [ 87]        --- knowingly shutting up their green     eyes    and *opening* their red ones ---          
    ## [ 88]              --- *opening* it wider, and the spluttering continuing, she took the liberry ---      
    ## [ 89]            --- Here, Mr Sloppy *opening* his    mouth    to a quite alarming extent, ---           
    ## [ 90]         --- walked, with the same meditative     face   , into a back anteroom *opening* ---       
    ## [ 91]             --- same meditative face, into a     back    anteroom *opening* from the yard; ---     
    ## [ 92]                 --- keeping his stick in his     hand   , he sat down; and, *opening* ---          
    ## [ 93]                 --- seizing the poker in one     hand   , and deliberately *opening* with the ---  
    ## [ 94] --- unfortunately, Charley, in *opening* his    mouth    to reply that he was ---                  
    ## [ 95]                 --- she kissed the robber 's     lips   ; and then *opening* and closing ---       
    ## [ 96]                --- for the Jew *opening* his     eyes    so wide; but as he ---                    
    ## [ 97]              --- very point of *opening* his    mouth    for the reception of a ---                
    ## [ 98]             --- Mr. Tupman, on *opening* his     eyes   , beheld a plump partridge in ---          
    ## [ 99]                   --- old blots, when he was    roused   by the *opening* of the ---               
    ## [100]    --- replied Master Bardell, *opening* his     eyes    very wide as he delivered ---             
    ## [101]            --- the desk with his contentious     hand   , *opening* his eyes wider, and ---        
    ## [102]      --- his contentious hand, *opening* his     eyes    wider, and taking a long ---

``` r
# looking
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("looking"), context = 0)
y
```

    ## [  1]                           --- and I saw in her      face    , *looking* gloomily at me _b_ ---                 
    ## [  2]                       --- put her arm about my      neck     as I stood *looking* at ---                       
    ## [  3]                    --- ink stains on her face,    frowning   the whole time and *looking* ---                  
    ## [  4]            --- stood *looking* in, that yonder     bones     in a corner, piled together ---                   
    ## [  5]                   --- then *looking* up in his      face    , boldly said _b_ _b_ _b_ ---                      
    ## [  6]               --- eye becomes conscious of the      head     of Mrs. Snagsby *looking* in ---                  
    ## [  7]         --- law-stationer. Mr. Krook, with his     mouth     open, *looking* for somebody to ---               
    ## [  8]                    --- and woe depicted in his      face    , *looking* up at me. I ---                        
    ## [  9]                   --- carpet behind one of the      legs     of the piano, *looking* calmly ---                
    ## [ 10]              --- stood panting, and wiping her      arms    , and *looking* quietly at us ---                  
    ## [ 11]               --- child, *looking* up into his      face     with perfect confidence _b_ _b_ ---               
    ## [ 12]         --- whisper without *looking* over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 13]                 --- upon his shoulders -- both     hands     now -- and *looking* up ---                       
    ## [ 14]                  --- and *looking* up into his      face    , like the picture of truth ---                    
    ## [ 15]           --- unnoticed, *looking* on with her      lips     very tightly set _b_ _b_ ---                      
    ## [ 16]                --- there he sits, munching and    gnawing   , and *looking* up at the ---                      
    ## [ 17]                         --- his fur cap on his      head     and *looking* keenly at them ---                  
    ## [ 18]            --- good *looking*, with crisp dark      hair    , bright eyes, and a broad ---                     
    ## [ 19]                   --- a lowering energy in her      face     as she stood *looking* at ---                     
    ## [ 20]                    --- his arms upon his broad     chest     and *looking* very large _b_ ---                  
    ## [ 21]                   --- the other resting on his      leg     , *looking* in a brown study ---                   
    ## [ 22]             --- George, *looking* hard at him,      bit      his lip and shook his ---                         
    ## [ 23]        --- Wintry morning, *looking* with dull      eyes     and sallow face upon the ---                      
    ## [ 24]           --- Mr. George, returning, folds his      arms    , and *looking* down at the ---                    
    ## [ 25]          --- 's purchase, with those beautiful      eyes     *looking* at you as they ---                      
    ## [ 26]                       --- used to sit with her     hands     folded in each other *looking* ---                
    ## [ 27]                     --- first knew her and her      hair     *looking* like the mane of ---                    
    ## [ 28]          --- guardian, *looking* back over his    shoulder   half angrily; only half angrily, ---              
    ## [ 29]               --- and after *looking* over his    shoulder  , appears to yield himself up ---                  
    ## [ 30]              --- any sky without craning their     necks     and *looking* up, but lights ---                  
    ## [ 31]                        --- _b_ _b_ _b_ _b_ _b_     gasps     Mr. Smallweed, *looking* about him, ---           
    ## [ 32]        --- Mr. Smallweed, *looking* about him,   breathless , from an arm-chair _b_ _b_ ---                    
    ## [ 33] --- companions, therefore, her honest sunburnt      face     *looking* cheerily out of a ---                   
    ## [ 34]                --- sleeve and *looking* in his      face    , told him how much I ---                          
    ## [ 35]                  --- lips tightly shut and her      eyes     *looking* out at him sideways, ---                
    ## [ 36]          --- says Mr. Tulkinghorn, tapping his      chin     with the key and *looking* ---                    
    ## [ 37]                      --- _b_ _b_ He folded his      arms     and sat *looking* at me ---                       
    ## [ 38]                --- holding me lightly with his      arm     , and *looking* down into my ---                   
    ## [ 39]                 --- and *looking* down into my      face     with the same genuine freshness ---               
    ## [ 40]                      --- on the table and went       to      bed, and I sat *looking* ---                      
    ## [ 41]                      --- the table and went to      bed     , and I sat *looking* at ---                       
    ## [ 42]                       --- I saw his worn young      face     *looking* at me as if ---                         
    ## [ 43]                 --- her. *Looking* down at her      face    , his eye meets hers, and ---                      
    ## [ 44]                  --- it, when he hears running      feet     behind him, and *looking* round, ---              
    ## [ 45]                     --- gulp the coffee and to      gnaw     the bread and butter, *looking* ---               
    ## [ 46]                      --- _b_ _b_ And Jo stands   shivering   and *looking* at the breakfast ---                
    ## [ 47]                 --- standing at the trooper 's     elbow     and *looking* up, with an ---                     
    ## [ 48]                 --- in her nature when envious      eyes     are *looking* on to yield ---                     
    ## [ 49]           --- *looking* up at his outstretched      hand     and *looking* down at what ---                    
    ## [ 50]                        --- was to sit with his      head     against the wall, *looking* hard ---              
    ## [ 51]                   --- *looking* at us over his    shoulder   as he went his way ---                            
    ## [ 52]               --- says Mr. Bucket, warming his     hands     and *looking* pleasantly at the ---               
    ## [ 53]                   --- before the fire with his     finger    on his chin, *looking* at ---                     
    ## [ 54]                     --- with his finger on his      chin    , *looking* at the blazing coals. ---              
    ## [ 55]                 --- his chair and grasping the     elbows   , sits *looking* at him with ---                   
    ## [ 56]               --- but stood faltering with her      hand     upon its broken back, *looking* ---               
    ## [ 57]                   --- her hand upon its broken      back    , *looking* at me. I thought ---                   
    ## [ 58]                   --- _b_ _b_ He withdraws his      hand     and falls to *looking* at ---                     
    ## [ 59]                    --- that he expects. In the      ears     of his old servant, *looking* ---                 
    ## [ 60]                       --- as that and lays his      head     down without *looking* for an ---                 
    ## [ 61]              --- says the trooper, folding his      arms     and *looking* with indomitable firmness ---       
    ## [ 62]                  --- old man, bending over the      body     and *looking* round as he ---                     
    ## [ 63]                      --- _b_ _b_ _b_ _b_ Quite  unconscious  that his master was *looking* ---                 
    ## [ 64]            --- _b_ said Gabriel, elevating his    eyebrows   and *looking* disappointed _b_ _b_ ---            
    ## [ 65]                    --- one side to scratch his      head     with greater ease, and *looking* ---              
    ## [ 66]            --- said the locksmith, shaking his      head    , and *looking* from one to ---                    
    ## [ 67]         --- Varden, *looking* sternly over her    shoulder   at Miss Miggs in waiting ---                      
    ## [ 68]              --- _b_ _b_ _b_ murmured Gabriel,     waking    at the noise, and *looking* ---                   
    ## [ 69]          --- Barnaby, *looking* close into his      face    , and falling quickly back _b_ ---                 
    ## [ 70]                        --- tramp of a horse 's      feet     behind him, and *looking* back, ---               
    ## [ 71]               --- trees, and *looking*, at the      back    , upon the Temple Gardens -- ---                   
    ## [ 72]            --- exclaimed his wife, opening her      eyes     very wide and *looking* round ---                 
    ## [ 73]                   --- a woman before him whose      head     by long and steady *looking* ---                  
    ## [ 74]                  --- Hugh accepted it from his      hand    , and *looking* stealthily at his ---              
    ## [ 75]        --- *looking* stealthily at his smiling      face    , drank the contents in silence ---                
    ## [ 76]                --- *looking* up with a flushed      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 77]                  --- said John, drawing a long     breath   , and *looking* round him like ---                 
    ## [ 78]                 --- *looking* into John 's fat      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 79]                   --- taking them out again to      bite     his nails, and *looking* uncomfortably ---        
    ## [ 80]              --- said Lord George, rubbing his      eyes     and *looking* round the room ---                  
    ## [ 81]             --- said Mr Tappertit, rubbing his      palm     upon his legs, and *looking* ---                  
    ## [ 82]                  --- rubbing his palm upon his      legs    , and *looking* at it between ---                  
    ## [ 83]             --- these articles with a laughing      eye     , and *looking* at them with ---                   
    ## [ 84]                 --- *looking* at them with his      head     a little on one side, ---                         
    ## [ 85]               --- round his pretty daughter 's     waist    , *looking* lovingly on Mrs V., ---                
    ## [ 86]             --- Dennis, after *looking* at his      face     to assure himself that he ---                     
    ## [ 87]         --- said Barnaby, resting with crossed      arms     on his spade, and *looking* ---                   
    ## [ 88]               --- and *looking* eagerly in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 89]                  --- along the street -- often    panting    and *looking* back -- and ---                     
    ## [ 90]          --- returned his friend, dropping his      hand    , and *looking* at Gashford for ---                
    ## [ 91]                         --- back of one on the      palm     of the other, and *looking* ---                   
    ## [ 92]              --- that Hugh, *looking* over his    shoulder   and angrily down upon him, ---                    
    ## [ 93]                   --- dark lane, where a small      body     of ill- *looking* vagabonds, whom ---             
    ## [ 94]          --- the convenience of scratching his      head    , and *looking* gravely at Hugh ---                
    ## [ 95]                --- *looking* at them, that his     brain     was affected by the agitation ---                 
    ## [ 96]                 --- for her footsteps in every     breath    of air, *looking* for her ---                     
    ## [ 97]               --- *looking* at the stars, fell      fast     asleep. _b_ _b_ _b_ _b_ ---                       
    ## [ 98]               --- _b_ cried Miggs, folding her     hands     and *looking* upwards with a ---                  
    ## [ 99]               --- deeming it possible that his      arm      might be there; *looking* at ---                  
    ## [100]                --- there; *looking* at his own      arms     and those of everybody else, ---                  
    ## [101]               --- held her handkerchief to her      eyes    . Joe still stood, *looking* at ---                
    ## [102]                --- _b_ she cried, clasping her     hands    , and *looking* upward _b_ _b_ ---                 
    ## [103]              --- cried Hugh, raising his right      arm      aloft, and *looking* upward like ---              
    ## [104]                      --- hand upon his sire 's    shoulder  , and *looking* down into his ---                  
    ## [105]                --- and *looking* down into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [106]                  --- and with such a trembling      hand    , that the messenger stood *looking* ---           
    ## [107]                --- *looking* at it through her     tears    , and desponding heavily about herself ---         
    ## [108]                  --- and that with no ungentle      hand    ; but, *looking* at her, in ---                    
    ## [109]                  --- of him without turning my      head     sometimes, and *looking* up in ---                
    ## [110]                    --- and *looking* up in his      face    . He had that kind of ---                          
    ## [111]                 --- the sill, by turns crying,     dozing   , and *looking* listlessly out), when ---          
    ## [112]                  --- *looking* at the horse 's      ears    , as if he saw something ---                       
    ## [113]                  --- *looking* at the horse 's      ears     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [114]             --- said Mr. Creakle, striking his      hand     upon the table, and *looking* ---                 
    ## [115]                  --- hand she held against her      neck    . Her eyes were *looking* down ---                 
    ## [116]                 --- held against her neck. Her      eyes     were *looking* down upon its ---                  
    ## [117]               --- were *looking* down upon its      face    , and she sat singing to ---                       
    ## [118]                       --- with her chin on the      foot     of the stocking, *looking* silently ---           
    ## [119]                  --- had been *looking* at its      eyes     as it lay upon her ---                            
    ## [120]                 --- course I looked, shook his      head     without *looking* at me, and ---                  
    ## [121]               --- Minnie *looking* on, and her      eye      glancing on her sweetheart, who ---               
    ## [122]                --- have stood *looking* in his      face     for an hour, and most ---                         
    ## [123]                         --- and I saw her blue      eyes     *looking* bluer, and her dimpled ---              
    ## [124]           --- *looking* bluer, and her dimpled      face     *looking* brighter, and her whole ---             
    ## [125]                --- desk. Mr. Quinion, with his     hands     in his pockets, stood *looking* ---               
    ## [126]                 --- Steerforth 's name upon my      lips    , *looking* wildly at the stars ---                
    ## [127]          --- returned Mr. Dick, scratching his      ear      with his pen, and *looking* ---                   
    ## [128]                       --- to Mr. Dick, who was     biting    his forefinger and *looking* rather ---           
    ## [129]                    --- her hands folded on one      knee    , and *looking* grimly on the ---                  
    ## [130]           --- but *looking* much older - whose      hair     was cropped as close as ---                       
    ## [131]                  --- pony 's head, rubbing his      chin     with it, and *looking* up ---                     
    ## [132]             --- placid and sweet expression of      face    , who was *looking* at me. ---                     
    ## [133]                    --- seen Uriah Heep 's pale      face     *looking* out of the window. ---                  
    ## [134]                      --- and seeing one of the     faces     on the beam-ends *looking* at ---                 
    ## [135]             --- *looking* after him with their     heads     cocked slyly, as if they ---                      
    ## [136]                   --- her curls aside with his      hand    , and said, *looking* around _b_ ---               
    ## [137]                --- pegtop, *looking* on with a      face     of unutterable interest, and hardly ---           
    ## [138]                 --- stood *looking* him in the      face     in the street. But I ---                          
    ## [139]              --- said the Doctor, stroking his      face    , and *looking* penitently at his ---              
    ## [140]              --- stopped, and, *looking* in my      face    , said _b_ _b_ _b_ _b_ ---                         
    ## [141]                    --- as he stood leaning his      head     upon his hand, and *looking* ---                  
    ## [142]                  --- leaning his head upon his      hand    , and *looking* gloomily down at ---               
    ## [143]            --- he returned, *looking* over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [144]                   --- with her arms around her      neck    , kneeled by her, *looking* up ---                 
    ## [145]                   --- *looking* me full in the      face     all the while; and then ---                       
    ## [146]             --- work, and replied, folding her     hands     upon one another, and *looking* ---               
    ## [147]               --- with his shadowless eyes and   cadaverous  face, to be *looking* gauntly ---                 
    ## [148]         --- his shadowless eyes and cadaverous      face    , to be *looking* gauntly down ---                 
    ## [149]                    --- that carved grin on his      face    , *looking* at the fire, as ---                    
    ## [150]                   --- of Agnes with her tender      eyes    , and of her father *looking* ---                  
    ## [151]                   --- in the brightness of her      eyes    , as she said, *looking* fixedly ---               
    ## [152]               --- _b_ he rejoined, shaking his      head    , and *looking* very much dejected ---             
    ## [153]                --- his sleeve, and shaking her      head    . After *looking* at Mrs. Gummidge ---             
    ## [154]                     --- it had sprung from his     mouth    , I think), *looking* fixedly at ---               
    ## [155]             --- *looking* wistfully up into my      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [156]             --- instant; and said, turning his      head     towards me, but *looking* at ---                  
    ## [157]                    --- me, but *looking* at my      feet     instead of my face _b_ ---                        
    ## [158]                --- Agnes, *looking* up into my      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [159]               --- think, *looking* on her mild      eyes     and her radiant forehead, how ---                 
    ## [160]                        --- _b_ _b_ _b_ _b_ Her      head     was bent down, *looking* at ---                   
    ## [161]                    --- I glanced at the serene      face     *looking* upward, and thought it ---              
    ## [162]                       --- Of our going, arm in      arm     , and Dora stopping and *looking* ---              
    ## [163]                       --- head, I saw her blue      eyes     *looking* at me with the ---                      
    ## [164]          --- *looking* up, tearfully, into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [165]               --- said she, *looking* over her    shoulder   at me with the same ---                           
    ## [166]                 --- the placid veil before her      face    , through which she sat *looking* ---              
    ## [167]         --- when, having gradually removed his      eyes     from mine, he sat *looking* ---                   
    ## [168]        --- sat *looking* downward, leaning his    forehead   on his hand. He offered ---                       
    ## [169]                  --- *looking* at me, with her     hands     folded, and a most resigned ---                   
    ## [170]             --- *looking* fondly back over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [171]                 --- head thrown back, her pale      face     *looking* upward, her hands wildly ---            
    ## [172]            --- pale face *looking* upward, her     hands     wildly clasped and held out, ---                  
    ## [173]                      --- air. As she now stood    panting   , *looking* at her with the ---                    
    ## [174]                       --- with a basket on her      knee    , was seated, *looking* at Mr. ---                 
    ## [175]                --- said Dora, putting back her      hair    , and *looking* wonderingly at my ---              
    ## [176]                      --- the lower part of his      face    , and some *looking* at us ---                     
    ## [177]                  --- his table with his sullen      face     *looking* down. _b_ _b_ _b_ ---                   
    ## [178]                      --- and of my own haggard      face     *looking* in at me from ---                       
    ## [179]                        --- with the key in her      hand    ; and *looking* earnestly at me ---                
    ## [180]                    --- trick of casting up his      eye      at the sky as *looking* ---                       
    ## [181]                   --- _b_ and softly patted my      hand     again, as I sat *looking* ---                     
    ## [182]                   --- so soon *looking* on her      face     again. _b_ _b_ _b_ _b_ ---                        
    ## [183]             --- believe that, *looking* at the      face     beside him _b_ _b_ _b_ ---                        
    ## [184]                         --- to the door of his      cell    ; and Mr. Creakle, *looking* through ---           
    ## [185]               --- tone, and *looking* over his    shoulder   as we walked along the ---                        
    ## [186]                       --- to see my own infant      face    , *looking* up at me from ---                      
    ## [187]            --- she (*looking* another way, and  unconscious  of his intention) held straight ---               
    ## [188]              --- the woman, *looking* into her      eyes    , that she was fain to ---                         
    ## [189]                      --- stool at the Nurse 's      feet    , *looking* up into her face ---                   
    ## [190]                --- feet, *looking* up into her      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [191]              --- *looking* earnestly up in her      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [192]                   --- arms, and screwed up her     mouth    , and sat *looking* at the ---                     
    ## [193]             --- after often *looking* over her    shoulder  , and often going a little ---                     
    ## [194]           --- and *looking* attentively in her      face    , rejoined _b_ _b_ _b_ _b_ ---                     
    ## [195]        --- Dombey, *looking* slightly over his    shoulder   at that lady, who wept ---                        
    ## [196]                    --- his chin resting on his      hand    , still cogitating and *looking* for ---           
    ## [197]              --- said little Paul, warming his     hands    , and *looking* in between the ---                 
    ## [198]                    --- at her, and warming his     hands    , and *looking* at her, until ---                  
    ## [199]        --- answered, *looking* steadily in her      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [200]              --- never once *looking* over his    shoulder  , pretended, as soon as they ---                   
    ## [201]                --- Paul, *looking* up into his      face     -- Mr Toots started, and ---                      
    ## [202]                    --- *looking* on with a red      eye      at these mysteries of the ---                     
    ## [203]                       --- to the fire, and his     hands     under his coat-tails, *looking* over ---          
    ## [204]                       --- in bed all that day,     dozing    and dreaming, and *looking* at ---                
    ## [205]             --- he whispered, *looking* in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [206]                      --- to revolve in his own     bosom    , while he sat *looking* at ---                    
    ## [207]                   --- head and rubbings of his     hands    , that Solomon, *looking* first at ---             
    ## [208]           --- *looking* on the beautiful young      face     that had so long, so ---                          
    ## [209]                 --- *looking* in her father 's      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [210]                    --- of his tether, with his      head     towards her: and *looking* lazily ---             
    ## [211]             --- Florence *looking* up into his      face     half timidly, and receiving the ---               
    ## [212]            --- something pensive in the bright      eyes     *looking* at him arrested his ---                 
    ## [213]                      --- _b_ _b_ _b_ The sweet      face     *looking* into his, the gentle ---                
    ## [214]             --- and *looking* anxiously in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [215]                        --- when he saw a faded      face     he knew, *looking* in at ---                      
    ## [216]       --- carriage, and *looking* with knitted     brows     at the changing objects without, ---              
    ## [217]                    --- effect of her bare lean      arm     , *looking* upward from the wrist ---              
    ## [218]             --- arm, *looking* upward from the     wrist     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [219]                --- soft hand playing round his     mouth    , and *looking* up into the ---                    
    ## [220]                    --- to make out the pensive      face     behind the curtain *looking* at ---               
    ## [221]                      --- _b_ _b_ He raised his      head     quickly, and *looking* towards the ---            
    ## [222]                    --- her face resting on her      hand    , sat *looking* out, and hardly ---                
    ## [223]          --- hurriedly, and *looking* into her      face     with great earnestness _b_ _b_ ---                
    ## [224]    --- said, *looking* meanwhile with elevated    eyebrows   at the carpet _b_ _b_ ---                         
    ## [225]            --- down: Florence *looking* in her      face    , quite wondering at its beauty, ---               
    ## [226]            --- the visitor, *looking* over his    shoulder   compassionately at his own legs, ---              
    ## [227]              --- The Captain stood rubbing his      chin    , and *looking* at the Manager. ---                
    ## [228]                   --- *looking* with as sad an      eye      upon the ground, as if ---                        
    ## [229]              --- *looking* after him, with her     hands     loosely clasped in each other, ---                
    ## [230]                     --- sat drying it with the     palms     of her hands, and *looking* ---                   
    ## [231]                      --- with the palms of her     hands    , and *looking* at the blaze ---                   
    ## [232]               --- she said, *looking* over her    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [233]                --- mother, *looking* up in her      face    , and still holding to her ---                     
    ## [234]           --- Dombey, *looking* round over his    shoulder  ; you can come and go ---                          
    ## [235]                --- was *looking* out, with her      back     turned on the toilet of ---                       
    ## [236]                  --- the Captain, in a violent  perspiration, stood meekly *looking* at Mrs ---                
    ## [237]                    --- -- that she melted into     tears    , after *looking* upon him for ---                 
    ## [238]                  --- *looking* up, she put her      arm      round the neck of her ---                         
    ## [239]                   --- since she came down. The     sleep     she had been *looking* on, ---                    
    ## [240]                 --- Mr Dombey, raised upon his      arm      and *looking* at her, offered ---                 
    ## [241]       --- *looking* straight into her kindling      eyes     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [242]               --- *looking* back to mumble and     mouth     at her daughter, who followed, ---                
    ## [243]                 --- _b_ _b_ *looking* over her    shoulder   --'she 's my gal, Rob ---                         
    ## [244]                 --- the hand that embraced her      neck    , and *looking* into the eyes ---                  
    ## [245]               --- neck, and *looking* into the      eyes     that looked into hers so ---                      
    ## [246]         --- Captain, *looking* intently in her      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [247]           --- when Florence, opening her heavy      eyes    , lay at first, *looking* without ---              
    ## [248]         --- Captain, *looking* at her drooping      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [249]                     --- sight to see his great      face     *looking* in from time to ---                     
    ## [250]      --- timidly and thoughtfully withdrew her      hand    ; still *looking* at him with ---                  
    ## [251]              --- said, *looking* down into his      face    : _b_ _b_ _b_ _b_ _b_ ---                          
    ## [252]              --- _b_ inquires the Major, after    gasping    and *looking* at him, for ---                     
    ## [253]               --- woman, *looking* up into his      face    , and nodding _b_ _b_ _b_ ---                      
    ## [254]               --- and *looking* close into his      face    , with her sharp eyes _b_ ---                      
    ## [255]                  --- near the window, with her      head     upon her hand, *looking* down, ---                
    ## [256]                     --- with her head upon her      hand    , *looking* down, when, sensible of ---            
    ## [257]                 --- _b_ said Alice, laying her      hand     upon her arm' and *looking* ---                   
    ## [258]                  --- arm' and *looking* in her      face    , 'but that the answer is ---                      
    ## [259]                       --- with the lamp in his      hand    , *looking* at her, as if ---                      
    ## [260]                 --- was unable to conceal; and     biting    his nail nervously, and *looking* ---             
    ## [261]             --- the driver, *looking* over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [262]                    --- with the fingers of one      hand     on the table, *looking* wistfully ---             
    ## [263]            --- Pipchin, *looking* with a fiery      eye      over the intermediate heads _b_ ---               
    ## [264]       --- clustering loosely round its tearful      face    ; and *looking* back at him. ---                   
    ## [265]             --- from the dressing-table in its     breast   . Now, it was *looking* at ---                     
    ## [266]                     --- muses, as he turns her      face     towards him, and stands *looking* ---             
    ## [267]              --- sympathetic hand on Jasper 's      knee    , and *looking* at him with ---                    
    ## [268]                --- *looking* into the other 's      eyes    , and as the uncle holds ---                       
    ## [269]         --- repeats Jasper, *looking* over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [270]                        --- as she sat with her      head     on one side, *looking* abstractedly ---           
    ## [271]            --- former, *looking* back over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [272]                --- a masterly manner, and, not    breathed   even then, stood *looking* down ---               
    ## [273]                  --- and smoothed his head and      face    , might have been seen *looking* ---               
    ## [274]                 --- *looking* at the fire, and      bit      his lip _b_ _b_ _b_ ---                           
    ## [275]                      --- _b_ _b_ Edwin bit his      lip      again, and still sat *looking* ---                
    ## [276]                       --- in the action of his      hand    , as Mr. Grewgious, *looking* steadfastly ---      
    ## [277]                       --- likes to see a stray      face     or two *looking* in through ---                   
    ## [278]             --- _b_ Mr. Grewgious smoothed his      head     and face, and stood *looking* ---                 
    ## [279]            --- Grewgious smoothed his head and      face    , and stood *looking* at the ---                   
    ## [280]             --- of Mr. Grewgious smoothing his      head     again, and again *looking* at ---                 
    ## [281]                       --- laid a hand upon his    shoulder  , and stood *looking* down at ---                  
    ## [282]                       --- each on the other 's   shoulders  , and *looking* joyfully each into ---             
    ## [283]              --- After darkly *looking* at his      leg      and me several times, he ---                      
    ## [284]                  --- *looking* at him with his      arms     folded _b_ _b_ _b_ _b_ ---                        
    ## [285]               --- long afterwards. I turned my      eyes     - a little dimmed by *looking* ---                
    ## [286]                   --- of her stick against her     heart     as she stood *looking* at ---                     
    ## [287]               --- commonest, should lift up my      eyes     and see Estella *looking* in ---                  
    ## [288]                          --- on my knee and my      face     upon my hand, *looking* into ---                  
    ## [289]                        --- and my face upon my      hand    , *looking* into the fire, as ---                  
    ## [290] --- this expressive pockethandkerchief in both     hands    , and was *looking* at us. ---                     
    ## [291]         --- *looking* silently at her downcast      eyes     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [292]                --- said he, *looking* over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [293]                       --- his arms, and take a   shivering   turn across the room, *looking* ---               
    ## [294]                      --- with my hand upon the      back     of it, *looking* wildly at ---                    
    ## [295]               --- *looking* up at his furrowed      bald     head with its iron grey ---                       
    ## [296]               --- *looking* round the room and    snapping   his fingers once with a ---                       
    ## [297]                --- fountain, I saw his lighted      back     windows *looking* bright and quiet, ---           
    ## [298]                          --- back when I saw a      face     *looking* at me, and a ---                        
    ## [299]                     --- *looking* at me, and a      hand     waving to me, from a ---                          
    ## [300]               --- said she, assenting with her      head    , but not *looking* at me ---                      
    ## [301]                       --- _b_ It rose under my      hand    , and the door yielded. *Looking* ---              
    ## [302]               --- the girl, *looking* over her    shoulder  , to assure herself that her ---                   
    ## [303]                  --- table, and stand with his      back     to the fire, *looking* at ---                     
    ## [304]             --- *looking* at the pretty modest      head    , as it drooped abashed before ---                 
    ## [305]                  --- still ambling on with her      foot     in her stirrup, *looking* quite ---               
    ## [306]                         --- he held her in his      arms    , *looking* at her in his ---                      
    ## [307]                   --- hand upon her brother 's    shoulder  , Louisa still stood *looking* at ---              
    ## [308]                     --- Tom said this with one      eye      shut up again, and *looking* ---                  
    ## [309]                    --- face, and not too sober      eyes    , towards the face *looking* down ---              
    ## [310]                --- too sober eyes, towards the      face     *looking* down upon him so ---                    
    ## [311]                --- close together: she, with a      hand     upon his shoulder, *looking* fixedly ---          
    ## [312]                       --- with a hand upon his    shoulder  , *looking* fixedly in his face ---                
    ## [313]         --- shoulder, *looking* fixedly in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [314]                  --- other hand upon his other    shoulder  , and still *looking* fixedly in ---               
    ## [315]             --- still *looking* fixedly in his      face    , went on _b_ _b_ _b_ ---                          
    ## [316]                       --- all, when he saw the      face     now *looking* at him. He ---                      
    ## [317]            --- *looking* up, and laughing, and    frowning  , and walking off, and walking ---                 
    ## [318]                      --- As he leaned upon his      hand     again, *looking* gray and old, ---                
    ## [319]               --- time the pale, worn, patient      face     was seen *looking* up at ---                      
    ## [320]                    --- on the house) about two      legs     sitting on three legs *looking* ---               
    ## [321]                  --- two legs sitting on three      legs     *looking* at one leg, when ---                    
    ## [322]                --- three legs *looking* at one      leg     , when in came four legs, ---                      
    ## [323]            --- away inside, *looking* like the     hands     of a monkey. The evening ---                      
    ## [324]           --- healthy, with a pleasant English      face     which had been *looking* at ---                   
    ## [325]                --- The observer stood with her      hand     upon her own bosom, *looking* ---                 
    ## [326]                      --- her hand upon her own     bosom    , *looking* at the girl, as ---                    
    ## [327]                   --- desk; folded them in her      lap     ; and sat *looking* towards the ---                
    ## [328]                      --- on the wall, with the      eyes     intently *looking* at his son ---                 
    ## [329]              --- *looking* much younger in the      face     when the two were observed ---                    
    ## [330]        --- Barnacle junior, *looking* over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [331]     --- square, practical *looking* man, whose      hair     had turned grey, and in ---                       
    ## [332]               --- several laughing nods of her      head    , but without *looking* up from ---                
    ## [333]              --- *looking* steadily out of her      eyes     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [334]               --- *looking* over her father 's      hand    , or singing to herself by ---                     
    ## [335]     --- chamber-candlestick in hand, the other      hand     in his pocket, *looking* hard ---                 
    ## [336]                    --- _b_ _b_ _b_ turning his     hands     over and over and *looking* ---                   
    ## [337]               --- the gentleman with the black      hair     *looking* round his old beam, ---                 
    ## [338]                      --- with care in an inner breast-pocket, and *looking* straight at Clennam ---            
    ## [339]            --- while *looking* at Clennam, and     biting    his ten nails all round; ---                      
    ## [340]        --- Callers *looking* steadily into the      eyes     of their receivers, pretended not ---             
    ## [341]                 --- with *looking* well to his      feet     on Earth, and that he ---                         
    ## [342]                --- _b_ After clasping both her     hands     upon his arm, and *looking* ---                   
    ## [343]                    --- both her hands upon his      arm     , and *looking* confidentially up into ---         
    ## [344]       --- *looking* confidentially up into his      face    , with some hurried words to ---                   
    ## [345]                   --- Mrs Clennam, with a deep  contraction  of her brows, was *looking* ---                   
    ## [346]                  --- a deep contraction of her     brows    , was *looking* at him _b_ ---                     
    ## [347]      --- with attentive and darkly distrustful      eyes    ; and Affery stood *looking* at ---                
    ## [348]               --- smiles, and with his surface      eyes     *looking* as if they belonged ---                 
    ## [349]                      --- hat and with his bare      head     in the wildest condition, *looking* ---           
    ## [350]                  --- would sit with her folded     hands    , thoughtfully *looking* after some diminutive --- 
    ## [351]                    --- in her boat with folded     hands    , *looking* so pensively and wonderingly ---       
    ## [352]           --- had been *looking* admiringly at     Fanny     through her eye-glass _b_ _b_ ---                 
    ## [353]           --- *looking* through the steam, and   breathing   forth the steam, like a ---                       
    ## [354]                 --- and *looking* round with a      face     of blank disappointment _b_ _b_ ---               
    ## [355]       --- After *looking* at the philanthropic     visage    and the long silky white ---                      
    ## [356]                 --- were *looking* at him with      eyes     by no means unlike his ---                        
    ## [357]       --- silence, Jeremiah stood scraping his      chin     and *looking* at Arthur as ---                    
    ## [358]                      --- had fallen out of her      hand    , and she was *looking* up ---                     
    ## [359]              --- Fanny had stopped the dabbing      hand    , and was *looking* at her ---                     
    ## [360]      --- spoke without first *looking* towards     Fanny     for leave. That young lady ---                    
    ## [361]                --- turning the bracelet on her      arm     , and now *looking* at him, ---                    
    ## [362]                   --- wherever she could lay a      hand    ; *looking* everywhere for Mr Eustace ---          
    ## [363]                 --- *looking* Mr Dorrit in the      face     for the first time, and ---                       
    ## [364]              --- returned Doyce, with his grey      eye      *looking* kind and bright _b_ ---                 
    ## [365]                 --- *looking* at these with an      eye      of wild hatred, he put ---                        
    ## [366]                 --- more. He stood amazed; his      eyes     *looking* at John; his lips ---                   
    ## [367]                --- eyes *looking* at John; his      lips     parted, and seeming now and ---                   
    ## [368]          --- Mr Flintwinch, after scraping his      chin    , and *looking* about with caustic ---             
    ## [369]                   --- now *looking* her in the      face    , she still abided by her ---                      
    ## [370]                     --- her, and drew back her      head    , *looking* at him with some ---                   
    ## [371]               --- *looking* into his friend 's      face    , as if he were a ---                              
    ## [372]                 --- and good *looking*, with a      face     of clear red and white, ---                       
    ## [373]               --- that there was nobody within    hearing   , and then *looking* down upon ---                 
    ## [374]             --- said Mr Pecksniff, folding his     hands    , and *looking* at his young ---                   
    ## [375]               --- cried Mr Tapley, shaking his      head     expressively enough, and *looking* (in ---        
    ## [376]               --- she said; *looking* into his      face     with a smile, which was ---                       
    ## [377]              --- said Mr Pecksniff, drying his     hands     upon his handkerchief, and *looking* ---          
    ## [378]          --- plate, *looking* at nothing, with      eyes     that saw nothing, and a ---                       
    ## [379]                --- _b_ said Martin leaning his      chin     upon his hand, and *looking* ---                  
    ## [380]                  --- leaning his chin upon his      hand    , and *looking* through the window-glass ---       
    ## [381]              --- a moment, and *looking* gayly      back     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [382]                 --- beneath the tread of naked      feet    , bethink yourselves in *looking* on ---           
    ## [383]               --- _b_ said Martin, leaning his      chin     upon his hand, and *looking* ---                  
    ## [384]                  --- leaning his chin upon his      hand    , and *looking* at the fire ---                    
    ## [385]                      --- Martin as he drew her     waist     within his arm, first *looking* ---               
    ## [386]                  --- drew her waist within his      arm     , first *looking* round to see ---                 
    ## [387]               --- *looking* once more into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [388]                   --- hung more closely on his      arm     , and *looking* upwards in his ---                 
    ## [389]               --- and *looking* upwards in his      face    , bade him speak on _b_ ---                        
    ## [390]               --- _b_ said Martin, folding his      arms    , and *looking* at the ashes ---                   
    ## [391]                   --- one hand upon his aching      head     and *looking* round him with ---                  
    ## [392]             --- Martin, raising himself on his     elbow    , and *looking* angrily at his ---                 
    ## [393]              --- Norris the father, giving his      head     a melancholy shake, and *looking* ---             
    ## [394]              --- father, *looking* with a pale      face     on the assembled circle as ---                    
    ## [395]             --- _b_ said Chuffey, clasping his     hands     and *looking* up in anguish ---                   
    ## [396]                     --- the fair Cherry on his      arm     , he could not help *looking* ---                  
    ## [397]            --- *looking* ruefully at his empty     finger    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [398]                  --- same gentleman was on one      knee     before him, *looking* in at ---                   
    ## [399]                   --- him, *looking* in at his     teeth    , with the nice scrutiny of ---                    
    ## [400]                    --- to and fro, sucking the      head     of a stick, and *looking* ---                     
    ## [401]            --- Jonas, *looking* after her, and     biting    a piece of straw, almost ---                      
    ## [402]                  --- *looking* at him with her      head     inclined a little sideways, as ---                
    ## [403]                        --- _b_ _b_ _b_ _b_ She     roused    herself from *looking* after him ---              
    ## [404]          --- Anglo- Bengalee; by feeling their     pulses   , *looking* at their tongues, listening ---        
    ## [405]           --- their pulses, *looking* at their    tongues   , listening at their ribs, poking ---              
    ## [406]         --- Jonas, *looking* greedily over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [407]               --- and still *looking* over his    shoulder   for the man who never ---                         
    ## [408]               --- sat down, *looking* from one      face     to another, in mute surprise ---                  
    ## [409]     --- gentleman, *looking* slightly over his    shoulder  . _b_ _b_ _b_ _b_ _b_ ---                          
    ## [410]          --- sister *looking* wistfully in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [411]        --- added, *looking* hurriedly into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [412]               --- spectacles low down upon his      nose    , *looking* over them at his ---                   
    ## [413]                    --- poising a brush in each      hand    , and *looking* steadily upon him ---              
    ## [414]        --- Montague, leaning forward, with his      arms     upon his knees, and *looking* ---                 
    ## [415]                     --- with his arms upon his     knees    , and *looking* full into his ---                  
    ## [416]                --- and *looking* full into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [417]                    --- and *looking* up in her      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [418]                   --- sat *looking* on, pen in      hand    , with one of the most ---                         
    ## [419]                       --- the calf of his left      leg     , and *looking* steadily at Tom ---                
    ## [420]                   --- spare, and Tom was never     tired     of *looking* about him. It ---                    
    ## [421]                    --- Tom, with Ruth upon his      arm     , stood *looking* down from the ---                
    ## [422]            --- said his companion, raising his      head    , and *looking* at him, but ---                    
    ## [423]                 --- so that groups of watchful     faces     seemed to be *looking* out ---                    
    ## [424]            --- inexplicable fear, and held his      ears    . But *looking* at the speaker ---                 
    ## [425]                --- *looking* at the speaker 's      lips    , he saw that they formed ---                      
    ## [426]                        --- As she sat with her      chin     upon her hand, *looking* out ---                  
    ## [427]                     --- with her chin upon her      hand    , *looking* out through a low ---                  
    ## [428]                --- *looking* out through a low      back     lattice, rendered dim in the ---                  
    ## [429]                --- it down again. Throwing his      body     back, and *looking* about him ---                 
    ## [430]              --- down again. Throwing his body      back    , and *looking* about him stiffly, ---             
    ## [431]              --- Martin, *looking* up into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [432]                   --- she arranged them in her     breast   , and *looking* at them with ---                   
    ## [433]                 --- *looking* at them with her      head     aside, now half resolved to ---                   
    ## [434]                  --- *looking* at him with her      head     on one side, as if ---                            
    ## [435]             --- upon the bedstead, leaning his      chin     upon his hand, and *looking* ---                  
    ## [436]                  --- leaning his chin upon his      hand    , and *looking* at the table. ---                  
    ## [437]               --- him without *looking* in his      face    ; and left it ajar while ---                       
    ## [438]                  --- an easier one, folded his      arms     without *looking* at them, though ---             
    ## [439]             --- Chuffey, *looking* up into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [440]            --- there, *looking*, with his keen      eyes    , steadily towards the door, Mark ---              
    ## [441]           --- anxious inquirer. He clasped his     hands     and, *looking* upwards with a ---                 
    ## [442]                --- *looking* at him with those      eyes    , to ask him was he ---                            
    ## [443]              --- *looking* over one another 's   shoulders  , read, in the words and ---                       
    ## [444]                         --- as he sat with his     hands     in his pockets *looking* out ---                  
    ## [445]                  --- of naval dress coats with     faces     *looking* out of them, and ---                    
    ## [446]              --- Miss Squeers; screwing up her      lips    , and *looking* as if nothing ---                  
    ## [447]        --- hours, *looking* patiently into his      face    ; and a word would brighten ---                    
    ## [448]           --- other, *looking* intently in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [449]                 --- *looking* in each other 's     faces     with much perplexity and some ---                 
    ## [450]               --- Kenwigs, who was rubbing his      head     very hard, and *looking* much ---                 
    ## [451]                 --- *looking* on with a singed      head     and a frightened face _b_ ---                     
    ## [452]              --- *looking* him steadily in the      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [453]                       --- a voice close to his      ear     ; and, *looking* round, he found ---               
    ## [454]          --- replied Mrs Nickleby, tossing her      head    , and *looking* prodigiously sly _b_ ---           
    ## [455]                 --- and still *looking* in her      face     and retaining her arm, walked ---                 
    ## [456]         --- *looking* upwards and clasping her     hands     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [457]     --- retired; *looking* stealthily over his    shoulder   at Ralph as he limped ---                         
    ## [458]           --- the coachman, *looking* over his    shoulder   at Nicholas with no very ---                      
    ## [459]              --- raising his wine-glass to his      lips    , and *looking* round upon his ---                 
    ## [460]          --- Nicholas, *looking* kindly in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [461]          --- man, *looking* wistfully into the      face     of the young one _b_ ---                          
    ## [462]              --- -- *looking* precisely like a      back     view of himself as it ---                         
    ## [463]     --- *looking* round, impatiently waved his      hand     as a caution that profound ---                    
    ## [464]   --- inquired Nicholas, fretted almost beyond   endurance  , but *looking* nearly as resigned ---             
    ## [465]          --- replied Mrs Nickleby, tossing her      head     and *looking* at the ashes ---                    
    ## [466]         --- great alacrity; *looking* over his    shoulder   every instant, to make quite ---                  
    ## [467]                      --- of his wife 's pretty    ringlets  , and *looking* very proud of ---                  
    ## [468]             --- said Miss Squeers, tossing her      head    , and *looking* contemptuously at the ---          
    ## [469]                   --- _b_ Mr Squeers shook his      head     in a threatening manner, *looking* ---            
    ## [470]             --- said John Browdie, rubbing his     hands     with great joyousness, and *looking* ---          
    ## [471]          --- been *looking* anxiously over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [472]                --- chair *looking* up into the      face     of Ralph Nickleby, who, lounging ---              
    ## [473]       --- *looking* upwards into his immovable      face    , said _b_ _b_ _b_ _b_ ---                         
    ## [474]          --- _b_ rejoined Ralph, elevating his    eyebrows   and *looking* down upon his ---                   
    ## [475]                 --- scratching the side of his      nose    , and *looking* at Nicholas with ---               
    ## [476]              --- not *looking* directly in her      face    , but glancing at her, as ---                      
    ## [477]             --- deep sullen gloom. Raising his      eyes    , and *looking* vacantly into this ---             
    ## [478]         --- were stealthily raised, caught his      ear     , and *looking* up he could ---                    
    ## [479]             --- and, *looking* round, Ralph 's      eyes     met those of Newman Noggs. ---                    
    ## [480]                  --- to recognise. He held his      hand     above his eyes, and, *looking* ---                
    ## [481]                    --- held his hand above his      eyes    , and, *looking* out, saw Tim ---                  
    ## [482]               --- and *looking* often over his    shoulder   while he hurried away, as ---                     
    ## [483]           --- and *looking* wildly round, with      eyes     which gleamed through the darkness, ---           
    ## [484]        --- returned, *looking* anxiously in my      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [485]         --- old man, passionately clasping his     hands     and *looking* upward _b_ _b_ ---                  
    ## [486]                 --- said the child, laying her     finger    on her lip and *looking* ---                      
    ## [487]                   --- laying her finger on her      lip      and *looking* round _b_ _b_ ---                   
    ## [488]                --- 's soul. *Looking* into the      eyes     of Mrs and Miss Wackles ---                       
    ## [489]                 --- the old man, clenching his     hands     desperately, and *looking* upwards _b_ ---        
    ## [490]               --- it, still *looking* over his    shoulder   at the same window; and ---                       
    ## [491]                   --- rim with his great round      eyes    , and *looking* as if he ---                       
    ## [492]                 --- with his swoln and bruised      face     *looking* out of the towel, ---                   
    ## [493]                       --- _b_ _b_ He shook his      head    , and *looking* at his daughter ---                
    ## [494]              --- by, and *looking* with hungry      eyes     upon his priestly neighbour. _b_ ---              
    ## [495]            --- were *looking* on with laughing     faces    , and Mr Codlin had relaxed ---                    
    ## [496]                 --- had been standing with his     hands     in his pockets *looking* carelessly ---           
    ## [497]                --- *looking* slyly up into his      face     out of the corners of ---                         
    ## [498]                   --- raising the glass to his      lips     and *looking* at the dwarf ---                    
    ## [499]                   --- Kit was *looking* at her   eyelashes   and wondering -- quite in ---                     
    ## [500]              --- _b_ he answered, pressing her      hand    , but still *looking* anxiously about ---          
    ## [501]                   --- _b_ he said, standing on    tip-toe    on the window-sill, and *looking* ---             
    ## [502]                        --- a crown into Kit 's      hand    , and *looking* towards the Notary ---             
    ## [503]                  --- was alone. She raised her      eyes     to the bright stars, *looking* ---                
    ## [504]                    --- a mighty ocean, his red      eyes     blinded by *looking* on the ---                   
    ## [505]        --- quietly there, *looking* into their     faces     as they flitted past. In ---                      
    ## [506]                   --- lay in the state between    sleeping   and waking, *looking* so long ---                 
    ## [507]             --- the state between sleeping and     waking   , *looking* so long at his ---                     
    ## [508]                      --- a fur cap opening his      eyes     and *looking* wild and stupefied ---              
    ## [509]         --- baby, *looking* anxiously over her    shoulder   to see if Quilp were ---                          
    ## [510] --- embracing the case-bottle with shrugged-up   shoulders   and folded arms, stood *looking* ---              
    ## [511]      --- with shrugged-up shoulders and folded      arms    , stood *looking* at his insensible ---            
    ## [512]               --- arms, stood *looking* at his   insensible  wife like a dismounted nightmare ---              
    ## [513]                 --- and *looking* down on her,     asleep   . It was a sweet and ---                           
    ## [514]                    --- hastily to her with his      hand     and *looking* over his shoulder ---               
    ## [515]                --- hand and *looking* over his    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [516]            --- added Richard, getting his left     cheek     into profile, and *looking* complacently ---      
    ## [517]                --- getting his left cheek into    profile   , and *looking* complacently at the ---            
    ## [518]                   --- before the fire with his      back     towards it, and *looking* so ---                  
    ## [519]                  --- *looking* at Brass with a      face     as pale as his own ---                            
    ## [520]                 --- _b_ cried Kit, raising his      eyes     and *looking* imploringly about him ---           
    ## [521]               --- said Brass, laying his right      hand     on his waistcoat, and *looking* ---               
    ## [522]                      --- With a smile upon her      face    , and *looking* at each of ---                     
    ## [523]                 --- beating the water with his     hands    , and *looking* out, with wild ---                 
    ## [524]          --- with shuffling steps and cowering   shivering   forms, *looking* into the roads ---               
    ## [525]                      --- her head and over her      face    , and, *looking* backward so that ---              
    ## [526]                    --- either side of his else      bald     head, *looking* as like his ---                   
    ## [527]                      --- side of his else bald      head    , *looking* as like his hairbrushes ---            
    ## [528]            --- then, *looking* with an altered      face     round the table _b_ _b_ ---                       
    ## [529]             --- and without *looking* over her    shoulder   as she warmed her foot ---                        
    ## [530]         --- *looking* round on the deferential     faces     of her school, and descrying ---                  
    ## [531]                        --- _b_ _b_ _b_ _b_ The      face     *looking* up is a sallow ---                      
    ## [532]                   --- *looking* up is a sallow      face     with weak eyes, surmounted by ---                 
    ## [533]                   --- compares with Mr Wegg 's      leg     ; that gentleman *looking* on, as ---              
    ## [534]              --- Wegg, *looking* back over his    shoulder   as he pulls the door ---                          
    ## [535]                 --- each of her eight aquiline    fingers    *looking* so very like her ---                    
    ## [536]                     --- on one knee beside the      body    , when they had stood *looking* ---                
    ## [537]                        --- _b_ _b_ _b_ _b_ _b_   Conscious   that his pupil-teacher was *looking* ---          
    ## [538]                     --- one of her little bony     fists    , like an opera-glass, and *looking* ---           
    ## [539]             --- *looking* through it, with her      eyes     and her chin in that ---                          
    ## [540]                  --- of her chair, resting her      chin     upon that hand, and *looking* ---                 
    ## [541]                 --- resting her chin upon that      hand    , and *looking* vacantly before her ---            
    ## [542]           --- little creature, holding out her      hand     and *looking* upward _b_ _b_ ---                  
    ## [543]                --- in hand, *looking* over her    shoulder   at the town in innocent ---                       
    ## [544]                      --- began to sound in his      ears     again, and, *looking* above, he ---               
    ## [545]                --- *looking* above, he saw the      face     of the little creature *looking* ---              
    ## [546]                  --- leaning his head upon his      hand    , smoking, and *looking* imperturbably at ---      
    ## [547]                      --- and her chin upon her     hands    , Miss Jenny Wren sat *looking* ---                
    ## [548]             --- an intervening silence, of the      face     *looking* down at the fire ---                    
    ## [549]                         --- _b_ _b_ _b_ As the      face     *looking* at the fire had ---                     
    ## [550]                --- anxious, meagre, of a muddy   complexion , and *looking* as old again ---                   
    ## [551]                 --- when she stood with folded      arms     at her shop- door, *looking* ---                  
    ## [552]              --- *looking* from under her bent    forehead   at the man. In taking ---                         
    ## [553]             --- Harmon, *looking* at the proud      face     with the down- cast eyes, ---                     
    ## [554]                --- compare the portrait in his      hand     with the original *looking* towards ---           
    ## [555]               --- *looking* over his master 's    shoulder   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [556]               --- says the doctor, washing his     hands    , and *looking* at the patient ---                 
    ## [557]               --- then Wegg, singly, fixed his      eyes     on Mr Boffin *looking* at ---                     
    ## [558]                     --- with a movement of his      head    , though not at all *looking* ---                  
    ## [559]         --- the fender, indolently rocking his      body     and *looking* at the fire. ---                    
    ## [560]                      --- held it with a clumsy      hand    . *Looking* perplexedly at the passionate ---      
    ## [561]    --- *Looking* perplexedly at the passionate      face    , as if he were trying ---                         
    ## [562]              --- hand protectingly on Bella 's      head     without *looking* down at her ---                 
    ## [563]        --- cherub stood helplessly rubbing his      chin     and *looking* on, but on ---                      
    ## [564]                --- Are you *looking* into your     breast    ? Do you deserve your blessings ? ---             
    ## [565]               --- Bella, *looking* up into his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [566]                 --- *looking* at her father 's      hand     and lightly slapping it _b_ ---                   
    ## [567]                  --- with his bundle under his      arm     . *Looking* all around him with ---                
    ## [568]                         --- to stop her with a      hand    , and *looking* mightily determined, the ---       
    ## [569]                         --- the old man by the      hand    , and *looking* thoughtfully in his ---            
    ## [570]          --- and *looking* thoughtfully in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [571]                      --- saw Miss Jenny at the      foot     of the bed, *looking* at ---                      
    ## [572]                  --- *looking* at him with her     elbows    on the bed, and her ---                           
    ## [573]                          --- as she sat on his      knee     *looking* at him in astonishment ---              
    ## [574]              --- her husband, not avoiding his      eye     , but *looking* at him _b_ ---                     
    ## [575]                   --- she sat *looking* in his      face    , with the colour quite gone ---                   
    ## [576]                       --- air and a plump rosy      face    , should be standing there, *looking* ---          
    ## [577]              --- spectacles more firmly on his      nose    , and *looking* about him for ---                  
    ## [578]                 --- off, *looking* on with his    eyelids    as wide open as they ---                          
    ## [579]                     --- with mud and dust, and    bleeding   from the mouth, *looking* wildly ---              
    ## [580]                --- dust, and bleeding from the     mouth    , *looking* wildly round upon the ---              
    ## [581]              --- _b_ said Oliver, clasping his     hands     passionately, and *looking* round _b_ ---         
    ## [582]             --- the inquiry, Oliver raised his      head    ; and, *looking* round with imploring ---          
    ## [583]        --- and, *looking* round with imploring      eyes    , murmured a feeble prayer for ---                 
    ## [584]                  --- of again *looking* on the      face     of the beautiful lady. His ---                    
    ## [585]          --- *looking* on, without raising his      eyes     from the ground _b_ _b_ ---                       
    ## [586]                  --- away. But Oliver felt her      hand     tremble, and, *looking* up in ---                 
    ## [587]                   --- and, *looking* up in her      face     as they passed a gas-lamp, ---                    
    ## [588]                    --- from between the Jew 's     finger    and thumb; and *looking* the ---                  
    ## [589]                      --- the Jew 's finger and     thumb    ; and *looking* the old man ---                    
    ## [590]                   --- Mrs Mann, holding up her     hands    , and *looking* malignantly at Dick ---            
    ## [591]               --- the door: *looking* over his    shoulder   at the boy as he ---                              
    ## [592]               --- said the matron, leaning her     elbow     on the table, and *looking* ---                   
    ## [593]               --- woman, *looking* up into her      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [594]                --- the little man, shaking his      head    , and *looking* amazingly sly _b_ ---              
    ## [595]             --- Jew, *looking* back, waved his      hand     to intimate that he preferred ---                 
    ## [596]              --- Mr. Giles, surveying the pale     faces     which surrounded him, and *looking* ---           
    ## [597]        --- gentlemen watched Oliver 's earnest      face    , as he spoke, and *looking* ---                   
    ## [598]               --- sound, Mr. Bumble raised his      head     and descried a man *looking* ---                  
    ## [599]               --- *looking* into each other 's     faces    , seemed to breathe more freely ---                
    ## [600]                  --- and *looking* up with the  perspiration streaming from her face _b_ ---                   
    ## [601]              --- his mouth almost touching her      ear     , and his eyes *looking* into ---                  
    ## [602]                  --- touching her ear, and his      eyes     *looking* into hers _b_ _b_ ---                   
    ## [603]               --- chair: *looking* on with his     hands     upon his knees, as if ---                         
    ## [604]               --- replied, *looking* up with a      face     retaining no human expression but ---             
    ## [605]            --- and *looking* vacantly over his      head     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [606]                     --- _b_ _b_ _b_ Mr. Tupman     gasped    a faint affirmative, *looking* very ---           
    ## [607]               --- work, and stands with folded      arms    , *looking* at the vehicle as ---                  
    ## [608]                    --- with his thumb over his    shoulder  , and Mr. Pickwick, on *looking* ---               
    ## [609]                   --- *looking* up, the row of     heads     suddenly disappeared, and the sound ---           
    ## [610]               --- every face. Then rubbing his      chin     with his hand, and *looking* ---                  
    ## [611]                  --- rubbing his chin with his      hand    , and *looking* up to the ---                      
    ## [612]            --- them -- *looking*, with longing      eyes     and red noses, at the ---                         
    ## [613]            --- the parchment; and, resting his     hands     on the table, and *looking* ---                   
    ## [614]            --- *looking* man, in boots without      toes     and gloves without fingers. There ---             
    ## [615]                --- glasses, raised them to his      eyes    ; and, after *looking* at Mr. ---                  
    ## [616]              --- himself gently touched on the    shoulder  ; and, *looking* round, his father ---             
    ## [617]       --- Pickwick, *looking* earnestly in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [618]                   --- with his hat between his     knees    , whistling a tune, and *looking* ---              
    ## [619]          --- tipstaff, just *looking* over his    shoulder   to see that his charge ---                        
    ## [620]          --- said the gentleman, thrusting his     hands     into his pockets, and *looking* ---               
    ## [621]          --- and *looking* carelessly over his    shoulder   to Mr. Pickwick _b_ _b_ ---                       
    ## [622]                      --- hold of his friend 's      hand    , and was *looking* into his ---                   
    ## [623]                 --- and was *looking* into his      face     with the same strange expression ---              
    ## [624]                          --- with a key in his      hand    , who had been *looking* on, ---                   
    ## [625]                --- gray was *looking* on, with      eyes     wide open, and greedy ears. ---                   
    ## [626]                    --- hand on Mr. Pickwick 's      knee    , and *looking* round with a ---                   
    ## [627]          --- Perker, *looking* from the musing      face     of Mr. Pickwick to the ---                        
    ## [628]                 --- *looking* slily in his fat      face    . _b_ _b_ _b_ _b_ _b_ ---                          
    ## [629]         --- state of remarkable vigilance, his      eyes     being wide open, and *looking* ---                
    ## [630]           --- Pickwick, *looking* round on the     faces     of his friends with a ---                         
    ## [631]              --- stood *looking* down into her      face     while she sat *looking* up ---                    
    ## [632]                --- *looking* down at the white      head     that bent low over the ---                        
    ## [633]         --- still *looking* steadfastly in his      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [634]               --- stood *looking* at him, with     hands     which at first had been ---                       
    ## [635]                      --- his arm, she laid her      hand     upon his shoulder. After *looking* ---            
    ## [636]                     --- laid her hand upon his    shoulder  . After *looking* doubtfully at it, ---            
    ## [637]                --- the surface, with his spiky      hair     *looking* as if it must ---                       
    ## [638]               --- most part reclining with his     hands     in his waistband, *looking* at ---                
    ## [639]                     --- in his pockets and his      legs     stretched out before him, *looking* ---           
    ## [640]                --- *looking* at him with sharp      eyes    , and slowly drawing a hand ---                    
    ## [641]               --- cried Mr. Lorry, rubbing his      chin    , and *looking* at his visitor ---                 
    ## [642]                   --- But, *looking* up at his      face     in the interchange of the ---                     
    ## [643]      --- particular friends, stood with folded      arms     at the fountain, *looking* at ---                 
    ## [644]          --- Stryver, *looking* all round, and    snapping   his fingers _b_ _b_ _b_ ---                       
    ## [645]        --- said Defarge, speaking with knitted     brows    , and *looking* straight before him ---            
    ## [646]             --- Defarge, who had been uneasily     biting    his thumb-nail and *looking* at ---               
    ## [647]               --- had been uneasily biting his   thumb-nail  and *looking* at her, collected ---               
    ## [648]            --- *looking* at her, collected his      face     into a sterner expression _b_ ---                 
    ## [649]                 --- *looking* at her, with his      knee     on his bench and his ---                          
    ## [650]                --- really was *looking* over a      hand     at cards _b_ _b_ _b_ ---                          
    ## [651]              --- coldly, *looking* like a dead      face     out of the sky. Then, ---                         
    ## [652]                 --- Manette sat down, with his      eyes     *looking* around, and his lips ---                
    ## [653]             --- eyes *looking* around, and his      lips     trembling; his daughter drew closer ---           
    ## [654]               --- *looking* after him with her     hands     touching one another in the ---

``` r
# turning
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("turning"), context = 0)
y
```

    ## [  1]   --- cross-country work, *turning* his large    eyeball    to the grated window near ---                        
    ## [  2]             --- the floor, then *turning* his      head     round again, said morosely _b_ ---                   
    ## [  3]         --- that, *turning* its bright sudden      eye      on its master as if ---                              
    ## [  4]     --- opportunity of slightly *turning* his      head     to glance over his shoulder ---                      
    ## [  5]                     --- of the corners of her      eyes     without *turning* her head which ---                 
    ## [  6]            --- her eyes without *turning* her      head     which could be pleasantly dispensed ---              
    ## [  7]               --- power, and *turning* up his      eyes    , and lowering his grey eyebrows ---                  
    ## [  8]           --- said my guardian, *turning* his      face     away for a moment _b_ ---                            
    ## [  9]            --- says Mr. George, *turning* his      head     in that direction _b_ _b_ ---                        
    ## [ 10]            --- *turning* back each sleeper 's      arm      from his face to look ---                            
    ## [ 11]            --- says Mr. Bucket, *turning* his      head     in the direction of the ---                          
    ## [ 12]        --- polishes, and blows, *turning* his      head     from side to side the ---                            
    ## [ 13]                 --- question to them with his      eye     , and Mr. George not *turning* ---                    
    ## [ 14]                --- as for ever *turning* your      back     upon the shadow in which ---                         
    ## [ 15]        --- Mr. Skimpole, *turning* his bright      face     about _b_ _b_ _b_ _b_ ---                            
    ## [ 16]     --- Mr. Skimpole, *turning* his sprightly      eyes     from one to the other ---                            
    ## [ 17]                 --- *turning* out of a flaxen   complexion . With a similar perverseness, the ---                
    ## [ 18]                --- an inner drawer. His great      hand    , *turning* over some gloves which ---                
    ## [ 19]              --- They came back, wiping their     hands     upon their coats, after *turning* ---                
    ## [ 20]           --- that I involuntarily clasped my     hands     and felt the room *turning* ---                      
    ## [ 21]        --- part, the ironmaster *turning* his      face     to the smoke and fires, ---                          
    ## [ 22]           --- said John Willet, *turning* his      eyes     from the ceiling to the ---                          
    ## [ 23]           --- _b_ said Solomon, *turning* his      back     upon the strange man _b_ ---                         
    ## [ 24]              --- replied the nian, waving his      hand     and *turning* on his heel ---                        
    ## [ 25]                 --- hand and *turning* on his      heel     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 26]              --- to this point; *turning* his      head     from one to the other, ---                           
    ## [ 27]              --- the table, and *turning* his      back     upon it, stood there Atlas-wise. ---                 
    ## [ 28]           --- returned the other, leaning his      arm      upon the chimney-piece, and *turning* ---            
    ## [ 29]             --- cried Miggs, *turning* on the     tears     again, previous to quitting the ---                  
    ## [ 30]              --- he added, *turning* away his      head     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 31]     --- and *turning* a perfectly undisturbed      face     towards the strange apparition, which ---            
    ## [ 32]          --- any starting or *turning* round,     awoke    . There was a kind of ---                             
    ## [ 33]          --- busy in thought, *turning* their      eyes     towards the countless spheres that ---               
    ## [ 34]             --- _b_ cried Mr Willet, suddenly    rousing    himself, and *turning* round _b_ ---                 
    ## [ 35]        --- rejoined his father, *turning* his      face     lazily towards him, and cracking ---                 
    ## [ 36]               --- the fire, and *turning* his      back     upon it, said with dignity ---                       
    ## [ 37]        --- throng, and, without *turning* his      head     or appearing to communicate with ---                 
    ## [ 38]    --- Simon, *turning* thoughtfully upon his      heel     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 39]           --- went slowly away, *turning* his      head     from time to time, and ---                           
    ## [ 40]         --- said the secretary, *turning* his      face     homewards _b_ _b_ _b_ _b_ ---                        
    ## [ 41]                  --- to say what; panting for     breath   , clasping her hands, *turning* her ---               
    ## [ 42]          --- panting for breath, clasping her     hands    , *turning* her eyes upwards, shedding ---            
    ## [ 43]         --- clasping her hands, *turning* her      eyes     upwards, shedding abundance of tears, ---            
    ## [ 44]          --- cried John, *turning* his rueful      eyes     on Mr Haredale, who had ---                          
    ## [ 45]            --- The prisoner shuffled with his      feet     upon the ground in *turning* ---                     
    ## [ 46]               --- the ground in *turning* his      body     from him, but made no ---                            
    ## [ 47]              --- *turning* off upon the right      hand     and the left, into the ---                           
    ## [ 48]                   --- that all his joints and     limbs     seemed racked by spasms. *Turning* ---               
    ## [ 49]            --- old home, before *turning* his      back     upon it, for ever. _b_ ---                           
    ## [ 50]                     --- crowd, when he felt a      hand     upon his shoulder, and, *turning*, ---               
    ## [ 51]                      --- felt a hand upon his    shoulder  , and, *turning*, recognised one of ---               
    ## [ 52]               --- of him without *turning* my      head     sometimes, and looking up in ---                     
    ## [ 53]             --- _b_ _b_ *turning* a darkening      face     on Peggotty, when he had ---                         
    ## [ 54]             --- he said, slowly *turning* his      eyes     towards me. 'Well ! If you ---                       
    ## [ 55]             --- and had some thin wet-looking      hair     that was just *turning* grey, ---                    
    ## [ 56]         --- said Mr. Murdstone, *turning* his      head     and his eyes stiffly towards ---                     
    ## [ 57]                --- *turning* his head and his      eyes     stiffly towards me _b_ _b_ ---                       
    ## [ 58]                 --- my aunt, *turning* a deaf      ear      to the sister, and continuing ---                    
    ## [ 59]            --- *Turning* upon me a lustreless      eye     , that reminded me of a ---                           
    ## [ 60]      --- arose with assistance: *turning* her      head    , as she did so, to ---                               
    ## [ 61]               --- stocks for *turning* in her      toes     ! _b_ _b_ _b_ _b_ _b_ ---                            
    ## [ 62]             --- and Mr. Barkis, *turning* his      eyes     more gently to his wife, ---                         
    ## [ 63]                 --- said I, *turning* away my      head     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 64]          --- instant; and said, *turning* his      head     towards me, but looking at ---                       
    ## [ 65]                     --- used to fancy that my      head     was *turning* quite grey _b_ ---                     
    ## [ 66]         --- Mr Dombey, slightly *turning* his      head     in his cravat, as if ---                             
    ## [ 67]                  --- Mr Pitt *turning* up his      nose     at a cold collation, set ---                         
    ## [ 68]              --- chair, and *turning* the old      face     up towards Mr Dombey 's ---                          
    ## [ 69]      --- pursued Florence, *turning* away her      face     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 70]          --- _b_ inquired Paul, *turning* his      face     towards her on his pillow, ---                       
    ## [ 71]                 --- _b_ _b_ _b_ *turning* his      head     to where he stood, and ---                           
    ## [ 72]                   --- hand; kissed him on the     cheek    ; and *turning*, gave her hand ---                    
    ## [ 73]            --- cheek; and *turning*, gave her      hand     to Walter with a simple ---                          
    ## [ 74]                --- averted from his patron 's      face    , but, constantly *turning* and *turning* ---         
    ## [ 75]       --- she answered, without *turning* her      head     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 76]         --- repeated, *turning* very red, and   breathing   quickly as she looked round ---                      
    ## [ 77]       --- she answered, without *turning* her      head    , and with supreme indifference. _b_ ---              
    ## [ 78]              --- *turning* away, but with her      face     addressed to the spectator, flashes ---              
    ## [ 79]              --- the old woman, *turning* her      face     upward, with a terrible howl ---                     
    ## [ 80]             --- said at length, *turning* her      eyes     upon the old woman _b_ ---                           
    ## [ 81]         --- there watching him; *turning* her      eyes     towards his chair from time ---                      
    ## [ 82]          --- said Carker, *turning* his white     teeth     on Mrs Skewton like a ---                            
    ## [ 83]                 --- _b_ _b_ _b_ *Turning* her      eyes     again on the attentive gentleman ---                 
    ## [ 84]               --- _b_ She slowly withdrew her      eyes     from his face, and *turning* ---                     
    ## [ 85]                --- withdrew her eyes from his      face    , and *turning* to the servant, ---                   
    ## [ 86]         --- withdrew, and *turning* in again,     slept     till seven o'clock. _b_ _b_ ---                      
    ## [ 87]           --- said the Captain, *turning* his      eyes     upon him with a faint ---                            
    ## [ 88]               --- _b_ said Rob, *turning* his      eyes    , which were now fast getting ---                     
    ## [ 89]           --- exclaimed, covering it with his      hand    , and *turning* impatiently upon her ---              
    ## [ 90]                   --- them for the night. The      bald     man *turning* round to bow, ---                      
    ## [ 91]              --- of action with the *turning*      back     of all his schemes -- ---                            
    ## [ 92]               --- back, *turning* over on her      face    . _b_ _b_ _b_ _b_ _b_ ---                             
    ## [ 93]       --- retorts Edwin, *turning* merely his      eyes     in that direction _b_ _b_ ---                        
    ## [ 94]         --- and *turning*, and lowering their     heads     to avoid the stairs above, ---                       
    ## [ 95]         --- *turning* white, and clasping her     hands     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 96]              --- Then he added, *turning* his      face     so abruptly that his head ---                        
    ## [ 97]                 --- about that, cast down her      eyes    , and *turning* to Mr. Grewgious, ---                 
    ## [ 98]                  --- flicks the face with the      back     of her hand in *turning* ---                         
    ## [ 99]                      --- with the back of her      hand     in *turning* from it. _b_ ---                        
    ## [100]                   --- him *turning*, I set my      face     towards home, and made the ---                       
    ## [101]                   --- to his springing to his      feet    , *turning* round several times in ---                
    ## [102]               --- working and working his dry      lips     and *turning* his eyes restlessly ---                
    ## [103]                --- dry lips and *turning* his      eyes     restlessly about him far and ---                     
    ## [104]            --- said my convict, *turning* his      eyes     on Joe in a moody ---                                
    ## [105]            --- said Biddy, *turning* away her      head    . _b_ _b_ _b_ _b_ _b_ ---                             
    ## [106]                 --- _b_ _b_ _b_ *turning* his      eyes     round the room _b_ _b_ ---                           
    ## [107]       --- returned Mr. Jaggers, *turning* his      eyes     upon me coolly, and taking ---                       
    ## [108]                     --- spread a hand on each      knee    , and, after *turning* an angry ---                   
    ## [109]             --- and, after *turning* an angry      eye      on the fire for a ---                                
    ## [110]    --- Gradgrind, *turning*, and knitting his     brows     on him _b_ _b_ _b_ ---                               
    ## [111]           --- he said, *turning* his furrowed      face     slowly about, that he might ---                      
    ## [112]           --- _b_ she answered, *turning* her      head     aside _b_ _b_ _b_ _b_ ---                            
    ## [113]           --- said Mr. Harthouse, putting his      hand     upon his shoulder and *turning* ---                  
    ## [114]                 --- putting his hand upon his    shoulder   and *turning* him, so that ---                       
    ## [115]                --- one - and whispered in his      ear     . Without *turning* his head, he ---                  
    ## [116]            --- his ear. Without *turning* his      head    , he conferred with her a ---                         
    ## [117]           --- said Mrs Clennam, *turning* her      face     so that it was addressed ---                         
    ## [118]                --- his irresolute hand to his      lip      again, and *turning* into the ---                    
    ## [119]                    --- packet of snuff in his      hand    , and *turning* upon his interrogator ---             
    ## [120]           --- *turning* his cigar between his      lips     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [121]                --- and *turning* his beads of      eyes     upon his employer _b_ _b_ ---                        
    ## [122]      --- heartrending tone, and *turning* her      face     away _b_ _b_ _b_ _b_ ---                             
    ## [123]                 --- _b_ _b_ _b_ *turning* his     hands     over and over and looking ---                        
    ## [124]            --- wasted heart upon her innocent     breast   , and *turning* to it a ---                           
    ## [125]           --- _b_ The Patriarch *turning* his      head     in a lumbering way towards ---                       
    ## [126]         --- said Mr Flintwinch, *turning* his      head     to retort, as he went ---                            
    ## [127]                --- who had been *turning* her      face     a little away with a ---                             
    ## [128]             --- was discovered -- through all      eyes     *turning* on the speaker -- ---                      
    ## [129]               --- old man, *turning* round on     Fanny     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [130]            --- said Mrs Merdle, *turning* the     bosom     towards that gentleman _b_ _b_ ---                   
    ## [131]             --- said Mrs Gowan, *turning* the     palms     of her hands towards Mr ---                          
    ## [132]                --- *turning* the palms of her     hands     towards Mr Meagles, as if ---                        
    ## [133]               --- His *turning* of his smooth     thumbs    over one another as he ---                           
    ## [134]             --- before, and, *turning* on his      heel     without acknowledgment, went up- stairs. ---         
    ## [135]             --- *turning* the bracelet on her      arm     , and now looking at him, ---                         
    ## [136]            --- Mr Merdle, after *turning* his     tongue    again _b_ _b_ _b_ _b_ ---                            
    ## [137]                 --- _b_ _b_ _b_ *Turning* his      head     in speaking, he had caught ---                       
    ## [138]               --- gently *turning* him by the      arm     , so that they looked into ---                        
    ## [139]           --- fire, whose blue eyes, polished      head    , and silken locks, *turning* towards ---             
    ## [140]         --- his wife, languidly *turning* her    eyelids    a little in his direction (---                       
    ## [141]              --- he was *turning* in Bleeding     Heart     Yard by Mrs Plornish 's ---                          
    ## [142]            --- drew back, *turning* his right     wrist     in a socket made of ---                              
    ## [143]          --- _b_ returned John, *turning* the     wrist     backwards and forwards in the ---                    
    ## [144]              --- John was still *turning* his     wrist    , and still contending with himself ---               
    ## [145]              --- the light, and *turning* his      face     away with a heavy sigh, ---                          
    ## [146]             --- again, and *turning* away his      face     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [147]                         --- by a shrug of his   shoulders   and an apparent *turning* round ---                  
    ## [148]           --- apparent *turning* round of his      eyes     in their sockets before he ---                       
    ## [149]                   --- just over, Tom took the     organ     himself. It was then *turning* ---                   
    ## [150]           --- said Chevy Slyme, *turning* his   bloodshot   eyes towards Tom Pinch _b_ ---                       
    ## [151]      --- Chevy Slyme, *turning* his bloodshot      eyes     towards Tom Pinch _b_ _b_ ---                        
    ## [152]             --- he said, *turning* his glazed      eye      again upon her, without the ---                      
    ## [153]           --- _b_ asked Martin, *turning* his      eyes     upon the speaker _b_ _b_ ---                         
    ## [154]          --- said Mr Pecksniff, *turning* his      eyes     on Tom Pinch, even more ---                          
    ## [155]               --- cried Mrs Gamp, raising her     hands     and *turning* up her eyes ---                        
    ## [156]                --- hands and *turning* up her      eyes     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [157]       --- she answered, *turning* her glowing     cheek     indignantly upon him _b_ _b_ ---                     
    ## [158]              --- *turning* round with a happy      face     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [159]               --- afraid of *turning* up your     finger   , Bill, another pull ! Now, take ---                  
    ## [160]                       --- he was poked in the      back     by a parasol. *Turning* round ---                    
    ## [161]           --- Gravesend, but *turning* a deaf      ear      to all representations that this ---                 
    ## [162]        --- palpitations, and *turning* up her      eyes     replied in a faint voice ---                         
    ## [163]      --- whence, *turning* up her overflowing      eyes    , and clasping her hands, she ---                     
    ## [164]            --- Gamp, *turning* up her languid      eyes    , and clasping Mr Westlock 's ---                     
    ## [165]             --- spoke, and *turning* away his      face    , was silent for a few ---                            
    ## [166]      --- rejoined Mr Gregsbury, *turning* his      back     upon him _b_ _b_ _b_ ---                             
    ## [167]                --- the bed, and *turning* his      face     to the wall, gave free ---                           
    ## [168]                  --- square card into Kate 's      hand    , and, *turning* to his friend, ---                   
    ## [169]            --- creature took his companion 's      arm      and led him away, *turning* ---                      
    ## [170]          --- _b_ snarled Ralph, clenching his     fists     and *turning* a livid white ---                      
    ## [171]           --- said the invalid, *turning* his      head     impatiently towards the adjoining room ---           
    ## [172]                 --- the mere *turning* of his      head     from side to side, watched ---                       
    ## [173]             --- the young lady, *turning* her      head     a little, presented to his ---                       
    ## [174]         --- cried Mr Mantalini, *turning* his      head     towards his wife _b_ _b_ ---                         
    ## [175]               --- hasty *turning* away of the      head    , or drooping of the eyes ---                         
    ## [176]       --- Mulberry, *turning* abruptly on his      heel    , and drawing his pupil with ---                      
    ## [177]           --- the old gentleman *turning* his      head    , and disclosing the features of ---                  
    ## [178]                  --- _b_ _b_ In *turning* his      face     towards the brothers he was ---                      
    ## [179]          --- *turning* upon him with gleaming      eyes     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [180]                   --- the long grass with her      feet    , and often *turning* aside into ---                  
    ## [181]            --- and *turning* up the different     hands     to see what each man ---                             
    ## [182]                  --- saw the *turning* of the      head    , and felt and knew how ---                           
    ## [183]         --- stealthy tread, and *turning* his      face     toward the empty bed, while ---                      
    ## [184]                --- very *turning* in the lock     awoke     a hollow sound, and when ---                         
    ## [185]           --- _b_ replied Nell, *turning* her      head     aside, and speaking softly. _b_ ---                  
    ## [186]                --- form came rolling down his     cheeks    into the pipkin again, *turning* ---                 
    ## [187]               --- *turning* the colour of his      face     and eyelids to a deep ---                            
    ## [188]             --- _b_ said Richard, passing his      hand     over his forehead and *turning* ---                  
    ## [189]                 --- passing his hand over his    forehead   and *turning* suddenly round, as ---                 
    ## [190]                --- _b_ _b_ when *turning* his      head     he found that no Eugene ---                          
    ## [191]      --- daily opportunities of *turning* his      eyes     in Bradley 's direction, soon ---                    
    ## [192]              --- with a downcast and reserved      face    , *turning* something difficult in his ---            
    ## [193]                 --- and when in *turning* his      back     upon the Jew he came ---                             
    ## [194]                   --- heel; and more than one      head    , *turning* to look back at ---                       
    ## [195]        --- returned Mrs Wilfer, *turning* her      eyes     upon her youngest born, with ---                     
    ## [196]                   --- she had looked over her    shoulder   before *turning* out of the ---                      
    ## [197]            --- said Bella, *turning* away her      eyes     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [198]          --- _b_ said Fledgeby, *turning* his      head     towards her; for he had ---                          
    ## [199]                 --- _b_ _b_ _b_ *Turning* his      back     and *turning* a key, Mr ---                          
    ## [200]               --- _b_ she said, *turning* her      head     towards him, but not her ---                         
    ## [201]          --- said Riderhood, *turning* on his      heel     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [202]                  --- the act of *turning* his      eyes     gratefully towards his friend, he ---                
    ## [203]                       --- by the flush in his      face    , and by his sudden *turning* ---                     
    ## [204]            --- said Bella, *turning* her pale      face     from one to another _b_ ---                          
    ## [205]       --- by the folding-doors. *Turning* his      head    , Wegg beheld his persecutor, the ---                 
    ## [206]              --- manner, and *turning* on his      heel    , slunk down the court. Master ---                    
    ## [207]              --- little speaker, from head to      foot    , with indescribable astonishment; and, *turning* --- 
    ## [208]              --- the girl, *turning* away her      head     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [209]           --- said this figure, *turning* his      head     towards the door _b_ _b_ ---                         
    ## [210]              --- the young mag, *turning* his      face     towards the bed, as if ---                           
    ## [211]         --- inn-yard, with a somewhat lighter     heart    . He was *turning* out of ---                         
    ## [212]           --- replied the girl, *turning* her      face     aside, and forcing a laugh ---                       
    ## [213]            --- upon the pillow: *turning* his      eyes     upon her face. They closed; ---                      
    ## [214]               --- *turning* his eyes upon her      face    . They closed; opened again; closed ---               
    ## [215]                  --- _b_ He again applied his      eye      to the glass, and *turning* ---                      
    ## [216]              --- the glass, and *turning* his      ear      to the partition, listened attentively: ---          
    ## [217]          --- cried Fagin, extending his right      hand    , and *turning* to Mr. Bolter ---                     
    ## [218]          --- _b_ replied Sikes, clenching his     teeth     and *turning* white at the ---                       
    ## [219] --- consideration; without once *turning* his      head     to the right or left, ---                            
    ## [220]            --- said Monks, *turning* away his      eyes     and beating his foot upon ---                        
    ## [221]             --- _b_ said Sikes, *turning* his      face     to Crackit _b_ _b_ _b_ ---                           
    ## [222]      --- person addressed, *turning* away his      face     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [223]                    --- he saw Mr. Pickwick 's      eyes     every now and then *turning* ---                     
    ## [224]             --- and *turning* slowly upon his      heel    , disappeared from his sight. _b_ ---                 
    ## [225]          --- intended effect of *turning* all      eyes     to Mr. Pickwick. Serjeant Buzfuz, ---                
    ## [226]         --- said Serjeant Buzfuz, folding his      arms     emphatically, and *turning* half-round to ---        
    ## [227]              --- _b_ said Sam, half *turning*      back     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [228]          --- stumbling hastily into the room,     roused    him. *Turning* his eyes towards ---                  
    ## [229]           --- room, roused him. *Turning* his      eyes     towards the door, they encountered ---               
    ## [230]             --- _b_ said Jingle, pressing his      hand    , and *turning* his head away ---                     
    ## [231]               --- his hand, and *turning* his      head     away _b_ _b_ _b_ _b_ ---                             
    ## [232]                 --- was at length restored to consciousness; then Mr. Ben Allen, *turning* ---                   
    ## [233]            --- *turning* the almanac with its      face     to the wall, trying on ---                           
    ## [234]       --- the pretty housemaid, *turning* her      head     away _b_ _b_ _b_ _b_ ---                             
    ## [235]         --- _b_ inquired Emily, *turning* her      head     aside _b_ _b_ _b_ _b_ ---                            
    ## [236]                 --- _b_ _b_ _b_ *turning* her      eyes     lovingly to him as he ---                            
    ## [237]         --- observed then, *turning* his calm      face     to his nephew with a ---                             
    ## [238]                --- for *turning* his horse 's      head     to the yard (the drunken ---                         
    ## [239]               --- shore, all *turning* on him      eyes     that were changed by the ---                         
    ## [240]        --- said Madame Defarge, *turning* her      eyes     again upon Lucie _b_ _b_ ---                         
    ## [241]     --- headache, it infallibly prevented the      hair     from *turning* grey, it imparted ---                 
    ## [242]               --- his voice and *turning* his      head     towards the door of the ---

### Figure 2: Plot of B1 +“lexical” collocates in DNov quotes vs. non-quotes

This plot is restricted to effect sizes over 1, i.e. more than twice as
frequent.

``` r
plot(results[abs(effect_size)>1])
```

![](DNov_quotes_non-quotes_files/figure-markdown_github/B1_DNov_quotes_vs_non_quotes_lexical-1.png)

Analysis: 3. Comparing B1 + all semantic types in DNov quotes vs. non-quotes
============================================================================

``` r
quotes_text$tokens$type <- with(quotes_type_store, semantic_tags)
non_quotes_text$tokens$type <- with(non_quotes_type_store, semantic_tags)

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
head(non_quotes_text$tokens, 20)
```

    ##     idx  type start end      token
    ##  1:   1  <NA>    13  15        _b_
    ##  2:   2  <NA>    17  19        _b_
    ##  3:   3  <NA>    21  23        _b_
    ##  4:   4  <NA>    25  27        _b_
    ##  5:   5  <NA>    29  31        _b_
    ##  6:   6    Z2    33  38     London
    ##  7:   7  T1.3    41  50 Michaelmas
    ##  8:   8    Q3    52  55       term
    ##  9:   9   T3-    57  62     lately
    ## 10:  10   T2-    64  67       over
    ## 11:  11    Z5    70  72        and
    ## 12:  12    Z5    74  76        the
    ## 13:  13 S7.1+    78  81       Lord
    ## 14:  14  G1.1    83  92 Chancellor
    ## 15:  15    M8    94 100    sitting
    ## 16:  16    Z5   102 103         in
    ## 17:  17    Z2   105 111    Lincoln
    ## 18:  18    Z5   113 114         's
    ## 19:  19    F2   116 118        Inn
    ## 20:  20    H2   120 123       Hall

``` r
# the set of nodes and collocates we are interested in
nodes <- unique(grep("^B1", c(quotes_text$tokens$type, non_quotes_text$tokens$type), value = TRUE))
nodes
```

    ## [1] "B1"

``` r
quotes_surface <- corp_surface(quotes_text, span = "5LR", nodes = nodes)
non_quotes_surface <- corp_surface(non_quotes_text, span = "5LR", nodes = nodes)

# compare
results <- corp_coco(quotes_surface, non_quotes_surface, nodes = nodes)
```

Figure 3: Plot of B1 + “semantic tag collocates” in DNov quotes vs. non-quotes
------------------------------------------------------------------------------

``` r
plot(results)
```

![](DNov_quotes_non-quotes_files/figure-markdown_github/B1_DNov_quotes_vs_non_quotes_semantic-1.png)

Concordances of semantic tag collocates
---------------------------------------

The concordances below have been picked relatively spontaneously from
among the high effect size differences and the unique results. We can
easily add other concordances.

### Concordances of semantic tag collocates: Quotes

``` r
# T1.1.3 ["Time: General: Future"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("T1.1.3"), context = 0)
y
```

    ## [  1]           --- We *will* proceed with the  hearing  on Wednesday fortnight _b_ _b_ ---         
    ## [  2]            --- master in Chancery by the   throat  *to-morrow* morning and shake him ---      
    ## [  3]               --- is that he never wants   sleep  . He *'ll* go at it ---                     
    ## [  4]                --- you *will* be in your   hearts  to one another what you ---                
    ## [  5]                 --- of mine, or horse 's    foot   of mine, *pending* the present ---         
    ## [  6]             --- *will* you come like the  thirsty  swallow upon the *next* *day*, ---         
    ## [  7]            --- you come like the thirsty  swallow  upon the *next* *day*, and ---             
    ## [  8]                  --- care for me in cool   blood  ; and I hope you *will* ---                 
    ## [  9]              --- _b_ They were taken and  secreted. And *to-morrow* night, your ladyship, --- 
    ## [ 10]              --- *soon* come back to his    head   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 11]    --- get through this business without  rousing  his suspicions, I *shall* be ---           
    ## [ 12]                  --- or I *shall* cut my    hand   off _b_ _b_ _b_ _b_ ---                    
    ## [ 13]               --- to catch you round the    neck  . I *wo* n't squeeze you ---                
    ## [ 14]                --- _b_ _b_ _b_ when this    hair   of your mother 's *will* ---               
    ## [ 15]             --- *will* be grey, and this  forehead all crossed and re-crossed with ---        
    ## [ 16]                  --- for you must not be   tired   too *soon*; and my time ---                
    ## [ 17]      --- *shall* ring the alarm-bell and   rouse   the house. And then I ---                  
    ## [ 18]           --- whole town *will* be broad   awake   in another hour. Come along. ---           
    ## [ 19]                       --- It 's got to a    head   now and is *going* *to* ---                
    ## [ 20]              --- sit down. I should have   roused  up *in* *a* *minute* _b_ ---               
    ## [ 21]  --- astonished them already. We *shall*   rouse   up that nest of sleepers, ---              
    ## [ 22]                  --- it. I know from his    lips   that when that person *soon* ---           
    ## [ 23]               --- or I *shall* link your    feet   together at the ankles _b_ ---             
    ## [ 24]                  --- by you. Now take my    arm   , *will* you ? I 'm a ---                   
    ## [ 25]                  --- *wo* n't do that by   crying . As to your son, he ---                    
    ## [ 26]            --- _b_ _b_ *will* break your    neck   if you meddle with wot ---                 
    ## [ 27]         --- and scarred and bruised from    head   to foot, *will* stand by ---               
    ## [ 28]             --- and bruised from head to    foot  , *will* stand by the husband ---           
    ## [ 29]           --- Lady *will* never more set    foot   within these walls _b_ _b_ ---             
    ## [ 30]               --- _b_ _b_ When *will* he   awake   from his delusion _b_ _b_ ---              
    ## [ 31]           --- *will* see me with clearer    eyes  . I can wait _b_ _b_ ---                    
    ## [ 32]                   --- I turn my horse 's    head   homewards, brother, I *will* ask ---       
    ## [ 33]         --- this *will* break Richard 's   heart   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 34]     --- *soon* *as* *possible* after the   breath  was out of his body, ---                   
    ## [ 35]           --- are within five minutes of breathing your last, you *will* not ---              
    ## [ 36]           --- down lightly, or you *'ll*    wake   your mother. She must be ---               
    ## [ 37]                 --- _b_ _b_ _b_ a little   sleepy  myself; I *'ll* own it ---                 
    ## [ 38]              --- he, he ! You *'ll* have    eyes   for somebody besides Miss Dolly ---        
    ## [ 39]           --- and the watchman 's waking     up   . Angelic Miggs ! If you *'ll* ---          
    ## [ 40]                --- _b_ He *'ll* have his    foot   in the stirrup in an ---                   
    ## [ 41]             --- 's daughter with a stout   heart  , and you *shall* win her ---               
    ## [ 42]       --- *shall* see him, mother, bound    hand   and foot, and brought to ---               
    ## [ 43]        --- Depart instantly, or I *will*   rouse   him _b_ _b_ _b_ _b_ ---                    
    ## [ 44]                  --- to do so. *Shall* I   rouse   him _b_ _b_ _b_ _b_ ---                    
    ## [ 45]           --- again. You *shall* beat my    face  , and tear my hair, and ---                 
    ## [ 46]              --- you *will* see. You are  thirsty , I suppose _b_ _b_ _b_ ---                 
    ## [ 47]           --- name being spoken in their  hearing ; I never *will* again subsist ---          
    ## [ 48]               --- it *will* be but empty   breath . I do not believe that ---                 
    ## [ 49]             --- second I *'ll* have your    head   under the biler. How dare ---              
    ## [ 50]      --- gets warmer and Protestants are  thirsty , they *'ll* be pulling London ---          
    ## [ 51]       --- To every Protestant into whose   hands   this *shall* come _b_ _b_ ---              
    ## [ 52]               --- *to* say, holds up his    head  , but that he does not ---                  
    ## [ 53]             --- hear them. They are like    eyes   to me. *Will* they speak ---               
    ## [ 54]             --- 's blessing on the young    feet   that *will* bestir themselves in ---       
    ## [ 55]                      --- and if I do n't   sleep   here, I *shall* not go ---                 
    ## [ 56]                 --- *'ll* be a good many   faces   inside them three windows over ---         
    ## [ 57]           --- master. Fling this over my  shoulder, and buckle it behind, *will* ---          
    ## [ 58]          --- you *will* remember that he  thirsts  for your lives, and those ---              
    ## [ 59]            --- are *going* *to* tie you,    hand   and foot, but otherwise you ---            
    ## [ 60]               --- *to* tie you, hand and    foot  , but otherwise you *wo* n't ---            
    ## [ 61]               --- as had tied the ladies    neck   and heels -- you *'ll* ---                 
    ## [ 62]             --- *to* be burnt over their   heads  , with them in 'em. What ---                
    ## [ 63]        --- _b_ _b_ Strengthen yours with   blood  , and see what it *will* ---                
    ## [ 64]                 --- and set him with his    face   towards the west, he *will* ---            
    ## [ 65]                   --- _b_ _b_ _b_ _b_ my   hands   *shall* drop off at the ---                
    ## [ 66]              --- *shall* drop off at the   wrists , and you *shall* wear them, ---            
    ## [ 67]             --- God bless you, sir. Take   heart  , take heart. We *'ll* find ---             
    ## [ 68]           --- you, sir. Take heart, take   heart  . We *'ll* find them. Be ---                
    ## [ 69]             --- without feeling as if my   heart   would burst. I *shall* remember ---        
    ## [ 70]              --- _b_ you *'ll* hold your   tongue . I tell you I 'm ---                       
    ## [ 71]               --- t' other side and fell   asleep  again. We *shall* see how ---              
    ## [ 72]             --- *'ll* suit you. Try your    hand   upon him _b_ _b_ _b_ ---                   
    ## [ 73]                    --- _b_ That 's a bad  hearing , so *soon*, Clara _b_ _b_ ---              
    ## [ 74]        --- stupid, cross old Peggotty 's    arm    again. And I *'ll* write ---               
    ## [ 75]                     --- As I have got my   breath  now, I think I *'ll* ---                   
    ## [ 76]                   --- _b_ _b_ _b_ Oh, my   lungs   and liver, *will* you go ---               
    ## [ 77]                 --- _b_ Oh, my lungs and   liver  , *will* you go for threepence ---          
    ## [ 78]               --- I *'ll* rip your young    body   open _b_ _b_ _b_ _b_ ---                   
    ## [ 79]               --- _b_ I *'ll* knock your   brains  out _b_ _b_ _b_ _b_ ---                    
    ## [ 80]      --- way - smirking and making great    eyes   at her, I *'ll* be ---                     
    ## [ 81]                   --- sure as you have a    head   upon your shoulders, I *'ll* ---           
    ## [ 82]                --- have a head upon your shoulders, I *'ll* knock your bonnet ---             
    ## [ 83]      --- father: he *will* represent the    head   of our family, he *will* ---               
    ## [ 84]              --- rational a girl as ever  breathed. You *'ll* be worthy of ---                
    ## [ 85]                --- I *shall* have a wary    eye    on all admirers; and *shall* ---           
    ## [ 86]                 --- _b_ _b_ I believe my   breath  *will* get long next, my ---               
    ## [ 87]                 --- leave me for a short    nap   , I *'ll* try and find ---                  
    ## [ 88]                --- _b_ _b_ _b_ You *'ll*   sleep   here, while we stay, and ---               
    ## [ 89]               --- we stay, and I *shall*   sleep   at the hotel _b_ _b_ ---                   
    ## [ 90]               --- to me, a-shaking of my    hand  , " I *will* ! " he says. And ---           
    ## [ 91]             --- make believe with such a    face  , that they 'd as *soon* ---                
    ## [ 92]           --- New River ed - *will* have    gone   to bed these two hours ---                 
    ## [ 93]          --- River ed - *will* have gone     to    bed these two hours _b_ ---                
    ## [ 94]             --- ed - *will* have gone to    bed    these two hours _b_ _b_ ---                
    ## [ 95]           --- *shall* be gone before you    wake   in the morning. Good night ---             
    ## [ 96]            --- It *'ll* soften your poor   heart  , Dan'l _b_ _b_ _b_ _b_ ---                 
    ## [ 97]            --- ever look upon her pritty    face   again. We *'ll* be content ---             
    ## [ 98]        --- something the matter with her   spine  , poor girl. The malady *will* ---          
    ## [ 99]           --- stories ? I *'ll* make Jip    bite   you _b_ _b_ _b_ _b_ ---                    
    ## [100]             --- declare I *'ll* make Jip    bite   you _b_ _b_ _b_ _b_ ---                    
    ## [101]         --- the *imminent* risk of being   bitten , he kept it between his ---                
    ## [102]              --- were *going* *to* buy a  shoulder of mutton for dinner, would ---            
    ## [103]       --- constraint, I *shall* close my    eyes   upon her honoured face, with ---           
    ## [104]                  --- I have shown you my   heart  . I am sure you *will* ---                  
    ## [105]                --- and peace of mind, my    feet   *will* naturally tend towards the ---      
    ## [106]                  --- and call upon me to  swallow  a sword *tomorrow*, and I ---              
    ## [107]                   --- _b_ I *'ll* put my    hand   in no man 's hand ---                      
    ## [108]             --- I wonder, if your loving   heart   *will* not break, you have ---             
    ## [109]                  --- _b_ _b_ and if your    head   is human, I *'ll* break ---                
    ## [110]                --- the words close to my   heart  . I *shall* keep them till ---              
    ## [111]      --- *shall* first pass through this    body   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [112]        --- feeding. Now, sir, about that   brain   of yours, if you *'ll* ---                 
    ## [113]                --- _b_ Tut, Trot; MY old   bones   would have kept till *tomorrow* ---        
    ## [114]         --- with us ? Perhaps you *will*   sleep   in your own room ? We ---                  
    ## [115]                --- _b_ _b_ has poor dear   Fanny   's nature. She *'ll* never ---             
    ## [116]                  --- _b_ _b_ I *'ll* not    wake   him _b_ _b_ _b_ _b_ ---                    
    ## [117]                 --- you do n't shut your    eyes   this minute, I *'ll* call ---              
    ## [118]         --- and regard for, the *future*    head   of my house _b_ _b_ ---                    
    ## [119]         --- to Captain Cuttle. Keep your    eye    upon my Uncle, *will* you, ---             
    ## [120]        --- subject that *shall* pass the    lips   of Joseph Bagstock _b_ _b_ ---             
    ## [121]              --- *soon* after I began to   snore   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [122]            --- swear I *will* refuse the    hand   of this man in the ---                     
    ## [123]                  --- to be as your right    hand  . My name *shall* then be ---               
    ## [124]           --- fine talk, and more strong    arm   , most likely, and there *will* ---         
    ## [125]                 --- crown of a Briton 's    head  , for which you *'ll* overhaul ---          
    ## [126]              --- 'd *sooner* you took my   blood   than my character _b_ _b_ ---              
    ## [127]             --- _b_ arter turning in, my   Heart   's Delight, you *'ll* get ---              
    ## [128]                  --- _b_ _b_ _b_ I *'ll*   rouse   him up here, Beauty _b_ ---                
    ## [129]                --- you, and with my last   breath  I *will* breathe your name ---             
    ## [130]              --- my last breath I *will*  breathe  your name to God if ---                    
    ## [131]           --- *shall* put myself in your   hands   when the time comes. The ---               
    ## [132]            --- *shall* see with your own    eyes   and hear with your own ---                 
    ## [133]                --- of the birdcage in my    hand  , *will* you _b_ _b_ _b_ ---                
    ## [134]             --- with him *shall* pass my    lips  . He 's an ungrateful hound. ---            
    ## [135]                --- -- Wal'r and sweet --   heart   *will* be jined together in ---            
    ## [136]         --- When the silent tomb *shall*    yawn  , Captain Gills, I *shall* be ---           
    ## [137]          --- ever, *will* strike upon my    ears   like a knell you know, ---                 
    ## [138]         --- heerd him complain, you have    woke   me too *soon*, I must ---                  
    ## [139]                --- me too *soon*, I must  slumber  again. Scatter his ene-mies, and ---       
    ## [140]                 --- But you *will* be so   tired  , my love _b_ _b_ _b_ ---                   
    ## [141]                  --- and is sorry in her   heart  . You *will* not forget her ---             
    ## [142]             --- I *shall* never see your    face   again _b_ _b_ _b_ _b_ ---                  
    ## [143]                    --- spare me if he is   awake  , I *will* go immediately _b_ ---           
    ## [144]             --- kissed. But give me your    hand  , and I *'ll* blow a ---                    
    ## [145]               --- _b_ I *'ll* smash your    eye   , if you do n't look ---                    
    ## [146]             --- _b_ _b_ _b_ *Going* *to*    wake   up Egypt a little _b_ ---                  
    ## [147]            --- _b_ _b_ *Going* *to* wake     up    Egypt a little _b_ _b_ ---                 
    ## [148]               --- to the Searcher of all   hearts ; but it *will* never go ---                
    ## [149]             --- now your assurance at my    back  , and *shall* put it in ---                 
    ## [150]                   --- a joint (such as a   haunch  of mutton), and we *'ll* ---               
    ## [151]           --- I wonder whether I *shall*   sleep   to-night ! At all events, I ---            
    ## [152]             --- answer for Mr. Jasper 's    neck  . I *will* tell Durdles to ---              
    ## [153]               --- _b_ I *shall* shed the   blood   of that impish wretch ! I ---              
    ## [154]               --- me ! I *'ll* stone yer    eyes   out, s'elp me ! If I ---                   
    ## [155]                     --- clue to it in my    hand  . That I never *will* relax ---             
    ## [156]           --- room, and *will* cast your    eye    at the second-floor landing window ---     
    ## [157]                --- in this case the long    arm    *will* reach, and the strong ---           
    ## [158]         --- *will* reach, and the strong    arm    will strike. -- This is ---                
    ## [159]                  --- he has taken in the    eyes   of *posterity* ! " Very trying, very ---   
    ## [160]               --- is a vision. I *shall*   sleep   it off. It has been ---                    
    ## [161]           --- vision. I *shall* sleep it    off   . It has been too short ---                 
    ## [162]                  --- or I *'ll* cut your   throat  _b_ _b_ _b_ _b_ _b_ ---                    
    ## [163]                 --- Or I *'ll* have your   heart   and liver out _b_ _b_ ---                  
    ## [164]            --- *'ll* have your heart and   liver   out _b_ _b_ _b_ _b_ ---                    
    ## [165]                --- small it is, and your   heart   and your liver *shall* be ---              
    ## [166]              --- and your heart and your   liver   *shall* be tore out, roasted ---           
    ## [167]         --- afterwards. I *'ll* beat the  shivers  so far, I 'll bet ---                      
    ## [168]       --- service, *will* you throw your    eye    over them _b_ _b_ _b_ ---                  
    ## [169]                    --- my men can beat a    hand   anywhere, they *'ll* make themselves ---   
    ## [170]          --- flats likewise - look at my    leg   : you *wo* n't find much ---                
    ## [171]                     --- _b_ He 's a liar    born  , and he *'ll* die a ---                    
    ## [172]                  --- or the pot *wo* n't    bile  , do n't you know _b_ ---                   
    ## [173]                --- take him with his own   hands   to Miss Havisham 's *to-morrow* ---        
    ## [174]                    --- _b_ _b_ _b_ at my    head   ! And yours *will* be there ! ---          
    ## [175]          --- *shall* give you your money    back   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [176]                --- there 's not much bad   blood   about. They *'ll* do it, ---               
    ## [177]                 --- or you *'ll* get its    head   under the table _b_ _b_ ---                
    ## [178]                  --- though I know it 's   tiring  to strangers - *will* you tip ---          
    ## [179]                   --- I *'ll* show you a   wrist  . Molly, let them see your ---              
    ## [180]                   --- I *'ll* show you a   wrist   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [181]          --- Come ! You *shall* not shed   tears   for my cruelty to-day; you ---             
    ## [182]         --- sake, give me your blackened    hand   ! - I *shall* be down *soon*, ---          
    ## [183]       --- affairs entirely into your own   hands  , and you *will* draw from ---              
    ## [184]                  --- hit the nail on the    head  . Mr. Pip, I *'ll* put ---                  
    ## [185]                  --- men 's and women 's   faces   *wos* like, I see yourn. ---               
    ## [186]            --- a shroud hanging over her    arm   , and she says she *'ll* ---                
    ## [187]            --- 'and Magwitch, lend her a    hand  , *will* you ? ' But he never ---           
    ## [188]            --- court, I *'ll* smash that    face   of yourn ! ' ai n't it ---                 
    ## [189]             --- them on shelves over his    head  , and *will* weigh them all. ---            
    ## [190]               --- Give the child into my   hands  , and I *will* do my ---                    
    ## [191]                    --- I *wo* n't have a    bone   of you, left on earth. ---                 
    ## [192]              --- earth. I *'ll* put your    body   in the kiln - I 'd ---                     
    ## [193]                 --- you may force him to  swallow  boiling fat, but you *shall* ---           
    ## [194]                 --- _b_ _b_ Then give it   mouth   in your own building, *will* ---           
    ## [195]          --- in a handkerchief under his    arm   . She *will* never believe it ---           
    ## [196]                --- him that came into my   heart  , and *presently* he was quiet ---          
    ## [197]                 --- n't be said before a    born   lady, this lady *will* leave ---           
    ## [198]                 --- can be said before a    born   lady, this lady *will* stay ---            
    ## [199]                --- way, I *'ll* have the    skin   off her nose, at all ---                   
    ## [200]              --- never do 't. The strong    hand   *will* never do 't. Vict'ry ---            
    ## [201]    --- rather troubled with shortness of   breath , and so *put* it *off* ---                 
    ## [202]                  --- t' turn, but a good   heart   *will* coom to me _b_ ---                  
    ## [203]         --- what. Show me a dissatisfied    Hand  , and I *'ll* show you ---                  
    ## [204]             --- sir. It *will* warm your   heart  . It is the sort of ---                     
    ## [205]              --- of you and cooling your    head  . *Will* you see father ? Sissy ---         
    ## [206]               --- may be, I *will* never    tire   of trying. *Will* you let ---              
    ## [207]                --- *will* be to put your    feet   into the hottest water you ---             
    ## [208]                --- _b_ I *will* hold thy    hand  , and keep beside thee, Stephen, ---        
    ## [209]                    --- _b_ _b_ _b_ I can    wake   when I *will*, I can ---                   
    ## [210]                 --- when I *will*, I can   sleep   when I *will*. It 's ---                   
    ## [211]                  --- 'd as *soon* have a    spit   put through me, and be ---                 
    ## [212]                  --- _b_ _b_ _b_ _b_ _b_   Fanny   is not *going* *to* live ---               
    ## [213]            --- you *shall* hear before I   sleep   -- and in six words, ---                   
    ## [214]                  --- to place it in your   hands  , you *will* much oblige me ---             
    ## [215]                    --- _b_ _b_ that I am   tired  , and *will* go home to ---                 
    ## [216]               --- I am tired, and *will*     go    home to bed _b_ _b_ ---                    
    ## [217]            --- tired, and *will* go home     to    bed _b_ _b_ _b_ _b_ ---                    
    ## [218]                --- and *will* go home to    bed    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [219]               --- Father, dear, I am not   tired  ; let me come back *presently*, ---         
    ## [220]             --- to keep the neighbours '    eyes   off, he *'ll* sit there, ---               
    ## [221]                --- you *will* be a right    hand   to the other. Here 's ---                  
    ## [222]                 --- he *'ll* have a good   sleep   to-night along o' hearing about ---        
    ## [223]                   --- is in that lady 's   heart  , and think what a *future* ---             
    ## [224]         --- consequences are on your own    head  ), I *will* say this much: ---              
    ## [225]                    --- I tell you not to   Fanny   me, for I *'ll* not ---                    
    ## [226]              --- thank you. Give me your    arm    again, Mr Nandy. We *shall* ---            
    ## [227]            --- soul, I trust this *will*   rouse   him -- messengers must be ---              
    ## [228]              --- you *will* give me your    arm    we *will* pass among our ---               
    ## [229]                 --- I *will* not try to,   Fanny  . Do n't be angry _b_ ---                   
    ## [230]                --- _b_ _b_ _b_ Hold your   tongue  ! I *will* hear no more ---                
    ## [231]              --- *will* you give me your    arm    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [232]       --- put something into your little    head  . You *wo* n't guess what ---               
    ## [233]              --- him. He *will* turn his    face   in a moment. No one ---                    
    ## [234]                 --- far, I *'ll* cut his    hair   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [235]                --- _b_ _b_ _b_ I *will*,   Fanny  , as well as I can ---                      
    ## [236]            --- am *going* *to* lose you,   Fanny   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [237]             --- *'ll* be walking in your   sleep   next, my woman, and playing ---            
    ## [238]                --- _b_ _b_ _b_ *Shall* I     go    to bed _b_ _b_ _b_ ---                     
    ## [239]                 --- _b_ _b_ *Shall* I go     to    bed _b_ _b_ _b_ _b_ ---                    
    ## [240]                  --- _b_ *Shall* I go to    bed    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [241]   --- discerned clearly, brightly. Not a    hair   of her head *shall* be ---                 
    ## [242]                    --- Not a hair of her    head   *shall* be harmed before Thee. ---         
    ## [243]                 --- or *shall* I hold my    hand   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [244]             --- she *will* require to be   roused , on more accounts than one ---             
    ## [245]              --- Mouse *will* have to be   roused . Also, from the effects of ---             
    ## [246]             --- _b_ *will* require to be   roused  from the effects of many ---               
    ## [247]             --- she *will* require to be   roused  from a low tendency which ---              
    ## [248]                    --- as a lever in the   hands   of counsel. *Will* you excuse ---          
    ## [249] --- that imprisonment *will* subdue your   blood   much *sooner* than it softens ---          
    ## [250]        --- enchanted, and with all their   hearts  ravished. How strongly *will* you ---      
    ## [251]            --- comforting as I ought. My   tears   *will* make their way. I ---               
    ## [252]                    --- to me, or I *'ll*   rouse   the neighbourhood ! I *'ll* throw ---      
    ## [253]            --- Fire and Murder ! I *'ll*    wake   the dead ! Stop where you ---              
    ## [254]         --- *'ll* make shrieks enough to    wake   the dead _b_ _b_ _b_ ---                   
    ## [255]                  --- tell it with my own    lips  , and *will* express myself throughout ---  
    ## [256]           --- of these papers in another    hand  . *Put* *off* the time till ---             
    ## [257]          --- to your merciful and gentle   heart  , is, that you *will* not ---               
    ## [258]                   --- that man 's on his    legs  . You *wo* n't have occasion ---            
    ## [259]                 --- _b_ _b_ _b_ _b_ Both   hands  , Tom. I *shall* write to ---               
    ## [260]             --- *will* not, upon the one    hand  , go so far as to ---                       
    ## [261]           --- *shall* ever look upon her    face   again _b_ _b_ _b_ _b_ ---                  
    ## [262]              --- -- you *shall* try your    hand   on these proposals for a ---               
    ## [263]                    --- He *'ll* do. I am   tired   with the bustle of to-day, ---             
    ## [264]            --- think, than being read to   sleep  . You *wo* n't mind my ---                  
    ## [265]                 --- You *wo* n't mind my   going   to sleep, if I can ---                     
    ## [266]               --- *wo* n't mind my going     to    sleep, if I can _b_ ---                    
    ## [267]               --- _b_ _b_ Tread upon his    foot  , *will* you be so good ---                 
    ## [268]                --- _b_ _b_ _b_ _b_ Come,    wake   up, father, or you *'ll* ---               
    ## [269]               --- _b_ _b_ _b_ Come, wake     up   , father, or you *'ll* be ---               
    ## [270]                  --- 's nothing to say a   joint   *wo* n't yield -- a ---                    
    ## [271]      --- There 's fowls *to-morrow*. Not   skinny  ones. Oh no _b_ _b_ ---                    
    ## [272]          --- hear him complain, you have    woke   me too *soon*, I must ---                  
    ## [273]                --- me too *soon*, I must  slumber  again. If any young orphan ---             
    ## [274]           --- the nethermost atom of his    heel  . Of his daughters I *will* ---             
    ## [275]                    --- But I see you are   tired   to death, and *will* wish ---              
    ## [276]           --- getting too bad. Hold your   tongue , *will* you _b_ _b_ _b_ ---                
    ## [277]             --- alone for that. He *'ll*   snore   for six, at any time ---                   
    ## [278]           --- may be Prooshans; they are    born   so, and *will* please themselves. ---      
    ## [279]               --- I never *will* give my    hand  , papa " -- those were her ---              
    ## [280]     --- journey, *will* be very grateful    Toe    the Major and our fellow-citizens. ---     
    ## [281]                 --- me, *will* you. Am I   awake   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [282]                  --- I *'ll* give you an    arm    back. The goods is safe ---                
    ## [283]                --- *'ll* give you an arm    back  . The goods is safe enough, ---             
    ## [284]                --- with a patch over his    eye    *shall* dictate to me or ---               
    ## [285]                      --- I 've a drop of   breath  to draw, *will* I set ---                  
    ## [286]            --- very *soon* come under my   hands  . Allow me to illustrate this. ---          
    ## [287]                 --- _b_ In Mr Crimple 's    leg   , you *'ll* observe _b_ _b_ ---             
    ## [288]                --- let us have plenty of    leg    pieces, Pip, and I *'ll* ---               
    ## [289]                --- in your head. I *'ll*    wake   him _b_ _b_ _b_ _b_ ---                    
    ## [290]                --- _b_ _b_ _b_ *Shall* I    bite   it _b_ _b_ _b_ _b_ ---                     
    ## [291]           --- *soon* have thought of his    head   leaving him _b_ _b_ _b_ ---                
    ## [292]               --- I *'ll* try him again.   Asleep , sir _b_ _b_ _b_ _b_ ---                   
    ## [293]             --- vent, or it *will* bust.    Toe    you, Mr Pogram, I am ---                   
    ## [294]           --- *shall* punish the Boar 's    Head   dreadfully _b_ _b_ _b_ _b_ ---             
    ## [295]           --- knock. *Will* you put your    head   out of window, and tell ---                
    ## [296]              --- drawn on with an artful    hand  , or he *'ll* not follow. ---               
    ## [297]                --- And *wo* n't save the    head   " ! No, no. No ! Ha, ha, ---               
    ## [298]         --- most sanguine country on the    face   of the earth, and *will* ---               
    ## [299]         --- duties to perform than that.   Rouse   yourself, Mr Chuzzlewit. *Shall* I ---     
    ## [300]             --- makes a winter, than one  swallow  makes a summer. I *'ll* ---                
    ## [301]            --- *'ll* give my sister your    arm   , we *'ll* take her between ---             
    ## [302]               --- _b_ I *'ll* knock your   brains  out, if you speak another ---              
    ## [303]      --- the truckle-bed made. I *shall*   sleep   there to-night, and maybe *to-morrow* ---  
    ## [304]               --- joy, Mark, with all my   heart  . I *shall* see you again ---               
    ## [305]             --- *will* now, from his own    lips  . It is due to him ---                      
    ## [306]            --- She *will* open Martin 's    eyes   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [307]                    --- _b_ If you hurt a    hair   of her head, you *shall* ---               
    ## [308]                   --- hurt a hair of her    head  , you *shall* answer it. Poor ---           
    ## [309]                    --- not a hair of her    head   ill-used ! I *wo* n't bear ---             
    ## [310]               --- he 's a shiverin' from    head   to foot I *'ll* raise ---                  
    ## [311]             --- a shiverin' from head to    foot   I *'ll* raise a uproar ---                 
    ## [312]                  --- I know it *will* be    gall   and wormwood to you ! I ---                
    ## [313]         --- voice *will* whisper in your    ear   , Mr Chuzzlewit, " This was not ---         
    ## [314]             --- I never expected it; the   breath  is no *sooner* out of ---                  
    ## [315]               --- no *sooner* out of his    body   than I am to be ---                        
    ## [316]         --- the eldest, kissing her fair  forehead. " The veil *shall* never cast ---         
    ## [317]             --- you spurned. Find me the    cell   which *shall* be colder than ---           
    ## [318]      --- *will* smile though priests may   frown  , and *next* *day* the sun ---              
    ## [319]            --- schoolroom; and lend me a    hand   with my school-coat, *will* you ---        
    ## [320]                 --- and I *'ll* take the    skin   off his back _b_ _b_ ---                   
    ## [321]                   --- _b_ _b_ _b_ _b_ My   heart   *will* break. It *will*, it ---            
    ## [322]                    --- _b_ _b_ _b_ Oh my    eye   , *wo* n't I give it ---                    
    ## [323]                   --- _b_ _b_ _b_ _b_ or   Fanny   *will* be saying it 's ---                 
    ## [324]              --- sharp out for a brokken    head  , *next* *time* he cums under ---           
    ## [325]                --- *day* able to turn my    back   upon this accursed place, never ---        
    ## [326]              --- I *will* twist his demd    nose   off his countenance for leaving ---        
    ## [327]               --- Anthony 's fire in her    face  , I *shall* be glad of ---                  
    ## [328]             --- _b_ _b_ you *'ll* *soon*    hand   over _b_ _b_ _b_ _b_ ---                   
    ## [329]               --- family as you *wo* n't   sleep   at home for three nights ---               
    ## [330]          --- Canterbury had n't the same    eyes   as you -- you *'ll* ---                    
    ## [331]                  --- _b_ _b_ _b_ _b_ The   Blood   Drinker " *will* die with that ---         
    ## [332]            --- *shall* save him a broken    head  , if he talks till midnight ---             
    ## [333]           --- *will* awaken even in your   breast . 'Your brother 's widow and ---            
    ## [334]                --- to tell her where the    body   is. She *will* be a ---                    
    ## [335]                --- widow. I *shall* be a    body  . Some handsome women *will* cry; ---       
    ## [336]             --- allowance. I *will* be a    body   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [337]   --- *will* nothing stop their infernal  throats  _b_ _b_ _b_ _b_ _b_ ---                    
    ## [338]           --- besides. You may wring his    neck   if you please. I *shall* ---               
    ## [339]              --- grave. I *'ll* slit his    nose   and ears, flog him, maim ---               
    ## [340]              --- *'ll* slit his nose and    ears  , flog him, maim him for ---                
    ## [341]                  --- _b_ _b_ _b_ you 're   tired   -- fagged. I *'ll* tell ---                
    ## [342]               --- _b_ _b_ when he *will*   sleep  , and never wake again on ---               
    ## [343]           --- he *will* sleep, and never    wake   again on earth. We have ---                
    ## [344]                --- -- you *'ll* pinch my    arm    black and blue. Go away, ---               
    ## [345]           --- off the stoutest beadle 's    head  , you *will* find my card ---               
    ## [346]                --- it. But I *will* say,   Fanny  , that times out of number ---              
    ## [347]               --- and I *'ll* knock that    head   of yours in among the ---                  
    ## [348]                 --- I *shall* not put my  fingers  in my ears, though your ---                
    ## [349]              --- am not *going* *to* lay   hands   upon him, but he *shall* ---               
    ## [350]         --- know his black and dastardly   heart  , he *'ll* drive me mad ---                 
    ## [351]             --- hour, its weary days and sleepless nights, with these I *'ll* ---             
    ## [352]              --- They *shall* not hurt a    hair   of your head, or the ---                   
    ## [353]              --- tear of surprise in her    eye   . There *'ll* be a few ---                  
    ## [354]                  --- *'ll* be a few more   tears   of surprise there before long, ---         
    ## [355]                  --- I could not draw my   breath . I *'ll* tell you what ---                 
    ## [356]         --- *are* *about* *to* give your    hand  , some of his deeds you ---                 
    ## [357]                  --- _b_ _b_ and I *'ll*   rouse   the street with such screams, ---          
    ## [358]          --- *tomorrow*, and he *'ll* be  gnawing  his fingers off: perhaps drown ---         
    ## [359]              --- he *'ll* be gnawing his  fingers  off: perhaps drown himself or ---          
    ## [360]             --- keyhole. And now I *'ll*     go    to sleep till half-past five, ---          
    ## [361]                   --- And now I *'ll* go     to    sleep till half-past five, when ---        
    ## [362]                    --- now I *'ll* go to   sleep   till half-past five, when I ---            
    ## [363]          --- disturbed. We *'ll* go down    arm    in arm _b_ _b_ _b_ ---                     
    ## [364]                 --- *'ll* go down arm in    arm    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [365]           --- stolen, and they *'ll* lay   hands   upon her, trust me. Here ! ---             
    ## [366]              --- fret and waste away his   heart   to shreds, those we *'ll* ---              
    ## [367]            --- any human feeling in your   breast , *will* make even you shrink ---           
    ## [368]         --- *shall* have some cutting of  throats  before dinner _b_ _b_ _b_ ---              
    ## [369]                --- _b_ I *'ll* tear your    eyes   out _b_ _b_ _b_ _b_ ---                    
    ## [370]                  --- _b_ I *'ll* turn my    face   homewards, leaving my love for ---         
    ## [371]                  --- hear it with my own    ears  , I never *will* believe it ---             
    ## [372]        --- these beldames again, I *'ll*    bite   you _b_ _b_ _b_ _b_ ---                    
    ## [373]             --- nail, I *'ll* pinch your    eyes  , if you talk to me ---                     
    ## [374]           --- the wharf. Stand upon your    head   agin, and I *'ll* cut ---                  
    ## [375]                --- *'ll* cut one of your    feet   off _b_ _b_ _b_ _b_ ---                    
    ## [376]               --- you both. I *'ll* take    bot    of you, both together, both ---            
    ## [377]  --- copper-coloured, I *'ll* break your   faces   till you have n't a ---                    
    ## [378]                  --- till you have n't a  profile  between you, I *will* _b_ ---              
    ## [379]                --- *'ll* drop it on your   skull  , you dog _b_ _b_ _b_ ---                   
    ## [380]                --- I *will* be there and    back  , before breakfast _b_ _b_ _b_ ---          
    ## [381]                 --- go; and when you are   tired  , you *shall* stop to rest ---              
    ## [382]              --- you dog, or you *shall*  swallow  the pipe _b_ _b_ _b_ ---                   
    ## [383]              --- dear, we *'ll* turn our   faces   from this scene of sorrow, ---             
    ## [384]                 --- and let me wring its    neck   *will* you ? He said I ---                 
    ## [385]                 --- or I *'ll* wring its    neck   myself _b_ _b_ _b_ _b_ ---                 
    ## [386]       --- *will* witness; and placing my   finger  upon this blue wafer with ---              
    ## [387]                  --- _b_ or I *'ll* make   faces   at you and throw you ---                   
    ## [388]          --- day, Sir, p'r'aps you *'ll*   waken  , from pleasure 's dream to ---             
    ## [389]      --- have been *soon* refreshed, and   slept   the sounder for it. Think ---              
    ## [390]              --- snap him up before your    eyes  , he *will* _b_ _b_ _b_ ---                 
    ## [391]                --- which of us *will* be   tired   first _b_ _b_ _b_ _b_ ---                  
    ## [392]                --- then, and has gone to   sleep   for two years, I *shall* ---               
    ## [393]              --- to think he *'ll* never    wake   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [394]           --- not up yet. Nothing *will*    wake   him, sir. What 's to ---                   
    ## [395]             --- Go further away from the    leg    of mutton, or you *'ll* ---                
    ## [396]              --- not keep on pulling his    ears  , please. I know he *wo* ---                
    ## [397]           --- miles off. She *'ll* never    wake   till it 's all over, ---                   
    ## [398]            --- die, with what a grateful   heart   I *shall* thank God for ---                
    ## [399]              --- do n't speak above your   breath , or I *'ll* choke you ---                  
    ## [400]            --- gone, ma'am, to where his    legs   *will* never come in question. ---         
    ## [401]            --- yard that *'ll* growl and    bite   -- I *'ll* have man-traps, ---             
    ## [402]                --- I *'ll* take down the   heads   if you please, sir. Remarkable ---         
    ## [403]          --- ground entirely with my own   hands  . By this time *next* *year* ---            
    ## [404]             --- boy, looking up into her    face  , that you *will* be an ---                 
    ## [405]                  --- _b_ _b_ on what gay   heads   other earth *will* have closed, ---        
    ## [406]          --- goodness, sir, to take that    arm   . I *'ll* take this one. ---                
    ## [407]             --- *will* say with my dying   breath  that he put that note ---                  
    ## [408]         --- expression of your monkey 's    face  , I *will* _b_ _b_ _b_ ---                  
    ## [409]               --- know. If you shut your    eyes  , perhaps you *'ll* go to ---               
    ## [410]         --- your eyes, perhaps you *'ll*     go    to sleep. You *'ll* be ---                 
    ## [411]           --- eyes, perhaps you *'ll* go     to    sleep. You *'ll* be all ---                
    ## [412]              --- perhaps you *'ll* go to   sleep  . You *'ll* be all the ---                  
    ## [413]                --- I *will* make a clean   breast . Mr Witherden, sir, a kind ---             
    ## [414]          --- *day* or another, with your    legs   under the mahogany in my ---               
    ## [415]         --- *will* remember how the same    face   and figure -- often the ---                
    ## [416]              --- *will* miss it when she   wakes  . They have hid it here ---                 
    ## [417]      --- things which *will* soften your   heart  , dear friend, and open it ---              
    ## [418]                --- _b_ _b_ We *will* not    wake   her. I should be glad ---                  
    ## [419]             --- good time. We *will* not    wake   her _b_ _b_ _b_ _b_ ---                    
    ## [420]                 --- among you to wean my   heart   from her. You never *will* ---             
    ## [421]         --- strong reason, let pass your    lips   what I am *going* *to* ---                 
    ## [422]                --- cup and sarser to his    lips  . Mr Lightwood, I *will* now ---            
    ## [423]            --- scanty box outside in the shivering wind, which I was *going* ---              
    ## [424]                --- with his glass in his    eye    ! Oh what *shall* I do ---                 
    ## [425]          --- brother was *going* *to* be    born   *by-and-by*, " this, " says M. R. ---      
    ## [426]         --- slept, Mrs Boffin, And never    woke   again ma'am. I *'ll* tell ---              
    ## [427]      --- pretty child under cart- horses    feet   and a loaded waggon, *sooner* ---          
    ## [428]          --- *sooner* than fall into the   hands   of those Cruel Jacks we ---                
    ## [429]         --- *shall* always rest upon his    head   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [430]        --- not *going* *to* forgive you.     Go    to bed this moment _b_ ---                 
    ## [431]         --- *going* *to* forgive you. Go     to    bed this moment _b_ _b_ ---                
    ## [432]              --- *to* forgive you. Go to    bed    this moment _b_ _b_ _b_ ---                
    ## [433]                --- for it would make you  thirsty  all day. *Will* you have ---               
    ## [434]             --- _b_ Who really *will* be   tired   of waiting _b_ _b_ _b_ ---                 
    ## [435]              --- but that I believe your    face   and voice, and I *will*, ---               
    ## [436]              --- far *sooner* be upon my    feet   and tiring of myself out, ---              
    ## [437]       --- Trudging round the country and   tiring  of myself out, I *shall* ---               
    ## [438]        --- least, I *will* leave nothing   unsaid  _b_ _b_ _b_ _b_ _b_ ---                    
    ## [439]                  --- _b_ _b_ I *'ll* not   unsay   them. I *'ll* say them ---                 
    ## [440]            --- *'ll* look rummer when he   wakes  ; *wo* n't they _b_ _b_ ---                 
    ## [441]       --- remember mamma 's clasping her   hands  , and exclaiming " This *will* end ---      
    ## [442]                   --- sir, as fast as my    leg    *will* bring me _b_ _b_ ---                
    ## [443]                --- _b_ _b_ _b_ She *'ll*    bile   in a couple of minutes ---                 
    ## [444]                 --- am found dead at the    foot   of the Cross, it *will* ---                
    ## [445]                      --- to get it on my    arm    ? I *will* do it by ---                    
    ## [446]                  --- _b_ I *'ll* wash my   hands   of Mr Dolls physically --' ---             
    ## [447]            --- said Yoicks. Look to your    feet  , Mortimer, for we *shall* try ---          
    ## [448]                   --- ago. But if he has    gone   to bed, I *'ll* put ---                    
    ## [449]                   --- But if he has gone     to    bed, I *'ll* put a ---                     
    ## [450]                    --- if he has gone to    bed   , I *'ll* put a paper ---                   
    ## [451]                --- Have you no scheme on    foot   that *will* bring in anything ---          
    ## [452]           --- *'ll* go further. A wooden    leg    ca n't bear it _b_ ---                     
    ## [453]               --- an act of sneaking and  sniffing. And his nose *shall* be ---               
    ## [454]       --- sneaking and sniffing. And his    nose   *shall* be put to the ---                  
    ## [455]               --- And for that, too, his    nose   *shall* be put to the ---                  
    ## [456]                   --- 's nose to it. His    nose   once brought to it, *shall* ---            
    ## [457]                  --- for it ai n't worth  hearing , and *wo* n't go down ---                  
    ## [458]                  --- beg and pray, or my   heart   *will* break if this goes ---              
    ## [459]               --- my Bella folded in the    arms   of her *future* husband, HERE, ---         
    ## [460]                 --- _b_ _b_ _b_ put your    hand   in mine, and we *'ll* ---                  
    ## [461]                     --- Ma. I have had a   tiring  day, and I *'ll* go ---                    
    ## [462]              --- tiring day, and I *'ll*     go    to bed _b_ _b_ _b_ ---                     
    ## [463]                  --- day, and I *'ll* go     to    bed _b_ _b_ _b_ _b_ ---                    
    ## [464]                    --- and I *'ll* go to    bed    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [465]           --- sounder and longer you can   sleep  , the better you *'ll* know ---             
    ## [466]               --- make him uneasy in his   sleep  . *Shall* I loosen it for ---               
    ## [467]                    --- my eyes out of my    head  , and Ma *will* he sure ---                 
    ## [468]               --- you *'ll* keep one and    hand   over the others _b_ _b_ ---                
    ## [469]               --- _b_ you *'ll* cut your    hand   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [470]                  --- _b_ _b_ _b_ _b_ His    eyes   are closing. He *'ll* be ---               
    ## [471]          --- little picter lying on your    lap   , and you *shall* be told ---               
    ## [472]      --- an everlasting dustman with his    head   tied up ! *WILL* he, too ! ---             
    ## [473]                    --- _b_ But it ai n't    weed   neither. You *'ll* never guess, ---        
    ## [474]                    --- to know in my own   heart   that I am not *going* ---                  
    ## [475]                 --- and there 's both MY   hands  , Miss, and I *'ll* *soon* ---              
    ## [476]           --- *Will* you stand upon your    legs  , you young devil _b_ _b_ ---               
    ## [477]                --- _b_ _b_ _b_ Hold your   tongue  this instant, or I *'ll* ---               
    ## [478]            --- there; he *'ll* *soon* be   tired   of that _b_ _b_ _b_ ---                    
    ## [479]                   --- _b_ I *'ll* eat my    head  , sir _b_ _b_ _b_ _b_ ---                   
    ## [480]            --- staircase, I *'ll* eat my    head  , and his too _b_ _b_ ---                   
    ## [481]                  --- sir, I *'ll* eat my    head   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [482]           --- we *shall* go breaking our   necks  , or treading on the dog. ---               
    ## [483]                --- or I *'ll* split your    head   against the wall _b_ _b_ ---               
    ## [484]                    --- or I *'ll* eat my    head   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [485]                 --- this job you have on    hand  , you *'ll* prevent his ever ---            
    ## [486]          --- by shooting him through the    head  , and *will* take your chance ---           
    ## [487]          --- waiting, you *'ll* put some   heart   in us; or in me, ---                       
    ## [488]                --- or I *'ll* strew your   brains  upon the grass _b_ _b_ ---                 
    ## [489]                 --- time; but I held her   hands  , and she *soon* dropped off. ---           
    ## [490]             --- that is, she *'ll* never    wake   again but once -- and ---                  
    ## [491]                --- or I *shall* knock my   brains  out against something in this ---          
    ## [492]               --- first. I *wo* n't shed   blood  ; it 's always found out, ---               
    ## [493]              --- man *will* do, when his   blood   is up. I should have ---                   
    ## [494]               --- yet to come. He *will*    wake   in an hour or so, ---                      
    ## [495]         --- the world visits on innocent   heads  . I *will* carry it into ---                
    ## [496]              --- *will* carry it into no   blood   but my own; and the ---                    
    ## [497]                 --- I *will* lay at your    feet  , whatever of station of fortune ---        
    ## [498]             --- Are you *going* *to* sit  snoring  there, all day _b_ _b_ ---                 
    ## [499]               --- and although I was not  snoring , I *shall* snore, gape, sneeze, ---        
    ## [500]           --- was not snoring, I *shall*   snore  , gape, sneeze, laugh, or cry, ---          
    ## [501]      --- snoring, I *shall* snore, gape,   sneeze , laugh, or cry, as the ---                 
    ## [502]               --- You *'ll* keep a quiet   tongue  in your head, *will* you ---               
    ## [503]                   --- if you mix it with   biling  water, it *'ll* go nigh ---                
    ## [504]                    --- of that out of my   mouth  , or it *'ll* choke me ---                  
    ## [505]                  --- and put on your own    face  ; or I *'ll* alter it ---                   
    ## [506]               --- _b_ _b_ give away your   hearts , love *will* carry you all ---             
    ## [507]           --- *will* take an interest in  hearing  of him again _b_ _b_ ---                   
    ## [508]                 --- one ! I *'ll* eat my    head   if he is not a ---                         
    ## [509]                 --- _b_ He *'ll* eat his    head  , if he does n't _b_ ---                    
    ## [510]                --- _b_ _b_ _b_ Hold your   tongue , *will* you _b_ _b_ _b_ ---                
    ## [511]                  --- such a grip on your   throat  as *'ll* tear some of ---                  
    ## [512]                 --- of that fever in her   blood   yet, and it *wo* n't ---                   
    ## [513]               --- *'ll* let her a little   blood  , without troubling the doctor, if ---      
    ## [514]           --- It *will* never reach your    ears  , dear lady, and God forbid ---             
    ## [515]               --- *shall* be for want of   breath . Open your mouth and say ---               
    ## [516]        --- *will* have passed into other   hands  ; and do not say I ---                      
    ## [517]                --- take a paper from her    hand  , and watched you too, *next* ---           
    ## [518]         --- kindest, best of friends. My   heart   *will* burst. I can not ---                
    ## [519]                   --- a pang, but one my   heart   *shall* bear _b_ _b_ _b_ ---               
    ## [520]              --- Say only one, upon your   knees  , with me, and we *will* ---                
    ## [521]                    --- _b_ _b_ Say I 've    gone   to sleep -- they *'ll* ---                 
    ## [522]                   --- _b_ Say I 've gone     to    sleep -- they *'ll* believe ---            
    ## [523]                    --- Say I 've gone to   sleep   -- they *'ll* believe you. ---             
    ## [524]              --- I *shall* place in your   hands   a note for my -- ---                       
    ## [525]                  --- he tapped me on the  shoulder. Never *shall* I forget the ---            
    ## [526]             --- a madman. Down with you.   Blood  , blood ! I *will* have it ! " ---          
    ## [527]        --- madman. Down with you. Blood,   blood   ! I *will* have it ! " _b_ ---             
    ## [528]           --- that remark fell from your    lips  , sir, she *will* indeed be ---             
    ## [529]                  --- give 'em at once --    back   *in* *a* *minute* _b_ _b_ ---              
    ## [530]                 --- *sha* n't be long --    back   in no time _b_ _b_ ---                     
    ## [531]           --- When I *wos* first pitched    neck   and crop into the world, ---               
    ## [532]            --- servant *will* give you a    leg    up _b_ _b_ _b_ _b_ ---                     
    ## [533]             --- servant *will* give me a    leg    up _b_ _b_ _b_ _b_ ---                     
    ## [534]                    --- me, it 's time to     go    to bed. It *will* never ---                
    ## [535]                     --- it 's time to go     to    bed. It *will* never do, ---               
    ## [536]                     --- 's time to go to    bed   . It *will* never do, sitting ---           
    ## [537]             --- *will* be my excuse. The    back   kitchen 's empty, Sir. If ---              
    ## [538]          --- went back *next* *day*, and swallowed another bead _b_ _b_ _b_ ---               
    ## [539]           --- last, *will* recoil on the    head   of the attempter, be he ---                
    ## [540]                  --- _b_ _b_ I must keep   awake  . I suppose I *shall* hear ---              
    ## [541]                --- I wish the servants '   heads   *wos* _b_ _b_ _b_ _b_ ---                  
    ## [542]                --- down. I *'ll* cut his   throat  -- give me a knife ---                     
    ## [543]                 --- knife -- from ear to    ear   , Mrs. Craddock -- I *will* ---             
    ## [544]               --- _b_ *will* you take my    arm    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [545]               --- _b_ _b_ There ! Now go     to    bed, Sam, and we *'ll* ---                 
    ## [546]                --- _b_ There ! Now go to    bed   , Sam, and we *'ll* talk ---                
    ## [547]             --- tear started out o' each    eye   , which *wos* wery extraordinary, for ---   
    ## [548]                 --- *'ll* tell me wen he   wakes  , I *'ll* be upon the ---                   
    ## [549]        --- fortunate enough to fall into   hands   that -- But I *wo* ---                     
    ## [550]             --- small light on that 'ere   liver   complaint as we *wos* a-speakin' ---       
    ## [551]            --- with these scenes, and my   heart   too. *Henceforth* I *will* be ---          
    ## [552]                    --- _b_ _b_ _b_ I can   sleep   anywhere. But *wo* n't it ---              
    ## [553]      --- in the coffee-room, and *shall*     go    to bed *soon*, it is ---                   
    ## [554]      --- the coffee-room, and *shall* go     to    bed *soon*, it is hardly ---               
    ## [555]       --- coffee-room, and *shall* go to    bed    *soon*, it is hardly worth ---             
    ## [556]           --- manner. " I *'ll* kick his   brains  out, if he has any ---                     
    ## [557]                --- about it; keep a good   heart  , my dear; and you *'ll* ---                
    ## [558]              --- life. It *will* warm my   heart   to witness the happiness of ---            
    ## [559]            --- _b_ _b_ Take that message    back  , and they *will* know that ---             
    ## [560]                --- _b_ _b_ I *shall* not     go    to bed till night; but ---                 
    ## [561]                 --- _b_ I *shall* not go     to    bed till night; but I ---                  
    ## [562]                  --- I *shall* not go to    bed    till night; but I want ---                 
    ## [563]          --- your father *soon* wore his   heart   out in prison, or wasted ---               
    ## [564]            --- and sliced before his own    face  , and then his inside *will* ---            
    ## [565]               --- looks on, and then his    head   *will* be chopped off, and ---             
    ## [566]             --- *shall* be put into some   hands   better qualified to free it ---            
    ## [567]                --- thank you with all my   heart  , and *will* open all my ---                
    ## [568]               --- and *will* open all my   heart   -- or nearly so. Have ---                  
    ## [569]        --- _b_ Willingly. " Give me your    hand  . She *will* be home directly, ---          
    ## [570]         --- the fountain, that his right    hand  , armed with the knife, *will* ---          
    ## [571]              --- be burnt off before his    face  ; that, into wounds which *will* ---        
    ## [572]                --- *will* be made in his    arms  , his breast, and his legs, ---             
    ## [573]                --- made in his arms, his   breast , and his legs, there *will* ---            
    ## [574]            --- arms, his breast, and his    legs  , there *will* be poured boiling ---        
    ## [575]               --- that he *will* be torn    limb   from limb by four strong ---               
    ## [576]             --- *will* be torn limb from    limb   by four strong horses. That ---            
    ## [577]      --- *will* always remember it, dear   Heart   ! I *will* remember it as ---              
    ## [578]                --- *shall* see me at the    head   of women, by-and-bye _b_ _b_ ---           
    ## [579]               --- my pipe, and I *shall*   sleep   like a child. *Will* you ---               
    ## [580]             --- like a child. *Will* you    wake   me _b_ _b_ _b_ _b_ ---                     
    ## [581]            --- sake ! She *will* put her   hands   together and pray you to ---               
    ## [582]                 --- he ! I *'ll* have my    head   took off, if he was ---                    
    ## [583]          --- until *to-morrow*. I ca n't   sleep   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [584]        --- *shall* fall, to examine that    cell  . It falls. I mount to ---                  
    ## [585]                    --- So I *'ll* nod my    head   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [586]            --- nothing while I hold your    hand  . I *shall* mind nothing when ---

``` r
# Z4 ["Discourse bin"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("Z4"), context = 0)
y
```

    ## [  1]             --- coming suddenly he find you    sleeping  . And what *I* *say* unto ---                     
    ## [  2]               --- *'m* *afraid* you must be     tired    , Miss Summerson, and perhaps you ---             
    ## [  3]          --- and perhaps you would *rather*       go      to bed _b_ _b_ _b_ ---                           
    ## [  4]           --- perhaps you would *rather* go       to      bed _b_ _b_ _b_ _b_ ---                          
    ## [  5]                --- you would *rather* go to      bed      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [  6]                --- -- *Hi* ! Here 's lovely      hair     ! I have got three sacks ---                     
    ## [  7]             --- 'em how you scratch. *Hi* !      Tear    , my lady _b_ _b_ _b_ ---                         
    ## [  8]                        --- is in a child 's     sleep     by this time, *I* *suppose*; ---                 
    ## [  9]                 --- good friend, I am never     tired    , and *I* *mean* to go ---                        
    ## [ 10]                 --- told you, you could n't      tire     me, *you* *know*. I am ---                       
    ## [ 11]                   --- had the child off her      lap     , *poor* *thing*, these seven days ---            
    ## [ 12]              --- of life. *Blest* with your      hand    , what means might I not ---                      
    ## [ 13]                --- _b_ _b_ *Ey* ! Bless the     hearts    o' ye _b_ _b_ _b_ ---                            
    ## [ 14]            --- *you* *know* -- trouble. Not     bodily    so much as nervous, nervous ! ---                
    ## [ 15]                    --- _b_ _b_ _b_ *Oh*, my      eye      ! Where can I move to ---                        
    ## [ 16]          --- servant, gentlemen; I 've been     dozing   . *Hi* ! I am hard to ---                         
    ## [ 17]                     --- *Hi* ! I am hard to      wake    , odd times _b_ _b_ _b_ ---                       
    ## [ 18]                 --- his eyelids; but do not      wake     him, for it is *right* ---                       
    ## [ 19]        --- *suppose* you never clapped your      eyes     on the country, Phil _b_ ---                     
    ## [ 20]                 --- _b_ _b_ *Oh* ! Blow the      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 21]            --- *Oh*, *dear* *me* ! *Oh*, my     bones     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 22]            --- *Oh*, *dear* *me* ! *Oh*, my     bones     and back ! *Oh*, my aches ---                    
    ## [ 23]               --- *me* ! *Oh*, my bones and      back     ! *Oh*, my aches and pains ! ---                 
    ## [ 24]                   --- *see* sold up in your      face    , George, as plain as print ---                   
    ## [ 25]                  --- or could, have had the     heart     to serve us so. *Oh*, ---                        
    ## [ 26]               --- _b_ *Yes*, *yes*, you are     tired     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 27]            --- Jarndyce and Jarndyce on the      head     with greater vigour. *Of* *course* ---           
    ## [ 28]            --- _b_ *dear* *me* -- something   bronchial  , *I* *think* -- hem ! -- ---                     
    ## [ 29]               --- *Er* -- this is certainly   bronchial   ! -- must be in the ---                          
    ## [ 30]                --- *I* *suppose* he 's over      head     and ears in debt. I ---                          
    ## [ 31]                  --- _b_ _b_ _b_ *No*. Real     flesh     and blood _b_ _b_ _b_ ---                        
    ## [ 32]                --- _b_ *No*. Real flesh and     blood     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 33]            --- strange in Miss Summerson 's      ears    , *I* *dare* *say*, that we ---                   
    ## [ 34]                     --- I am afraid you are     tired    . I am *sorry* to see ---                         
    ## [ 35]                  --- so bold, *I* *see* his     tears     a-fallin, Mr. Sangsby _b_ _b_ ---                
    ## [ 36]                   --- what you may call the      brow    , *you* *know*, THERE his father ---              
    ## [ 37]              --- *best* *wishes* of all our     hearts    with him wherever he goes ---                    
    ## [ 38]               --- *thank* *you* with all my     heart    . If I was not innocent ---                       
    ## [ 39]                    --- on; I noticed a deep     fringe    to it. *However*, it has ---                     
    ## [ 40]                    --- _b_ Why, you 're six      foot     two, *I* *suppose* _b_ _b_ ---                   
    ## [ 41]                     --- And not in the same      hand    , perhaps ? *Oh*, *no*, I do ---                  
    ## [ 42]                    --- do ? Do you see this      hand    , and *do* *you* *think* that ---                 
    ## [ 43]                    --- n't keep too quiet a     tongue    in your head. *In* *short*, ---                  
    ## [ 44]             --- examined the place, and the      body    , and the papers, *and* *everything*. ---         
    ## [ 45]                      --- _b_ _b_ _b_ You 'd      bite     her, *I* *suspect* _b_ _b_ ---                   
    ## [ 46]                     --- and you must have a     heart     to pity me. If *you* ---                         
    ## [ 47]                  --- keeping it in your own     breast   , *oh*, my dear Lady, think ---                   
    ## [ 48]                     --- easy to keep one 's     hands     off his 'ead. *However*, what ---                
    ## [ 49]                  --- crown in your t' other      hand    . One, two, three, and *there* ---                
    ## [ 50]      --- such quarters with an unfavourable      eye     . Our plain course, *however*, under ---          
    ## [ 51]                    --- glad to know from my      lips     before *I* *say* good night ---                  
    ## [ 52]                    --- _b_ _b_ _b_ *Oh*, my     bones     ! *Oh*, dear ! I 've no ---                      
    ## [ 53]                   --- *Oh*, dear ! I 've no     breath    in my body ! I 'm ---                            
    ## [ 54]              --- Varden. You may shake your      head    , father, but *I* *say* *no* ---                  
    ## [ 55]                --- *you* *know*, and on his      feet     all day. He was quite ---                        
    ## [ 56]                   --- him, though I have my      eye      on him sharp enough. *Oh* ! ---                  
    ## [ 57]                      --- the bed -- that 's     sleep    , *eh* _b_ _b_ _b_ _b_ ---                        
    ## [ 58]               --- sir, *eh* sir ? Hold your     tongue   , sir _b_ _b_ _b_ _b_ ---                         
    ## [ 59]                      --- is it ? Joe in the     flesh    , *eh* ? That 's hearty. And ---                  
    ## [ 60]                    --- _b_ _b_ _b_ _b_ Fall      back    , if you *please*, or go ---                      
    ## [ 61]                 --- the sake of your bright      eyes    . Strike again, mistress. Do. *Ha* ---            
    ## [ 62]             --- fine, pretty one, from your      lips    . I pay myself ! *Ha* *ha* ---                    
    ## [ 63]                   --- you will see. You are    thirsty   , *I* *suppose* _b_ _b_ _b_ ---                   
    ## [ 64]           --- nosed perhaps, and had clumsy      feet    . *Aye*, it was all for ---                       
    ## [ 65]                 --- soul has not caught her      foot     in some unlucky cobweb *by* ---                  
    ## [ 66]                --- of the *poor* *thing* 's     heart     then _b_ _b_ _b_ _b_ ---                         
    ## [ 67]                       --- _b_ _b_ that I am    sleeping   soundly in the stable. *Ha* ---                  
    ## [ 68]               --- are you, *eh* ? Hold your     tongue   , sir _b_ _b_ _b_ _b_ ---                         
    ## [ 69]               --- *your* *mind* she was all     heart     once. Now she has none ---                       
    ## [ 70]                 --- 'd shoot me through the      head    , *I* *suppose* _b_ _b_ _b_ ---                   
    ## [ 71]               --- _b_ In dreams ! *No*, nor     waking    either _b_ _b_ _b_ _b_ ---                       
    ## [ 72]               --- that *you* *see* round my      neck    , belonged to him that I ---                      
    ## [ 73]               --- a-giving way to floods of     tears    . *Oh* mim ! *oh* sir. Raly ---                   
    ## [ 74]                 --- come about ! -- *Oh* my      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 75]             --- *you* *see* great crowds of     faces    , now ? Do they grin and ---                      
    ## [ 76]              --- _b_ _b_ *I* *see* nothing.     Waking    or sleeping, nothing _b_ _b_ ---                 
    ## [ 77]            --- *I* *see* nothing. Waking or    sleeping  , nothing _b_ _b_ _b_ _b_ ---                     
    ## [ 78]                  --- on me. *Oh* ! let your     heart     be softened by your own ---                      
    ## [ 79]                  --- the tears stood in the      eyes     of the poor gentleman *as* ---                   
    ## [ 80]             --- the show, like Barnaby. All      eyes     are turned on him. *Ha* ---                      
    ## [ 81]              --- _b_ *Yes* *yes*, *oh* do !       Go      to bed directly _b_ _b_ ---                      
    ## [ 82]               --- *Yes* *yes*, *oh* do ! Go       to      bed directly _b_ _b_ _b_ ---                     
    ## [ 83]                  --- *yes*, *oh* do ! Go to      bed      directly _b_ _b_ _b_ _b_ ---                     
    ## [ 84]                       --- -- for see, he 's     waking    up. Rouse yourself, lion-heart. *Ha* ---         
    ## [ 85]                   --- for see, he 's waking       up     . Rouse yourself, lion-heart. *Ha* *ha* ! ---     
    ## [ 86]                   --- see, he 's waking up.     Rouse     yourself, lion-heart. *Ha* *ha* ! Put ---        
    ## [ 87]                  --- *Ha* *ha* ! Put a good      face     upon it, and drink again. ---                    
    ## [ 88]                    --- do n't mean with his     hands    , for that *you* *know*, but ---                  
    ## [ 89]              --- *you* *know*, but with his      head     -- as you or any ---                             
    ## [ 90]               --- has delivered you into my     hands    . *No*. Though you had the ---                    
    ## [ 91]                 --- *ay*, you may toss your      head     -- you would ! Kill the ---                      
    ## [ 92]             --- two such specimens afore my      eyes    . *Ha* *ha* ! *Oh* *yes*, I ---                   
    ## [ 93]                --- lip a trembling, but her      hand     as steady as ever *I* ---                        
    ## [ 94]        --- *considering* *that* I want this      limb     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 95]                    --- bless my soul -- and      body     -- *oh* Lor ! -- well ---                        
    ## [ 96]            --- loosens this man 's *bloody*     hands     again, and leads to his ---                      
    ## [ 97]               --- above his head a *bloody*      hand    . It was in the room ---                          
    ## [ 98]                --- blood. Does the sight of     blood     turn you sick, father ? *I* ---                  
    ## [ 99]                  --- *see* it does, by your      face    . That 's like me -- ---                          
    ## [100]              --- your eyes and shaking your      fist     at me, *eh* _b_ _b_ ---                          
    ## [101]           --- *rather* have lost this other      arm      -- *ay*, I would *rather* ---                    
    ## [102]             --- would *rather* have lost my      head     -- than have come back ---                       
    ## [103]              --- sing that out lustily, and      fall     asleep again. *Ha* *ha* *ha* ---                 
    ## [104]              --- that out lustily, and fall     asleep    again. *Ha* *ha* *ha* _b_ ---                    
    ## [105]                  --- sich cases with my own      eyes     -- *ho* *no* ! He he ---                         
    ## [106]                 --- have a husband with one      arm     , *anyways*. I would have two ---                 
    ## [107]             --- *anyways*. I would have two      arms    . I would have two arms, ---                      
    ## [108]                      --- _b_ _b_ I make him     wince    , and smart. *I* *say* to ---                     
    ## [109]              --- well, *I* *see*. Wash that      face    , sir, and come down with ---                     
    ## [110]                   --- _b_ _b_ _b_ *Oh* ! my      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [111]             --- 'em, she did. Mrs. Gummidge     biled     'em. *Yes* _b_ _b_ _b_ ---                       
    ## [112]               --- you *please*, with a good      head     to it _b_ _b_ _b_ ---                            
    ## [113]                     --- head to plan, and a      hand     to - *in* *short*, a general ---                 
    ## [114]                    --- _b_ _b_ _b_ *Oh*, my      eyes     and limbs, what do you ---                       
    ## [115]                   --- _b_ *Oh*, my eyes and     limbs    , what do you want ? *Oh*, ---                    
    ## [116]                  --- do you want ? *Oh*, my     lungs     and liver, what do you ---                       
    ## [117]               --- want ? *Oh*, my lungs and     liver    , what do you want ? *Oh*, ---                    
    ## [118]                  --- do you want ? *Oh*, my      eyes     and limbs, what do you ---                       
    ## [119]                --- want ? *Oh*, my eyes and     limbs    , what do you want ? *Oh*, ---                    
    ## [120]                  --- do you want ? *Oh*, my     lungs     and liver, what do you ---                       
    ## [121]               --- want ? *Oh*, my lungs and     liver    , what do you want ? *Oh*, ---                    
    ## [122]                    --- _b_ _b_ _b_ *Oh*, my     heart     on fire, show the jacket ---                     
    ## [123]                 --- jacket to us ! *Oh*, my      eyes     and limbs, bring the jacket ---                  
    ## [124]                  --- us ! *Oh*, my eyes and     limbs    , bring the jacket out _b_ ---                    
    ## [125]                    --- _b_ _b_ _b_ *Oh*, my     lungs     and liver _b_ _b_ _b_ ---                        
    ## [126]                  --- _b_ *Oh*, my lungs and     liver     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [127]                 --- _b_ _b_ *no* ! *Oh*, my      eyes    , *no* ! *Oh*, my limbs, *no* ! ---               
    ## [128]                --- my eyes, *no* ! *Oh*, my     limbs    , *no* ! Eighteenpence. Goroo _b_ _b_ ---         
    ## [129]                    --- _b_ _b_ _b_ *Oh*, my     liver     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [130]                  --- of the shop ! *Oh*, my     lungs    , get out of the shop ! ---                       
    ## [131]                  --- of the shop ! *Oh*, my      eyes     and limbs - goroo ! - do n't ---                 
    ## [132]                --- shop ! *Oh*, my eyes and     limbs     - goroo ! - do n't ask for ---                   
    ## [133]                    --- _b_ _b_ _b_ *Oh*, my      eyes     and limbs _b_ _b_ _b_ ---                        
    ## [134]                   --- _b_ *Oh*, my eyes and     limbs     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [135]                    --- _b_ _b_ _b_ *Oh*, my     lungs     and liver, will you go ---                       
    ## [136]                  --- _b_ *Oh*, my lungs and     liver    , will you go for threepence ---                  
    ## [137]               --- *Yes*. Do with - I should      put      him to bed _b_ _b_ ---                           
    ## [138]           --- stared him point-blank in the      face     ! *Of* *course* it was left ---                  
    ## [139]             --- *Aye*, *aye* ! you need n't     wince     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [140]       --- Copperfield, can *I* *believe* my      ears     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [141]                      --- of life was on all     hands     understood to be - *eh* _b_ ---                  
    ## [142]                --- _b_ _b_ *I* *believe* my     breath    will get long next, my ---                       
    ## [143]                   --- a laughing and half a     crying   , " *Yes*, Uncle ! If you *please*. " - ---       
    ## [144]                   --- _b_ To doctor his own  moustachios  with, *you* *know*. There was ---                
    ## [145]    --- Griffin. " What the unmentionable to      ears     polite, *do* *you* *think* I ---                 
    ## [146]                 --- *sake*, have a woman 's     heart     towards me. I was once ---                       
    ## [147]                 --- *sake*, have a woman 's     heart     towards me. I was once ---                       
    ## [148]                       --- and let me lay my      head     upon you. *Oh*, I am ---                         
    ## [149]                   --- me, *oh* me ! *Oh* my     heart    , my heart _b_ _b_ _b_ ---                        
    ## [150]                  --- me ! *Oh* my heart, my     heart     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [151]     --- *suppose* this unfortunate fowl was      born     and brought up in a ---                          
    ## [152]                    --- _b_ we ca n't forego     Blood    , *you* *know*. We must have ---                  
    ## [153]              --- *you* *know*. We must have     Blood    , *you* *know*. Some young fellows, ---           
    ## [154]               --- pony-shay) has been in my     breast    for years. *Oh*, Master Copperfield, ---         
    ## [155]                    --- _b_ _b_ Tight in the      arms     and legs, *you* *know* ? *Dear* ---              
    ## [156]                   --- Tight in the arms and      legs    , *you* *know* ? *Dear* *me* ! Well ! ---         
    ## [157]                 --- ever was, in anybody 's      eyes     (*I* *should* *think*). But when ---             
    ## [158]         --- clouds about himself, with both     hands    : 'Splendid, *you* *know* _b_ _b_ ---             
    ## [159]                 --- do n't care for strange     faces     in general, but I *rather* ---                   
    ## [160]                 --- 're a man, control your     limbs    , sir ! *Good* *God* _b_ _b_ ---                  
    ## [161]                  --- love so dear. *Oh*, my     heart     is breaking when *I* *think* ---                 
    ## [162]                  --- I must say before your      face    , *as* *I* always *say* behind ---                
    ## [163]          --- trouble out of you-know-who 's      head    , and put it *you* *know* ---                     
    ## [164]                   --- *Oh*, hold me to your     heart    , my husband ! Never cast me ---                  
    ## [165]                   --- *Oh*, take me to your     heart    , my husband, for my love ---                     
    ## [166]                     --- at me with his last     breath   , *I* *believe* _b_ _b_ _b_ ---                   
    ## [167]                   --- *yes*, for I know his     heart     ! _b_ _b_ _b_ _b_ _b_ ---                        
    ## [168]             --- wrote in with his *blessed*      hand     - I felt a wownd go ---                          
    ## [169]                 --- and the roarings in her      ears    ; and theer was *no* today, ---                   
    ## [170]                     --- _b_ _b_ _b_ only my     limbs     are *rather* out of sorts, ---                   
    ## [171]                --- With the exception of my     limbs     and my breath, *howsoever*, I ---                
    ## [172]                      --- of my limbs and my     breath   , *howsoever*, I am as hearty ---                 
    ## [173]           --- something the matter with her     spine    , *you* *know*. Immensely better ! And ---        
    ## [174]                  --- chest, and then to the      head    , and, *in* *short*, pervaded the ---             
    ## [175]                 --- _b_ *Tut*, Trot; MY old     bones     would have kept till tomorrow ---                
    ## [176]            --- *suppose* you never draw any   skeletons   now _b_ _b_ _b_ _b_ ---                          
    ## [177]                        --- me a blow in the      face    , *you* *know* _b_ _b_ _b_ ---                    
    ## [178]                 --- *you* *see* in all your      born     days; when the little woman, ---                 
    ## [179]                      --- _b_ _b_ He cut her      face     *right* open, and pounded her ---                
    ## [180]            --- am so *blest*, Trotwood - my     heart     is so overcharged - but there ---                
    ## [181]                 --- little boy -- the baby,     Fanny    , *you* *know*; you have hardly ---               
    ## [182]                    --- think it 's time you     roused    yourself a little ? *Eh* _b_ ---                 
    ## [183]           --- world of effort *you* *know*,     Fanny    , and we must never yield, ---                    
    ## [184]          --- *course*, having set his whole     heart     on this one boy -- ---                           
    ## [185]                  --- only touch him with my      hand    , and go to sleep. *Oh*, ---                      
    ## [186]                   --- him with my hand, and       go      to sleep. *Oh*, pray, pray, ---                  
    ## [187]                    --- with my hand, and go       to      sleep. *Oh*, pray, pray, let ---                 
    ## [188]                      --- my hand, and go to     sleep    . *Oh*, pray, pray, let me ---                    
    ## [189]             --- cold preparation of calf 's      head    , *I* *think*. *I* *see* cold ---                 
    ## [190]               --- _b_ _b_ _b_ _b_ *blessed*      legs     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [191]               --- *oh*, dear, how well poor     Fanny     meant _b_ _b_ _b_ _b_ ---                        
    ## [192]           --- old gentleman with a powdered      head     (inaudibly to him *of* *course*), ---            
    ## [193]           --- *I* *think*, except the three     heads     of the House, there is ---                       
    ## [194]                 --- impulse, and to wear my     heart     *as* *it* *were*, outside. I ---                 
    ## [195]                     --- hand on Mr Toots 's      knee    , 'old Sol, *mind* *you* -- ---                   
    ## [196]                  --- *you* -- with your own      eyes     -- as you sit there ---                          
    ## [197]                   --- Do n't give the money      back    , my darling; *please* do n't. ---                
    ## [198]         --- Heaven ! I would the *bleeding*      foot     that brought me here to-day, ---                 
    ## [199]                    --- in the anguish of my     heart    , *oh*, father, turn to me ---                    
    ## [200]              --- me, *I* *suppose*, when he     wakes     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [201]         --- indecent old frights with their     backs     and shoulders, and *in* *short* ---              
    ## [202]            --- frights with their backs and   shoulders  , and *in* *short* this at ---                    
    ## [203]              --- removes a mountain from my     breast   . May I hope *you* *know* ---                     
    ## [204]                    --- to think there 's no     Heart     -- *or* *anything* of that ---                   
    ## [205]                  --- the sight of his frank      face     any more. " *No*, *no*; no ---                   
    ## [206]               --- *have* *you* done to your      hand     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [207]         --- to the old, familiar, beckoning     finger   , -- *oh* mother, *oh* mother ! ---               
    ## [208]          --- or misfortune happening to the      head     of the House, *or* *anything* ---                
    ## [209]               --- breakfast with you. As to     sleep    , *you* *know*, I never sleep ---                 
    ## [210]            --- sleep, *you* *know*, I never     sleep     now. I might be a ---                            
    ## [211]                --- speaking of her with his      face     a glistening with *doo* -- ---                   
    ## [212]             --- *Oh*, *yes*, with her whole     heart     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [213]                  --- parlour of the King 's      Arms     all the *blessed* day. I ---                     
    ## [214]               --- such things are. By whose      hand     *do* *you* *think* _b_ _b_ ---                   
    ## [215]                  --- I have fingers on this      hand    . Who was it, *do* *you* ---                      
    ## [216]             --- it, *do* *you* *think*, who    snapped    his fingers at me in ---                         
    ## [217]          --- *you* *think*, who snapped his    fingers    at me in my misery, ---                          
    ## [218]               --- of everybody 's sight and    hearing   . *Do* *you* *think* to frighten ---              
    ## [219]             --- agreeable warmth, all up my      back    . *I* *say* *Amen*. You are ---                   
    ## [220]               --- ever, will strike upon my      ears     like a knell *you* *know*, ---                   
    ## [221]                            --- or a -- or a      leg     , *in* *short*, to -- to ---                      
    ## [222]                    --- _b_ _b_ Such a noble     heart     as yours, must feel, *I* ---                     
    ## [223]         --- feel, *I* *think*, when another     heart     is bound to it. I ---                            
    ## [224]                  --- *Oh* *no* ! I was very     tired     the first time that we ---                       
    ## [225]                   --- and is *sorry* in her     heart    . You will not forget her ---                     
    ## [226]                --- *see* it plainly in your      face     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [227]             --- fills, deary. *Ah*, my poor     nerves    ! I got Heavens-hard drunk for ---               
    ## [228]                   --- better to have had my      head     cut off, *I* *think* _b_ ---                     
    ## [229]                  --- Eddy, you were just as     tired     of me, *you* *know* _b_ ---                      
    ## [230]                       --- I do n't like red     noses    . *However*; to be sure she ---                   
    ## [231]                 --- Ned. *As* *it* *is* his      foot     that is in the stirrup ---                       
    ## [232]                   --- to it once more. Your      arm     , if you *please*. Softly, for ---                
    ## [233]                    --- get a morsel down my     throat   , I *thank* *you* _b_ _b_ ---                     
    ## [234]             --- *in* *this* *case* the long      arm      will reach, and the strong ---                   
    ## [235]           --- which expression *I* *mean* a      head     chambermaid not limited as to ---                
    ## [236]   --- *please*, put suppositions betwixt my      lips     where none such have been ---                    
    ## [237]              --- afterwards. I 'll beat the    shivers    so far, *I* *'ll* *bet* ---                      
    ## [238]                --- been aware how small and     flabby    and mean you was, *dear* ---                     
    ## [239]                   --- jerkings I have in my      legs    . Chokings and nervous jerkings, *however*, ---   
    ## [240]             --- advantages. You get at your     mouth     better (which *after* *all* is ---               
    ## [241]                     --- _b_ *Oh* ! I have a     heart     to be stabbed in or ---                          
    ## [242]                   --- *yes*, may I kiss the     cheek     again _b_ _b_ _b_ _b_ ---                        
    ## [243]            --- asked before you touched the      hand    . But, *yes*, *if* *you* *like* ---               
    ## [244]          --- *sake*, give me your blackened      hand     ! - I shall be down soon, ---                    
    ## [245]                     --- over with you on my    fingers   , if you *please*, the names ---                  
    ## [246]                  --- _b_ _b_ *Yes*, hard of    hearing   ; having that infirmity coming upon ---           
    ## [247]             --- took her into this wretched     breast    when it was first *bleeding* ---                 
    ## [248]                     --- men 's and women 's     faces     wos like, *I* *see* yourn. ---                   
    ## [249]           --- have growed ! There 's bright      eyes     somewheres - *eh* ? Is n't there ---             
    ## [250]              --- *eh* ? Is n't there bright      eyes     somewheres, wot you love the ---                 
    ## [251]                   --- _b_ _b_ *Yes*. And to     sleep     long and sound _b_ _b_ ---                       
    ## [252]        --- colonists have their horses (and     blood     'uns, if you *please*, *good* ---                
    ## [253]            --- *I* *believe* had some gipsy     blood     in her. *Anyhow*, it was ---                     
    ## [254]                    --- it 's run through my    fingers    and gone, *you* *see* _b_ ---                    
    ## [255]                 --- rippling at the boat 's      head     making a *sort* *of* a ---                       
    ## [256]           --- born with inflammation of the     lungs    , and of everything else, *I* ---                 
    ## [257]             --- *believe*, is agreed on all     hands     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [258]     --- take Merrylegs ? " Father shook his      head     and said, " *No*, Sissy, *no*; ---               
    ## [259]               --- *see* in Mr. Gradgrind 's      hand     takes my breath away and ---                     
    ## [260]                 --- _b_ _b_ _b_ *Yes* ! And      back     agen. Back agen ever and ---                     
    ## [261]              --- _b_ *Yes* ! And back agen.      Back     agen ever and ever so ---                        
    ## [262]                 --- ever and ever so often.      Back     ? *Yes*, back. Why not _b_ ---                   
    ## [263]            --- ever so often. Back ? *Yes*,      back    . Why not _b_ _b_ _b_ ---                         
    ## [264]            --- *Please* to turn your humble      eye      in My direction _b_ _b_ ---                      
    ## [265]                    --- for that I know your     heart    , and am *right* sure and ---                     
    ## [266]           --- *rather* receive it from your      hand    , than from any other. Therefore, ---             
    ## [267]                     --- see it wi' a better      eye     . Bless thee. Good night. *Good-bye* ---          
    ## [268]             --- room that this young fellow     sleeps    outside of, there was *never* ---                
    ## [269]          --- *what*. Show me a dissatisfied      Hand    , and I 'll show you ---                          
    ## [270]             --- *I* *believe*, to have been   insensible  to all other women, and ---                      
    ## [271]                --- are the sentiments of my     heart     ? *What* *have* *you* done, O ---                
    ## [272]            --- 's always got his *blinking*      eyes     upon a fellow _b_ _b_ ---                        
    ## [273]                  --- pond. I was obliged to     sleep     in town *after* *all* _b_ ---                    
    ## [274]                     --- is far from being a      born     lady. That *you* *know*, yourself. ---           
    ## [275]                  --- could say with my last     breath   , *God* *knows* my heart. I ---                   
    ## [276]           --- last breath, *God* *knows* my     heart    . I have never once left ---                      
    ## [277]         --- *have* *you* been dreaming of ?      Wake     up, wake up ! What 's ---                        
    ## [278]           --- *you* been dreaming of ? Wake       up     , wake up ! What 's the ---                       
    ## [279]                  --- If you *please*, I was      born     here, sir _b_ _b_ _b_ ---                        
    ## [280]               --- here, always. She was not      born     here as I was, *you* ---                         
    ## [281]           --- 's natural *I* *suppose* that     Fanny     should prefer to be outside, ---                 
    ## [282]           --- *What* *have* *you* done with     Fanny    , Frederick _b_ _b_ _b_ _b_ ---                   
    ## [283]              --- by its being in *Bleeding*     Heart     Yard _b_ _b_ _b_ _b_ ---                         
    ## [284]              --- _b_ _b_ _b_ _b_ *Bleeding*     Heart     Yard _b_ _b_ _b_ _b_ ---                         
    ## [285]  --- loose at Marseilles, some fly-catchers   swallowed   it. But I ? *No*, not ---                        
    ## [286]              --- _b_ _b_ _b_ _b_ *Bleeding*     Heart    , *Bleeding* Heart, bleeding away _b_ ---         
    ## [287]    --- _b_ _b_ *Bleeding* Heart, *Bleeding*     Heart    , bleeding away _b_ _b_ _b_ ---                   
    ## [288] --- _b_ *Bleeding* Heart, *Bleeding* Heart,    bleeding   away _b_ _b_ _b_ _b_ ---                         
    ## [289]               --- _b_ *Oh* ! why, with that      head    , is he not a benefactor ---                      
    ## [290]         --- species ! *Oh* ! why, with that      head    , is he not a father ---                          
    ## [291]              --- _b_ _b_ _b_ _b_ *Bleeding*     Heart     Yard _b_ _b_ _b_ _b_ ---                         
    ## [292]                  --- *yes*, *yes*. It 's my      leg     , it 's my leg. But ---                           
    ## [293]                   --- that, we 've got your     birth     in our Register, *you* *know*; ---               
    ## [294]           --- *Yes*, Chivery, my brother is     going     home to bed. He is ---                           
    ## [295]                       --- _b_ _b_ I was not      born     where you were, *you* *know*, ---                
    ## [296]                   --- I am so very *sorry*,     Fanny    , that you suffered this lady ---                 
    ## [297]                   --- _b_ _b_ _b_ _b_ *No*,     Fanny    , I am sure _b_ _b_ ---                           
    ## [298]              --- *see* that John with these      eyes     return. Never been himself in ---                
    ## [299]              --- _b_ _b_ _b_ _b_ *Bleeding*     Heart     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [300]           --- A whole morning in *Bleeding*     Heart     Yard, before I could induce ---                  
    ## [301]                --- *truth*, Mr Pancks, I am     tired     of them _b_ _b_ _b_ ---                          
    ## [302]               --- I must have of *Bleeding*     Heart     Yard _b_ _b_ _b_ _b_ ---                         
    ## [303]                    --- and there I still am    snoring    *I* *dare* *say* if the ---                      
    ## [304]             --- along o' hearing about your      head    , Little Mother. *Oh* my ! Ai ---                 
    ## [305]                   --- And she cast down her      eyes    , and whispered, *Yes*. Then the ---              
    ## [306]                --- oftener he looks at, the      face     of his daughter. *In* *short*, ---               
    ## [307]                --- out and set apart. (Your     birth    , *you* *know*; you must not ---                  
    ## [308]               --- madam, *no*; I am neither      born     nor bred in England. In ---                      
    ## [309]             --- *thank* *you*. Give me your      arm      again, Mr Nandy. We shall ---                    
    ## [310]            --- for having wounded your dear     heart     -- *no* ! *Heaven* *knows* I ---                 
    ## [311]                --- to be down in *Bleeding*     Heart     Yard by rights; but I ---                        
    ## [312]              --- leave. Dear Amy, open your      eyes    , that 's a love ! *Oh*, ---                      
    ## [313]               --- so vexed and ashamed ! Do     rouse     yourself, darling ! *Oh*, why are ---            
    ## [314]                   --- that my son, being by     birth     and by -- *ha* -- ---                            
    ## [315]           --- *holding* *on* here round the     necks     of the most sagacious of ---                     
    ## [316]                      --- I have been at the      head     of -- *ha* of a ---                              
    ## [317]                 --- *say*, sweep it off the      face     of the earth and begin ---                       
    ## [318]                   --- _b_ _b_ _b_ _b_ *No*,     Fanny     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [319]              --- *Do* *you* *think* -- dear     Fanny    , do n't be offended, we ---                      
    ## [320]                  --- *it* *is* not with me,     Fanny    , I do n't mind _b_ ---                           
    ## [321]                    --- _b_ _b_ _b_ _b_ Dear     Fanny    , *do* *you* *think* it possible ---              
    ## [322]                 --- copy they had done with     mouths    from ear to ear *good* ---                       
    ## [323]               --- had done with mouths from      ear      to ear *good* *gracious*, and ---                
    ## [324]                 --- with mouths from ear to      ear      *good* *gracious*, and has she ---               
    ## [325]                   --- this -- unless he was     bodily    too strong for them. *Bah* ! ---                 
    ## [326]                  --- run in little Altro 's      head     ? *Eh* _b_ _b_ _b_ _b_ ---                       
    ## [327]                --- _b_ _b_ That my daughter     Fanny     is -- *ha* -- contracted ---                     
    ## [328]             --- _b_ _b_ *do* *you* *think*,     Fanny    , that if you were to ---                         
    ## [329]               --- _b_ _b_ _b_ *Yes*, *yes*,     Fanny    . You said so, I know ---                         
    ## [330]               --- _b_ your dear sister, our     Fanny    , has contracted *ha* *hum* -- ---                
    ## [331]                  --- *ha* -- my estate, and    hearing    of this strange disappearance, I ---             
    ## [332]                --- that. *Ha*. Give me your      hand    , Young John, give me your ---                    
    ## [333]         --- *your* *pardon*. It gladdens my      eyes     to see you again; that ---                       
    ## [334]                      --- _b_ *Ha*, I am not     tired    . *Ha*, *hum*. I am very ---                      
    ## [335]                        --- _b_ I beg you to       go      to bed. I -- *ha* ---                            
    ## [336]                         --- I beg you to go       to      bed. I -- *ha* -- ---                            
    ## [337]                        --- beg you to go to      bed     . I -- *ha* -- make ---                           
    ## [338]        --- ruin. Mouldering away before our      eyes    . *Hum*. Good Frederick _b_ _b_ ---               
    ## [339]             --- Ambition -- hum -- purpose, consciousness of -- *ha* -- position, ---                      
    ## [340]                     --- _b_ _b_ _b_ _b_ _b_     Fanny     has -- *ha* -- manifested ---                    
    ## [341]                  --- -- *ha* -- jealousy in     Fanny    , which has occasionally risen against ---        
    ## [342]               --- the -- *ha* -- Collegiate      body    . In return for which -- ---                      
    ## [343]                    --- *I* *see* it in your      face     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [344]                 --- of a soldier with white      hair     -- *hey* ? -- not hair ---                       
    ## [345]                  --- hair -- *hey* ? -- not      hair     like this that he carries ---                    
    ## [346]              --- _b_ _b_ to his ill-looking      face    , that *in* *my* *opinion* the ---                
    ## [347]                 --- certain till I saw your     teeth    . *Ah* ! *yes*, to be sure. ---                   
    ## [348]           --- -- *Aye*, *aye*, *aye* ? this     pulse     is beating curiously ! It appears ---            
    ## [349]           --- *you* *what* I consider those      eyes     of hers, that were here ---                      
    ## [350]                   --- I am very *sorry* for     Fanny    ; very, very, very *sorry* for ---                
    ## [351]             --- very, very *sorry* for poor     Fanny    . My poor brother too _b_ ---                     
    ## [352]             --- present and so deficient in     kidney    as to be *in* *that* ---                         
    ## [353]                  --- the fire with your own      hand    , just *as* *it* *is*, my ---                     
    ## [354]                   --- to you with our whole     hearts   . It is a *blessed* distinction ---               
    ## [355]                      --- _b_ _b_ _b_ _b_ My      feet     are quite numbed. *Ah* ! Bitter ---              
    ## [356]                --- I would *rather* keep my     hands     warm by holding them comfortably ---             
    ## [357]            --- that never rejoices; and our     hearts    are not poor. *No* _b_ ---                       
    ## [358]                       --- _b_ _b_ _b_ _b_ A    one-eyed   calender, *I* *think*, sir _b_ ---               
    ## [359]             --- *think*, than being read to     sleep    . You wo n't mind my ---                          
    ## [360]               --- *thank* *you* with my own      lips    , you, who make so light ---                      
    ## [361]           --- There 's fowls to-morrow. Not     skinny    ones. *Oh* *no* _b_ _b_ ---                      
    ## [362]          --- emotion, or remember without a      tear    . *Oh*, Mrs Todgers _b_ _b_ ---                   
    ## [363]                  --- _b_ Come down into the      back     parlour, if you *please*, my ---                 
    ## [364]         --- deeds, such meannesses and vile   endurances , as nothing could repay; *no*, ---               
    ## [365]             --- *your* *pardon* with all my     heart     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [366]                 --- *you* *think* that if I      spat     upon him, I could degrade ---                    
    ## [367]              --- I expect *you* *know*, the     organ     of our aristocracy in this ---                   
    ## [368]                    --- a strange name in my      ears    , believe me. *In* *some* *cases* ---             
    ## [369]                   --- But *I* *see* you are     tired     to death, and will wish ---                      
    ## [370]          --- getting *too* *bad*. Hold your     tongue   , will you _b_ _b_ _b_ ---                        
    ## [371]                  --- _b_ _b_ _b_ *Ah* ! and    snoring   . Only hear _b_ _b_ _b_ ---                       
    ## [372]               --- *see* 'em; and toss their     heads    , they do, as if they ---                         
    ## [373]                  --- window, and put out my      head    . Cloak, *eh* ? Do n't tie ---                    
    ## [374]                      --- _b_ And put out my      head     -- hat, *eh* ? My good ---                       
    ## [375]                   --- they walk up into the   organ-loft , or take a seat ? *No*, ---                      
    ## [376]                    --- ever happen to go to      bed      there -- you MAY, *you* ---                      
    ## [377]              --- partner -- fast asleep and    snoring    -- Co. must; *I* *see* ---                       
    ## [378]                  --- things up. Keep a good     heart    , sir. *Hallo* there _b_ _b_ ---                  
    ## [379]       --- Chuzzlewit ! Can *I* *believe* my      eyes     ! My dear sir; my good ---                       
    ## [380]            --- little shoes *right* off its      feet    , as with our precious boy ---                    
    ## [381]            --- What *do* *you* *think* your      eyes     was made for -- *eh* ? ---                       
    ## [382]        --- monster, I trust. *Ah* ! naughty      Hand     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [383]                  --- enough to break one 's     heart     ! *I* *mean* to go to ---                        
    ## [384]                --- means; and *I* *see* the     tears     a-standing in his eyes during ---                
    ## [385]                --- if there really is, *oh*    gasping    one ! a Pogram or a ---                          
    ## [386]                  --- to stop here. *Oh*, my      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [387]                 --- _b_ Where you have your      hand     now, *hey* _b_ _b_ _b_ ---                       
    ## [388]                     --- And wo n't save the      head     " ! *No*, *no*. *No* ! *Ha*, *ha*, ---           
    ## [389]                   --- seem so. There are no     bones     broken, *after* *all* _b_ _b_ ---                
    ## [390]                --- *think* not. Then do not     thirst    for silver, gold, or precious ---                
    ## [391]             --- angel 's ! " Which, but for    Pimples   , it would be. " *No*, Sairey ---                 
    ## [392]                      --- *see* it, if I was     asleep    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [393]                     --- _b_ _b_ _b_ _b_ _b_     Asleep    ! *Aye*, *aye* _b_ _b_ _b_ ---                   
    ## [394]              --- a favourable *sort* *of* a      eye      in fact _b_ _b_ _b_ ---                          
    ## [395]                    --- has the paper in his     breast   , *I* *believe*, at this moment ---               
    ## [396]                 --- me, into pouring out my     heart     ! *Oh*, Tom _b_ _b_ _b_ ---                      
    ## [397]                     --- to be *sorry* in my     heart    , until now _b_ _b_ _b_ ---                       
    ## [398]                      --- hurt a hair of her      head    , you shall answer it. *Poor* ---                 
    ## [399]               --- courage failed him or his     heart     was touched -- *my* *God* ! ---                  
    ## [400]                   --- not so easy when your     wrists    are tight together. *Now* *then* ! ---           
    ## [401]                   --- *sorry*, but I ca n't     unsay     it. It 's hardly fair ---                        
    ## [402]             --- to do. Permittin' the sweet     faces     as *I* *see* afore me ---                        
    ## [403]                     --- and a zone for your     waist     ! *Ah* ! Beautiful ! Let us see ---              
    ## [404]          --- people, *I* *believe*, have no     hearts    to break _b_ _b_ _b_ ---                         
    ## [405]                 --- _b_ _b_ *Please* sir, I    sneezed    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [406]                  --- _b_ _b_ _b_ _b_ *Oh* !    sneezed   , did you _b_ _b_ _b_ ---                         
    ## [407]                  --- safer in case of their     going     to sleep; *eh* _b_ _b_ ---                       
    ## [408]                  --- in case of their going       to      sleep; *eh* _b_ _b_ _b_ ---                      
    ## [409]               --- *You* *know* how light of     heart     sweet Alice is, " replied the ---                
    ## [410]               --- _b_ *Please*, sir, I fell     asleep    over the fire _b_ _b_ ---                        
    ## [411]                   --- n't much mind how you     sleep    , *I* *suppose*, sir _b_ _b_ ---                  
    ## [412]                     --- _b_ _b_ _b_ *Oh* my      eye     , wo n't I give it ---                            
    ## [413]               --- *I* *see* them with right      eyes    , and that 's quite enough ---                    
    ## [414]                      --- _b_ It goes to his     heart    , *I* *believe*, to be forced ---                 
    ## [415]           --- was watching the child, being     tired     *I* *suppose*, fell asleep, and ---              
    ## [416]         --- being tired *I* *suppose*, fell     asleep   , and set her hair on ---                         
    ## [417]                      --- it, even if I kept     awake    , which *I* *think* very doubtful. ---            
    ## [418]                   --- hem -- *I* *think* my      foot     may be a little smaller. ---                     
    ## [419]                --- since our family had any      feet     at all, indeed, *I* *think*. ---                 
    ## [420]            --- *Ha* ! *ha* ! *ha* ! Of club      feet     ! *Oh* very good ! As I ---                      
    ## [421]                       --- to rise to one 's      lips    . *Oh*, very good ! *Ha*, *ha*, ---               
    ## [422]    --- excitement. *Bless* *my* *heart* and      body    , can I ever forget the ---                       
    ## [423]              --- fired pistols, and went to      bed      in a nightcap; and, *in* ---                     
    ## [424]                    --- -- into such fits of     crying    ! *Goodness* *gracious* me, Miss Lane, ---       
    ## [425]                --- a little humbling, a few     tears    . *Yes* _b_ _b_ _b_ _b_ ---                       
    ## [426]                   --- look -- at that sweet      face    . *Ah* ! here it is. Unmoved, ---                 
    ## [427]          --- *know*, that Mrs Wititterly 's    profile    reminds you of _b_ _b_ ---                       
    ## [428]                     --- some of that boy 's     blood     in you, *I* *see* _b_ ---                        
    ## [429]           --- esteem, and degraded in every      eye      that looks upon me. *No*, ---                    
    ## [430]               --- stand who had exactly the      face     of Digby; though, *as* *he* ---                  
    ## [431]                 --- lays the other upon his     heart     -- *of* *course* it 's ---                       
    ## [432]                 --- which it would wring my     heart     to see in yours. *No*; ---                       
    ## [433]              --- besides. You may wring his      neck     if you *please*. I shall ---                     
    ## [434]               --- was very *sorry* when she      woke    , for she has been SO ---                         
    ## [435]                   --- _b_ _b_ _b_ _b_ *No*,     Fanny     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [436]             --- skimming along *oop* to his     knees     in mud and wather, tumbling ---                  
    ## [437]                --- honest mun *hoo* thou 'd     licked    that poor chap in t' ---                         
    ## [438]                     --- has a wart upon his      nose    , Kate, *you* *know*, exactly like ---            
    ## [439]                  --- _b_ *Yes*, here he is,     flesh     and blood, flesh and blood ---                   
    ## [440]      --- bewitching, and not nineteen. Dark      eyes    , long eyelashes, ripe and *ruddy* ---            
    ## [441]           --- not nineteen. Dark eyes, long   eyelashes  , ripe and *ruddy* lips that ---                  
    ## [442]        --- long eyelashes, ripe and *ruddy*      lips     that to look at is ---                           
    ## [443]               --- because you have the ripe      lips    , and the clustering hair, *and* ---              
    ## [444]           --- ripe lips, and the clustering      hair    , *and* *what* *not*, all to ---                  
    ## [445]              --- *you* *know*. You are very     tired    , my dear _b_ _b_ _b_ ---                         
    ## [446]          --- *Oh* *dear* ! How handsome her      eyes     looked when she was stooping ---                 
    ## [447]                     --- of books, and you a    thirsty    dramatist, I would *rather* pay ---              
    ## [448]                     --- _b_ let me see your      face    . *No* ? *Ah* ! that was but ---                  
    ## [449]                  --- to be fooled by pretty     faces    , Peg; *no*, *no*, no -- ---                      
    ## [450]                     --- I could not draw my     breath   . I 'll *tell* *you* *what* ---                   
    ## [451]         --- choking hisself with his little      fist     -- when *I* *see* him ---                        
    ## [452]                   --- own peace of mind and     heart    , I do *for* *God* *'s* ---                       
    ## [453]                  --- are about to give your      hand    , some of his deeds *you* ---                     
    ## [454]       --- feeble acknowledgment, move me to     tears    , as *you* *see*. But I ---                       
    ## [455]                --- lie is trembling on your      lips    , *I* *see* _b_ _b_ _b_ ---                       
    ## [456]              --- of fierce defiances in his     teeth     -- gums I should *rather* ---                    
    ## [457]               --- little child had laid her      head    . *You* *see* his wish was ---                    
    ## [458]                 --- as *you* *see*. Our way      lies     in very different directions. Take ---           
    ## [459]               --- *you* *see*. Our way lies       in      very different directions. Take yours, ---       
    ## [460]                    --- *I* *see* it in your     faces    . Who triumphs now ? Is this ---                  
    ## [461]               --- *all*. He offered you his      hand     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [462]            --- his whiskers shaved, and his      eyes     turned *right* and left, and ---                 
    ## [463]                  --- then, look out. Hip --      hip     , -- hip -- *hurrah* _b_ ---                      
    ## [464]                     --- out. Hip -- hip, --      hip      -- *hurrah* _b_ _b_ _b_ ---                      
    ## [465]                      --- to give him a word      back    , *no*, not a single word ---                     
    ## [466]                    --- *see* it with my own      eyes     and hear it with my ---                          
    ## [467]              --- well, *I* *think*, for the     tears     come into my eyes and ---                        
    ## [468]                      --- _b_ _b_ _b_ She 's     tired     *you* *see*, Mrs Quilp _b_ ---                   
    ## [469]                   --- sun and wind upon our     faces     in the day, and *thank* ---                      
    ## [470]                --- They would n't wring his      neck     and me by, *no*, *no*. ---                       
    ## [471]                 --- an atom from anybody 's      hand     but mine if you *please*. ---                    
    ## [472]                    --- Do *I* *mean* in the      face     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [473]                --- _b_ *I* *suppose* he may     sleep     his ten pound out, in ---                        
    ## [474]                --- a habit of combing their      hair    , which she has n't. *No*, ---                    
    ## [475]                  --- keep his eyes open. He     falls     asleep sometimes, *you* *know*. Remember ---     
    ## [476]                 --- his eyes open. He falls     asleep    sometimes, *you* *know*. Remember them ---       
    ## [477]                 --- not keep on pulling his      ears    , *please*. I know he wo ---                      
    ## [478]                --- for having so much young     blood     left. *Ha*, *ha*, *ha* ! Joe ---                 
    ## [479]               --- die, with what a grateful     heart     I shall *thank* *God* for ---                    
    ## [480]         --- farewell. A pleasant journey --      back    , sir. *Ahem* _b_ _b_ _b_ ---                     
    ## [481]        --- contemplating us with a watchful      eye      ! *Oh* Lor _b_ _b_ _b_ ---                       
    ## [482]                  --- _b_ that *I* *see* his      eye      glistening down at the very ---                  
    ## [483]                   --- *Ah* ! what a vale of     tears     we live in. Do we ---                            
    ## [484]                     --- I 'll take down the     heads     if you *please*, sir. Remarkable ---             
    ## [485]               --- bed; he 's always falling     asleep    in sermon-time -- and *to* ---                   
    ## [486]                --- *nay*, do n't shake your      head     and smile so sadly _b_ ---                       
    ## [487]         --- the office with your coach-hire      back    , *you* *know*; do n't spare ---                  
    ## [488]                    --- of the cage. But the     heart     is the bird. *Ah* ! How ---                      
    ## [489]                --- *know*. If you shut your      eyes    , perhaps you 'll go to ---                       
    ## [490]                  --- out after they 'd gone       to      bed, and sometimes before, *you* ---             
    ## [491]                   --- after they 'd gone to      bed     , and sometimes before, *you* *know*; ---         
    ## [492]               --- you. Another shake of the      hand    , Marchioness, if you *please*. Sit ---           
    ## [493]                  --- you have got into your     heads     about her, *of* *course*. Prove ---              
    ## [494]                   --- _b_ _b_ _b_ hold your     tongue    if you *please*, and let ---                     
    ## [495]                  --- coals of fire upon his      head    . Well ! *Ah* ! But I am ---                      
    ## [496]                     --- and mock him as his      face     came bobbing up, -- *oh*, ---                    
    ## [497]            --- *You* *see* where the little      feet     went bare upon the ground. ---                   
    ## [498]                     --- is a good and happy     sleep     -- *eh* _b_ _b_ _b_ ---                          
    ## [499]            --- *of* a dwelling-house at its      foot    , to an old servant who ---                       
    ## [500]                  --- _b_ *Ah* ! It wants my      eyes    , Charley _b_ _b_ _b_ _b_ ---                     
    ## [501]                    --- keep yer *hi* on his      ears    ) cut away to Boffin 's ---                       
    ## [502]                    --- keep yer *hi* on his      ears    ) cut away to Old Harmon ---                      
    ## [503]                    --- Keep yer *hi* on his      ears    .) Noddy Boffin, Eddard _b_ _b_ ---               
    ## [504]      --- eyes, warious. Mummied bird. Dried    cuticle   , warious. *Oh*, *dear* *me* ! That ---           
    ## [505]                        --- may go and buy a    skeleton   at the West End *if* ---                         
    ## [506]                   --- dust; and many 's the      bone    , and feather, *and* *what* *not*, ---            
    ## [507]                     --- with a glass in his      eye      ! *Oh* I know she 's ---                         
    ## [508]                   --- with his glass in his      eye      ! *Oh* what shall I do ---                       
    ## [509]              --- When my eldest brother was      born    , *of* *course* the rest of ---                   
    ## [510]                 --- have taken it into your      head     that *I* *mean* to pension ---                   
    ## [511]               --- and imitating a person 's      back     and legs. *Oh* ! I know ---                      
    ## [512]                    --- a person 's back and      legs    . *Oh* ! I know their tricks ---                  
    ## [513]               --- the meat. *As* *it* *is*,       go      to bed _b_ _b_ _b_ ---                           
    ## [514]                --- meat. *As* *it* *is*, go       to      bed _b_ _b_ _b_ _b_ ---                          
    ## [515]                   --- *As* *it* *is*, go to      bed      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [516]                --- *think* not. You 're not     asleep   , my Johnny _b_ _b_ _b_ ---                       
    ## [517]             --- but that *I* *believe* your      face     and voice, and I will, ---                       
    ## [518]             --- *Yes*. That accounts for my     hands     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [519]                 --- him, tapping him on the    shoulder   and beginning, " *I* *beg* *your* ---            
    ## [520]                   --- _b_ _b_ Is my present   endurance   none ? But *excuse* *me*; I ---                  
    ## [521]             --- lying *once* *again* in the      arms     of my own mother -- ---                          
    ## [522]                 --- ever *I* *see* her good      face    . I can still walk twenty ---                     
    ## [523]                --- *sorry* for them, and my      arms     are open to you still, ---                       
    ## [524]              --- deeply *thank* *you* in my     heart.    -- Alfred, Mr Twemlow thinks ---                 
    ## [525]       --- *you* *know*. YOU understand what    sweating   a pound means, do n't ---                        
    ## [526]                   --- set me *right* in the      back     and the legs. It 's ---                          
    ## [527]                   --- tell you to hold your     tongue   . *I* *beg* *your* *pardon*. Do ---               
    ## [528]              --- *pardon*. Do n't hold your     tongue   . Only, do n't contradict. Did ---                
    ## [529]                       --- _b_ _b_ It 's the    numbness  . *Yes*. It comes over me ---                     
    ## [530]               --- your lips again, and your    forehead  . There. O *poor* *thing*, *poor* ---             
    ## [531]                       --- ca n't give it. I     thirst    for information. What do *I* ---                 
    ## [532]                     --- _b_ _b_ _b_ *Oh* my      head     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [533]                     --- _b_ _b_ _b_ *Oh* my      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [534]              --- and almost equally upon my    skeleton  ), and *I* *mean* to live ---                     
    ## [535]                --- with my money. Flesh and     blood     ca n't bear it. *No* ---                         
    ## [536]          --- carrying off treasure from its     bowels    ? *No*, it was not to ---                        
    ## [537]                    --- me to hear from your      lips     what I would *rather* not ---                    
    ## [538]                     --- of the depths of my     heart     I earnestly and truly *beg* ---                  
    ## [539]         --- *I* *suppose* those gates would      suck     him down _b_ _b_ _b_ ---                         
    ## [540]              --- *Anyways* I says it again.     Sleep     where you slept last; the ---                    
    ## [541]            --- claim. On the contrary, they     rouse     my indignation when *I* *see* ---                
    ## [542]                       --- 's gone out of my      head     ! *Oh* *no*, it is n't, ---                      
    ## [543]                --- _b_ *Ah* ! very near his     heart     ! *However*, you have been a ---                 
    ## [544]                 --- _b_ *Yes*. I had better     sleep    , I think _b_ _b_ _b_ ---                         
    ## [545]          --- and Co. *after* *all* ! Little      Eyes    , Little Eyes, you 're too ---                    
    ## [546]     --- *after* *all* ! Little Eyes, Little      Eyes    , you 're too cunning by ---                      
    ## [547]                --- it out. What said Little      Eyes     ? " Now, *candidly* ? " *Ah* ! *However* the --- 
    ## [548]       --- _b_ *Good* *gracious* ! Is Little      Eyes     choking _b_ _b_ _b_ _b_ ---                      
    ## [549]                     --- _b_ _b_ _b_ *Oh* my      eye      ! Stop thief ! I am strangling. ---              
    ## [550]           --- am strangling. Fire ! *Oh* my      eye      ! A glass of water. Give ---                     
    ## [551]                     --- _b_ _b_ _b_ *Oh* my      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [552]                    --- my nose, and down my     throat   , and in my wind-pipe. *Ugh* ! ---                
    ## [553]                     --- _b_ _b_ And *Oh* my      Eye     , I 'm so sore _b_ ---                            
    ## [554]                --- something to my back and      arms    , and legs and shoulders. *Ugh* ! ---             
    ## [555]                   --- my back and arms, and      legs     and shoulders. *Ugh* ! It 's ---                 
    ## [556]                  --- and arms, and legs and   shoulders  . *Ugh* ! It 's down my ---                       
    ## [557]                   --- *Ugh* ! It 's down my     throat    again and ca n't come ---                        
    ## [558]                     --- _b_ _b_ _b_ *Oh* my      eye      ! do n't slap me ! I ---                         
    ## [559]                     --- my nose and down my     throat    -- *Ow* ! *Ow* ! *Ow* ! *Ah* ---                 
    ## [560]                     --- _b_ _b_ _b_ *Oh* my      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [561]                 --- are obliged to keep our      eyes     always open. And *you* *know* ---                
    ## [562]                  --- _b_ _b_ *No*. Touch my      face     with yours, in case I ---                        
    ## [563]                  --- *Yes*, Mr Wegg. By the      hand     of adorable woman _b_ _b_ ---                    
    ## [564]                --- *I* *mean* to knock your      head     against the wall _b_ _b_ ---                     
    ## [565]                   --- *see* you with my own      eyes     take your own clothes from ---                   
    ## [566]                    --- her, and there 's my      hand    , and *thank* *you* again _b_ ---                 
    ## [567]               --- been overfed since he was      born    . *Ha* ! *ha* ! *ha* _b_ _b_ ---                  
    ## [568]                --- _b_ _b_ *Yes*. Hold your     tongue    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [569]                --- counter. You do n't mind    sleeping   among the coffins, *I* *suppose* ? ---           
    ## [570]                    --- _b_ Do n't fret your    eyelids    *on* *that* *score* _b_ _b_ ---                  
    ## [571]              --- _b_ _b_ *Yes*, sir, rather    thirsty    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [572]                   --- arter him -- *oh*, my      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [573]              --- heavy swell cut ! *Oh*, my      eye     , what a game ! And his ---                       
    ## [574]                --- with the books under his      arm     . It 's *all* *right* enough. ---                 
    ## [575]                    --- mean by it ? Burn my      body     ! Do *you* *know* who you ---                    
    ## [576]             --- *know* there are fifty boys    snoozing   about Common Garden every night, ---             
    ## [577]                 --- neat as waxwork. My old      eyes     have seen them -- *ay*, ---                      
    ## [578]                  --- -- *ay*, and those old     hands     touched them too; for I ---                      
    ## [579]                     --- *it* when I saw his      face    . Poor girl ! poor girl ! She ---                 
    ## [580]             --- he 's a-blushing ! *Oh*, my      eye      ! here 's a merry-go-rounder ! Tommy ---         
    ## [581]                 --- she chucks me under the      chin    , *please*, sir; and makes all ---                
    ## [582]                  --- *think* I would harm a      hair     of his head _b_ _b_ ---                          
    ## [583]         --- *course* not ! Bless the bright      eyes     of your sex ! They never ---                     
    ## [584]           --- while ? *Ah* ! the same sweet      face    , but not so pale; the ---                        
    ## [585]       --- *of* *course* ever afterwards his     mouth     would be so obstinately closed ---               
    ## [586]                     --- as *I* *see* on the     faces     about me, a disposition to ---                   
    ## [587]                  --- there at all. *Oh*, my      eye     , my eye, wot a blow ---                          
    ## [588]                   --- all. *Oh*, my eye, my      eye     , wot a blow it is ---                            
    ## [589]                    --- you can not have the     heart     to kill me. *Oh* ! think ---                     
    ## [590]             --- disease which had made your      face     an index even *to* *your* ---                    
    ## [591]                 --- hear them from your own      lips     before we part, and *you* ---                    
    ## [592]              --- _b_ *Yes*. Leaning on your      arm      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [593]                         --- but a home -- a     heart     and home -- *yes*, dearest ---                   
    ## [594]                      --- to it -- Bolter 's     throat   , Bill; *never* *mind* the girl ---               
    ## [595]                 --- half an hour, with your      eye      against a lamp-post -- *eh*, ---                 
    ## [596]                     --- -- lots of pluck --    swallow    this -- *ah* ! -- capital ---                    
    ## [597]             --- if you please; nothing else     wakes     him -- *thank* *you*. Undo ---                   
    ## [598]                --- _b_ Elderly lady -- thin      face     -- rather skinny -- *eh* ---                     
    ## [599]                  --- -- thin face -- rather     skinny    -- *eh* _b_ _b_ _b_ ---                          
    ## [600]                   --- _b_ _b_ *I* *see* his      head     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [601]                --- _b_ damme, *I* *see* his      head     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [602]                    --- of her money. Do n't     frown    , Sir, do n't frown; *I* ---                      
    ## [603]                  --- n't frown, Sir, do n't     frown    ; *I* *say*, between you and ---                  
    ## [604]                     --- not in my friend 's      hand    . *However*, whether it be the ---                
    ## [605]                     --- to plunge it in his     heart    . *Oh*, it was a merry ---                        
    ## [606]                 --- it was with pleasure or     bodily    infirmity. He *rather* thought it ---            
    ## [607]                     --- _b_ Take hold of my      leg     ; and, when *I* *say* " Over, " ---               
    ## [608]                --- poising the poker in his      hand    , *however*, and taking a very ---                
    ## [609]                    --- to the box; t' other      leg     , Sir, *that* *'s* *it*; give ---                 
    ## [610]                 --- *'s* *it*; give us your      hand    , Sir. Up with you. You ---                       
    ## [611]                     --- *me*, it 's time to       go      to bed. It will never ---                        
    ## [612]                  --- _b_ _b_ _b_ _b_ Nobody     sleeps    in the other bed, *of* ---                       
    ## [613]                --- eddication -- as has n't     slept     about the markets, *no*, not ---                 
    ## [614]               --- sir, I should squeeze her      hand    , and I think -- *I* ---                          
    ## [615]                   --- _b_ _b_ *Ah*, my poor      head     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [616]                     --- *Oh*, he has a hard     heart    . Night after night does this ---                 
    ## [617]                 --- _b_ he has an obderrate     bosom    . *Oh*, my young friend, who ---                  
    ## [618]           --- here. Lord bless their little     hearts   , they thinks it 's *all* ---                     
    ## [619]                      --- _b_ _b_ I 've been     asleep   , *right* in front of the ---                     
    ## [620]       --- *God* *bless* *'em* (*cheers* and     tears    ). My young friend, Trundle, *I* ---              
    ## [621]                   --- _b_ _b_ *Oh*, you 've      woke     up, at last, have you ---                        
    ## [622]                  --- _b_ *Oh*, you 've woke       up     , at last, have you _b_ ---                       
    ## [623]                 --- _b_ _b_ _b_ 'The sexton     gasped    for breath. ' " What *do* *you* ---              
    ## [624]              --- _b_ 'The sexton gasped for     breath   . ' " What *do* *you* *think* of ---              
    ## [625]               --- -- and a most astonishing     tongue    it was -- " *I* *'m* ---                         
    ## [626]                 --- the air, stood upon his      head    , or *rather* upon the very ---                   
    ## [627]     --- threw a Somerset with extraordinary    agility   , *right* to the sexton 's ---                    
    ## [628]                --- *right* to the sexton 's      feet    , at which he planted himself ---                 
    ## [629]        --- *Ah* ! " cried the goblin, whose     cheeks    and throat were transparent, as ---              
    ## [630]               --- Court ? They 've not been    sleeping  , I know that. *Ah*, they ---                     
    ## [631]                --- all its ill-will and bad     blood    , rise up before you. *You* ---                   
    ## [632]               --- deal door; but bein' only      eyes    , *you* *see*, my wision 's ---                   
    ## [633]                     --- _b_ _b_ I must keep     awake    . *I* *suppose* I shall hear ---                  
    ## [634]              --- o' light, *right* into the      back     parlour winder _b_ _b_ _b_ ---                   
    ## [635]             --- _b_ _b_ *Bravo* ! Heel over      toe      -- cut and shuffle -- ---                        
    ## [636]               --- _b_ *Oh*, the hardness of     heart     of these inveterate men _b_ ---                  
    ## [637]                --- nothing of his jolly red      face    . *However*, there he lay, and ---                
    ## [638]             --- and sweet faces, and pretty      legs     and feet; *in* *short*, he ---                   
    ## [639]              --- faces, and pretty legs and      feet    ; *in* *short*, he was fond ---                   
    ## [640]                 --- held some ladies in his      arms     before this time; *I* *believe*, ---             
    ## [641]           --- the wishes of the constituent      body    , must for ever *endear* him ---                  
    ## [642]                --- ever *endear* him to the     hearts    and souls of such of ---                         
    ## [643]               --- _b_ _b_ *Never* *mind* my      eyes    ; you had much better read ---                    
    ## [644]                   --- should keep up a good     heart    , because, *dear* *me*, I 'm ---                  
    ## [645]           --- *so* *forth*; but, bless your     hearts   , I could n't make the ---                        
    ## [646]                    --- _b_ _b_ _b_ *Oh*, my      eye     , how prime ! I am SO ---                         
    ## [647]                     --- _b_ _b_ You want to      bite     his ear off, *I* *suppose* ---                   
    ## [648]                    --- You want to bite his      ear      off, *I* *suppose* _b_ _b_ ---                   
    ## [649]               --- *God* ! I feel his sacred     tears     upon my face, and his ---                        
    ## [650]              --- his sobs strike against my     heart    . O, see ! *Thank* *God* for ---                  
    ## [651]                   --- Do n't let your sober      face     elate you, *however*; you do ---                 
    ## [652]                 --- and not open that great     mouth     of yours. *Bah* ! Put him ---                    
    ## [653]                      --- _b_ _b_ _b_ To the      eye      it is *fair* *enough*, here; ---                 
    ## [654]               --- *thank* *you* with all my     heart    , and will open all my ---                        
    ## [655]               --- *you* *see* with your own      eyes     that he was a young ---                          
    ## [656]                  --- pick him up again. His      face     is *bleeding* and covered with ---               
    ## [657]                --- _b_ for an earthquake to    swallow    a town. *Eh* well ! Tell ---                     
    ## [658]   --- think about, without embarrassing our     heads     concerning others. *I* *think* for ---           
    ## [659]                    --- _b_ _b_ and what the     tongue    is, *I* *suppose* the man ---                    
    ## [660]              --- like herself, is French by     birth    . And speaking of Gaspard (*ah*, ---              
    ## [661]                  --- that height of so many      feet    ; *in* *other* *words*, the present ---           
    ## [662]                    --- in the middle of the      cell    . So ! Light them, *you* _b_ ---                  
    ## [663]                 --- bunch of grass upon his      back    . *Ha*, *ha* ! That was *well* ---                
    ## [664]                     --- one of whom had his      head     *hanging* *on* by a single ---                   
    ## [665]              --- *hanging* *on* by a single      hair     as he passed the Barriers. ---                   
    ## [666]                        --- he is not at the      head     of them. But, *no*, gentlemen ---                
    ## [667]                  --- you. *I* *see* in your      face     that you know I can ---                          
    ## [668]                    --- *No*. Yet I know the      face     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [669]             --- the way of Subjects without     heads    , *dear* *me*, plentiful enough fur ---           
    ## [670]       --- bravely, ` *Yes* ! ' I kissed her      hand    , and she took him in ---                         
    ## [671]              --- *thank* *you* with all our     hearts   , and all our love and ---                        
    ## [672]              --- *Yes*. I have observed his      face    . I have observed his face ---                    
    ## [673]             --- have my certificate in your      hand     with the rest, *you* *know*, ---                 
    ## [674]                --- o' this here blessed old      head     o' mine, *I* *think* not. ---                    
    ## [675]                   --- with a child upon her     bosom    , who bears my name. *I* ---

``` r
# Z7 ["If"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("Z7"), context = 0)
y
```

    ## [  1]                   --- Rick, *if* I had a     hand    to spare at present, I ---                 
    ## [  2]                --- be tired; you can not     tire    me *if* you try _b_ ---                    
    ## [  3]           --- watching for my master. My    heart    's in my mouth. *If* ---                   
    ## [  4]                    --- My heart 's in my    mouth   . *If* he was to catch ---                  
    ## [  5]         --- inconvenient. *If* you had a  blue-eyed  daughter you would n't like ---            
    ## [  6]             --- *If* this is his regular    sleep    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [  7]                 --- *If* it was never to     wake    no more, you 'd think ---                  
    ## [  8]              --- knock me well about the     head   . I do n't mind. *If* ---                   
    ## [  9]           --- *if* there is any uncommon     eye     in the case, it is ---                     
    ## [ 10]         --- entirely in your ladyship 's    hands   . *If* your ladyship was to ---             
    ## [ 11]                 --- -- and stands to her     arms   . *If* the old girl fires ---               
    ## [ 12]         --- ferocious vows as never were   breathed  on paper before, that *if* ---             
    ## [ 13]                --- thank you with all my    heart   . *If* I was not innocent ---               
    ## [ 14]                 --- *If* he had dared to   breathe   them to me, sir -- ---                     
    ## [ 15]                 --- to mount up into his     head   , not to consider that *if* ---             
    ## [ 16]                  --- and you must have a    heart    to pity me. *If* you ---                   
    ## [ 17]              --- _b_ _b_ will break your     neck    *if* you meddle with wot ---               
    ## [ 18]              --- soul too large for your     body   , *if* you come to that, ---                
    ## [ 19]             --- was more correct in your     born    days --'Ecod, *if* I do ---                
    ## [ 20]               --- for, *if* he did, some     eyes    would grow dim that are ---                
    ## [ 21]           --- the stars come out ! Whose     eyes    are they ? *If* they are ---               
    ## [ 22]               --- *If* they are angels '     eyes   , why do they look down ---                 
    ## [ 23]                 --- *if* you had left my     arms    and legs at liberty. What ---              
    ## [ 24]                  --- _b_ *If* I had been     born    a corsair or a pirate, ---                 
    ## [ 25]             --- day, and the watchman 's    waking   up. Angelic Miggs ! *If* you ---           
    ## [ 26]           --- and the watchman 's waking      up    . Angelic Miggs ! *If* you 'll ---          
    ## [ 27]                --- _b_ _b_ _b_ Curb your    tongue  , in God 's name, *if* ---                  
    ## [ 28]          --- answers to your voice), and    rouse    the neighbourhood besides, *if* you ---    
    ## [ 29]                 --- _b_ _b_ _b_ _b_ Fall     back   , *if* you please, or go ---                
    ## [ 30]              --- own showing; in his own     hand   . Forgive me, *if* I have ---               
    ## [ 31] --- coldness. 'Death, Chester, *if* your    blood    ran warmer in your veins, ---              
    ## [ 32]               --- it *if* it reached her     ears   ; it is too nearly connected ---            
    ## [ 33]               --- *even* *if* we wade in    blood   , " and they threw up their ---             
    ## [ 34]               --- *even* *if* we wade in    blood   ; No Popery ! Lord George ! Down ---        
    ## [ 35]                 --- *if* you 're not too    tired    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 36]          --- saint, *if* ever saint drew    breath   on this bad earth _b_ ---                  
    ## [ 37]               --- well ? I hope you have    slept    well ? *If* my prayers are ---             
    ## [ 38]             --- your deed, *if* not your     hand    -- I know you _b_ ---                      
    ## [ 39]                 --- or can. *If* you had     eyes   , and could look around you ---             
    ## [ 40]                    --- and *if* I do n't    sleep    here, I shall not go ---                   
    ## [ 41]                --- from me, *if* we come     hand    to hand to-night. Up here ---              
    ## [ 42]                --- I would n't twist his     neck    round, on the chance, *if* ---             
    ## [ 43]               --- of life, except in his     legs   , and *if* you put him ---                  
    ## [ 44]           --- and quickly. And open your     ears   , master, *if* you would ever ---           
    ## [ 45]               --- To eat, and drink, and      go     to sleep, *as* *long* *as* ---             
    ## [ 46]               --- eat, and drink, and go      to     sleep, *as* *long* *as* I ---              
    ## [ 47]                 --- and drink, and go to    sleep   , *as* *long* *as* I stay ---               
    ## [ 48]                   --- when he said in my   hearing  , that *if* I moved you ---                 
    ## [ 49]               --- die but once. *If* you     wake    in the night, sing that ---                
    ## [ 50]          --- and shattered in your every     limb   ; *if* you were ailing, weak, ---           
    ## [ 51]               --- arms. I would have two     arms   , *if* it was me, though ---                
    ## [ 52]                  --- me, *if* I throw my     head    back, and take it off ---                  
    ## [ 53]                 --- *if* I throw my head     back   , and take it off quick. ---                
    ## [ 54]          --- friends ! Why, Lord love my    heart    alive, *if* it ai n't ---                  
    ## [ 55]                 --- You give me my money     back   , *if* you please _b_ _b_ ---               
    ## [ 56]                   --- know *if* I have a    heart    at all. " " Then, my dear, " ---           
    ## [ 57]                    --- but I 'm a little    tired   . *If* you and Mr. David ---                
    ## [ 58]                --- a laughing and half a    crying  , " Yes, Uncle ! *If* you please. " - ---   
    ## [ 59]                 --- so, *if* you saw his moustachios. Red by nature, black by ---               
    ## [ 60]           --- whisker ! As to Charley 's     legs   , *if* they were only a ---                 
    ## [ 61]           --- six. But somehow she wants    heart   . *If* you understand _b_ _b_ ---           
    ## [ 62]              --- word from me brings the    tears    into her eyes; and *if* ---                
    ## [ 63]            --- brings the tears into her     eyes   ; and *if* you was to ---                   
    ## [ 64]                 --- *if* you knew how my    heart    is torn. *If* even you, ---                
    ## [ 65]                 --- *if* you have a kind    heart   , as I think you have ---                   
    ## [ 66]            --- *If* the likeness of that     face    do n't turn to burning ---                 
    ## [ 67]                  --- me, *if* you have a    heart   , Miss Mills. Let me die ---                
    ## [ 68]                    --- my lot to have my    hands    unfettered - *if* I had not ---            
    ## [ 69]            --- complain of her. *If* she    tires    me, sometimes, by her praises ---          
    ## [ 70]             --- appears to know. *If* he   breathed , certainly he never spoke. Medical ---     
    ## [ 71]                  --- in this world by my     eyes    again ! 'Dear, *if* your heart ---         
    ## [ 72]        --- eyes again ! 'Dear, *if* your    heart    is hard towards me - justly ---            
    ## [ 73]                 --- _b_ _b_ _b_ I should    sleep    the better for that, *if* ---              
    ## [ 74]               --- the law into their own    hands   . *If* they do, it is ---                   
    ## [ 75]            --- look my fellow-man in the     face   , and punch his head *if* ---               
    ## [ 76]              --- the face, and punch his     head    *if* he offended me. My ---                
    ## [ 77]                    --- *if* it 's by the     hair   , and raise the very stones ---             
    ## [ 78]           --- I wonder, *if* your loving    heart    will not break, you have ---               
    ## [ 79]                --- _b_ _b_ and *if* your     head    is human, I 'll break ---                  
    ## [ 80]        --- feeding. Now, sir, about that    brain    of yours, *if* you 'll ---                 
    ## [ 81]                  --- _b_ _b_ _b_ *if* my     eyes    have not deceived me, there ---            
    ## [ 82]               --- That 's all. *If* dear    Fanny    were a Dombey ! -- But ---                 
    ## [ 83]                 --- you, *if* you do n't    rouse    yourself. It 's necessary for ---          
    ## [ 84]          --- sister, *if* you please: my     arm     today is Miss Tox 's. ---                  
    ## [ 85]             --- a little restless in his    sleep   . Pat his back, *if* you ---                
    ## [ 86]                --- in his sleep. Pat his     back   , *if* you please _b_ _b_ ---               
    ## [ 87]            --- away. *If* those is Latin     legs    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 88]                 --- make but a very poor     hand    at that, *if* I tried ---                  
    ## [ 89]                 --- but *if* you come to    blood   , Sir _b_ _b_ _b_ _b_ ---                   
    ## [ 90]                  --- _b_ *If* the dog 's    teeth    have entered the leg, Sir ---              
    ## [ 91]                   --- it. But here 's an     arm     for Mrs Granger *if* she ---               
    ## [ 92]             --- _b_ _b_ _b_ beyond which  endurance  becomes ridiculous, *if* not culpable. --- 
    ## [ 93]        --- perfect right to replace poor    Fanny    *if* he chooses; I can ---                 
    ## [ 94]                 --- _b_ *If* I dropped a     tear    upon your hand, may it ---                 
    ## [ 95]                --- a gentle word in your   hearing  , may it deafen you ! *If* ---              
    ## [ 96]         --- have just demanded ? *If* my    heart    were pure and all untried, ---             
    ## [ 97]                --- *If* you could see my     legs    when I take my boots ---                   
    ## [ 98]                --- guile and guilt of my    heart    be, *if* I pretended to ---                
    ## [ 99]                --- in that state that my    brain    is going, *if* not gone, ---               
    ## [100]              --- always worn it round my     neck    ! *If* I had gone down ---                 
    ## [101]            --- could have forced from my     lips   . *If* I had been prosperous; ---           
    ## [102]                --- my last breath I will   breathe   your name to God *if* ---                  
    ## [103]             --- Joseph Bagstock is a bad     hand    at a counterfeit. *If* you ---             
    ## [104]                --- I have done. My saucy    tongue   says no more, *if* you ---                 
    ## [105]            --- have followed him with my     eyes   , In the broad day. *If* ---                
    ## [106]                    --- _b_ *if* I shed a     tear   , it is a tear of ---                       
    ## [107]               --- _b_ *If* Papa is still    asleep  , or can spare me *if* ---                  
    ## [108]                  --- spare me *if* he is    awake   , I will go immediately _b_ ---             
    ## [109]               --- give 'em you down your    throat  , *if* you come a-ketching hold ---         
    ## [110]                 --- _b_ I 'll smash your     eye    , *if* you do n't look ---                  
    ## [111]          --- me with that clenched right     hand   . Unclench it, *if* you please ---          
    ## [112]                --- to it once more. Your     arm    , *if* you please. Softly, for ---          
    ## [113]                 --- me ! I 'll stone yer     eyes    out, s'elp me ! *If* I ---                 
    ## [114]              --- would rally me; *if* my    pulse    had stopped, I feel as ---                 
    ## [115]                 --- *if* you are not too    tired    to tell me more of ---                     
    ## [116]                --- it the better, *if* I    sleep    on it to-night _b_ _b_ ---                 
    ## [117]       --- *If* even Mr. Grewgious, whose     head    is much longer than mine, ---              
    ## [118]                --- for. *If* you 'd been     born    a Squeaker _b_ _b_ _b_ ---                 
    ## [119]                --- _b_ *If* you had been     born    such, would you have been ---              
    ## [120]                  --- this far on his way     back   . He 's a gentleman, *if* ---               
    ## [121]                   --- _b_ *If* a fool 's     head    ca n't express better opinions ---         
    ## [122]                --- _b_ *If* you have the    heart    to think so _b_ _b_ ---                    
    ## [123]             --- again, *if* you have the    heart    to think so _b_ _b_ ---                    
    ## [124]                --- _b_ *If* you have the    heart    to be so, you mean, ---                    
    ## [125]                 --- your Bill 's in good    hands   , I know it. And *if* ---                   
    ## [126]                --- _b_ *If* there is bad    blood    between you and them _b_ ---               
    ## [127]               --- you ? *If* you 're not    tired   , Mr. Pip - though I know ---               
    ## [128]                   --- _b_ that I have no    heart    - *if* that has anything to ---            
    ## [129]             --- her. *If* she tears your    heart    to pieces - and as it ---                  
    ## [130]                  --- over with you on my   fingers  , *if* you please, the names ---            
    ## [131]             --- had never once seen your     face    - *if* you had done that, ---              
    ## [132]     --- colonists have their horses (and    blood    'uns, *if* you please, good ---            
    ## [133]               --- off, towing him by the     hair   , *if* it had come to ---                   
    ## [134]     --- faults and disappointments on my     head   , *if* you can receive me ---               
    ## [135]                 --- _b_ *If* you want to    cheek    us, pay your ochre at ---                  
    ## [136]                --- last ! He 'd open his     eyes   , that boy would, *if* he ---               
    ## [137]                --- you grow up under his     eyes   , to very little purpose, *if* ---          
    ## [138]          --- good, Louisa; for *if* your     head    begins to split as soon ---                
    ## [139]   --- respects, and particularly for the    lungs   . *If* you are one of ---                   
    ## [140]   --- principally living on garbage, and   sleeping  in market baskets. Why, *if* ---           
    ## [141]               --- would have risen to my     lips    then, *if* you had given ---               
    ## [142]                --- that has arisen in my    heart   ; *if* you had known that ---               
    ## [143]                 --- more. I have a light     hand   ; and *if* I have been ---                  
    ## [144]                 --- *if* you had a short     nap     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [145]               --- upon me lying dead, my     body    should bleed, *if* I could ---             
    ## [146]           --- lying dead, my body should    bleed   , *if* I could make it, ---                 
    ## [147]               --- *If* you please, I was     born    here, sir _b_ _b_ _b_ ---                  
    ## [148]                    --- I am sure the tea    chests   alone would kill me *if* ---               
    ## [149]                  --- and *if* we can not     wake    them so, we must walk ---                  
    ## [150]                 --- *if* you are not too    tired    to walk to Harley Street, ---              
    ## [151]                --- *if* one keeps one 's     eyes    upon him, he said when ---                 
    ## [152]                 --- and there I still am   snoring   I dare say *if* the ---                    
    ## [153]              --- Quart of double stout a     head   . Pint of wine too, *if* ---                
    ## [154]                --- _b_ _b_ *If* they all      go     to bed, why I must ---                     
    ## [155]                 --- _b_ *If* they all go      to     bed, why I must go. ---                    
    ## [156]                  --- *If* they all go to     bed    , why I must go. They ---                   
    ## [157]       --- silence and solitude, *if* one     went    to bed two hours hence ---                 
    ## [158]          --- and solitude, *if* one went      to     bed two hours hence _b_ ---                
    ## [159]           --- solitude, *if* one went to     bed     two hours hence _b_ _b_ ---                
    ## [160]                   --- as fast as ever my     feet    would carry me; and *if* ---               
    ## [161]           --- Mr Clennam, with very dark     hair    and very dark eyes. *If* ---               
    ## [162]              --- dark hair and very dark     eyes   . *If* I mistake not, *if* ---              
    ## [163]              --- name is in everybody 's    mouth    -- *if* my name was ---                    
    ## [164]             --- him. *If* you loved him,    Fanny    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [165]                --- _b_ _b_ do you think,    Fanny   , that *if* you were to ---                 
    ## [166]          --- *if* you would uncover your     face    and look _b_ _b_ _b_ ---                   
    ## [167]           --- slighted the whisper in my    heart   , that *if* my father had ---               
    ## [168]                --- the secrets of my own    breast   more distinctly; *if*, through my ---      
    ## [169]     --- unacceptable *if* offered by the     hand    of true regard such visions ---            
    ## [170]           --- manner of colours, and his     eyes    as dull as *if* they ---                   
    ## [171]                --- who is described as a   one-eyed  almanac, *if* I am not ---                 
    ## [172]           --- of old flower-pots, in the     back    yard. *If* you could pile ---              
    ## [173]                   --- You wo n't mind my    going    to sleep, *if* I can ---                   
    ## [174]                 --- wo n't mind my going      to     sleep, *if* I can _b_ ---                  
    ## [175]                  --- me too soon, I must   slumber   again. *If* any young orphan ---           
    ## [176]                --- 's notion of a wooden     leg    , *if* perfectly agreeable to herself ---   
    ## [177]               --- _b_ Come down into the     back    parlour, *if* you please, my ---           
    ## [178]                --- you think that *if* I     spat    upon him, I could degrade ---              
    ## [179]          --- I believe no satirist could   breathe   this air. *If* another Juvenal ---         
    ## [180]                  --- _b_ _b_ with all my    heart   . Good arternoon, Mrs Mould ! *If* ---      
    ## [181]                 --- _b_ than *if* he had  swallowed  the contents of half the ---               
    ## [182]                  --- to take it into her     head   , *if* you talk to her ---                  
    ## [183]              --- hidden in each other 's    hearts  ; and *if* we had glass ---                 
    ## [184]              --- *If* you could set your     back    right slap agin that curtain-peg, ---      
    ## [185]    --- public character ! Always got her     eye     upon her country, sir ! *If* ---           
    ## [186]             --- *if* there really is, oh   gasping   one ! a Pogram or a ---                    
    ## [187]                   --- _b_ _b_ and let my     face    be ! *As* *long* *as* I ---                
    ## [188]                   --- *as* I can show my    teeth    when I want to (and ---                    
    ## [189]                 --- was quite as weak as    flesh   , *if* not weaker _b_ _b_ ---               
    ## [190]                --- sure as ever you were     born   , *if* I had n't come ---                   
    ## [191]             --- him; that *if* he should     wake    from his delusion, even at ---             
    ## [192]        --- *If* Pecksniff had showed his     head   , or had only so much ---                   
    ## [193]         --- nature, always ready to shed    tears    *if* you look at him, ---                  
    ## [194]                  --- you say, for you 'd     tire    your own patience out *if* ---             
    ## [195]                 --- _b_ I 'll knock your    brains   out, *if* you speak another ---            
    ## [196]                --- night; and *if* I can    sleep    all day to- morrow, so ---                 
    ## [197]                 --- I 've got trouble to    sleep    off, *if* I can. Keep ---                  
    ## [198]             --- 've got trouble to sleep     off    , *if* I can. Keep the ---                  
    ## [199]                   --- see it, *if* I was    asleep   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [200]            --- Mr Westlock also, *if* my     eyes    do not deceive, and a ---                  
    ## [201]              --- to himself; and let her    sleep    *as* *long* *as* she likes. ---            
    ## [202]                  --- _b_ *If* you hurt a     hair    of her head, you shall ---                 
    ## [203]      --- the murderin' wagabond upon his    knees    ! *If* he wants noise, he ---              
    ## [204]               --- *if* the bending of my    finger   would remove a halter from ---             
    ## [205]              --- air. What 's this ? Her     hand    is trembling strangely. See *if* ---       
    ## [206]                --- _b_ _b_ _b_ *If* your    brains   is not turned topjy turjey, ---            
    ## [207]           --- would be ! *If*, while our    bodies   grow old and withered, our ---             
    ## [208]                --- -- *if* in mercy they  slumbered  -- by means of idle ---                    
    ## [209]               --- it, *even* *if* I kept    awake   , which I think very doubtful. ---          
    ## [210]            --- would sell your flesh and    blood    for money; yourself, *if* you ---          
    ## [211]                 --- eyes quite out of my     head   , *if* they choked him. Well ---            
    ## [212]                --- up again, or have his   jugular   separated *if* he dares to ---             
    ## [213]                   --- not *if* I work my   fingers   to the bone, not *if* ---                  
    ## [214]               --- work my fingers to the     bone   , not *if* I am driven ---                  
    ## [215]              --- shall save him a broken     head   , *if* he talks till midnight ---           
    ## [216]           --- *if* I had fractured every     limb   , and still preserved my senses, ---        
    ## [217]               --- old man; and *if* your     hand    placed me in the grave, ---                
    ## [218]           --- besides. You may wring his     neck    *if* you please. I shall ---               
    ## [219]             --- bootuns *if* she bea n't    asleep   agean _b_ _b_ _b_ _b_ ---                  
    ## [220]          --- *If* admiration of a pretty     face    were criminal, I should be ---             
    ## [221]              --- to the Saracen with Two    Necks   . *If* the waiter took him ---              
    ## [222]                 --- Mr Noggs with all my    heart    ! " then, *if* you do _b_ ---              
    ## [223]            --- every coin is rusted with    tears   , *if* not red with the ---                 
    ## [224]                --- *if* not red with the    blood    of ruined men, who have ---                
    ## [225]              --- _b_ *If* you value your     head    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [226]                --- _b_ _b_ what style of     nose    ? What order of architecture, *if* ---     
    ## [227]       --- is philosophy, and the earthly    bodies   is philosophy. *If* there 's ---           
    ## [228]            --- screw loose in a heavenly     body   , that 's philosophy; and *if* ---          
    ## [229]                 --- have no rest. *If* I    sleep   , what rest is that which ---               
    ## [230]           --- have your sister 's little     hand   , sir, *if* she had refused ---             
    ## [231]               --- nail, I 'll pinch your     eyes   , *if* you talk to me ---                   
    ## [232]          --- this herself. *If* she did, unconscious of any bar to her ---                      
    ## [233]               --- on your simple note of     hand   , *if* I had n't unexpectedly ---           
    ## [234]              --- an atom from anybody 's     hand    but mine *if* you please. ---              
    ## [235]           --- draw again. Look at wooden     legs   . *If* there was only one ---               
    ## [236]              --- back. *If* you let your     hand    tremble so, we can never ---               
    ## [237]                 --- _b_ _b_ when you 're    tired   , to sleep *as* *long* *as* ---             
    ## [238]               --- when you 're tired, to    sleep    *as* *long* *as* ever you ---              
    ## [239]              --- he was looking over his   shoulder , *if* anybody could have seen ---          
    ## [240]           --- I would never shed another     tear    *if* every penny had been ---              
    ## [241]           --- enjoyed. *If* we have been    tired    or hungry, we have been ---                
    ## [242]           --- bedstead, and *if* you 're    going    to sleep in that way, ---                  
    ## [243]               --- and *if* you 're going      to     sleep in that way, you ---                 
    ## [244]        --- patiently for the kindness of    heart    you have shown to-night, *if* ---          
    ## [245]                  --- I 'll take down the    heads    *if* you please, sir. Remarkable ---       
    ## [246]              --- sadly, *if* you knew my    heart   . Do not look at me ---                     
    ## [247]             --- know. *If* you shut your     eyes   , perhaps you 'll go to ---                 
    ## [248]            --- you. Another shake of the     hand   , Marchioness, *if* you please. Sit ---     
    ## [249]                --- _b_ _b_ _b_ hold your    tongue   *if* you please, and let ---               
    ## [250]            --- leave this good fellow to     wake    them, *if* he can. I ---                   
    ## [251]                 --- _b_ I would not have    roused   you, *if* I had known ---                  
    ## [252]             --- that, *if* it would only    rouse    her. She has slept so ---                  
    ## [253]                      --- G. F. T. on his     arm    . Look and see *if* he ---                  
    ## [254]               --- you got nothing out of    bodies   *if* it was ever so ---                    
    ## [255]                --- _b_ _b_ _b_ Cast your     eye     along the shelves, and, *if* ---           
    ## [256]             --- choke, and sets his weak     eyes    watering; 'as a Monstrosity, *if* ---      
    ## [257]                  --- it out. 'I have n't    nerve    to play *even* *if* I ---                  
    ## [258]             --- bread he earns, with his    tears    -- or *if* not with ---                    
    ## [259]                --- might be put into his     head    or somebody else 's, *if* ---              
    ## [260]                 --- be pointed at by the    finger   of scorn. *If* I indicated ---             
    ## [261]              --- he should have held his    tongue  . *If* he had held his ---                  
    ## [262]                 --- *If* he had held his    tongue   he would have kept out ---                 
    ## [263]                   --- *If* I had held my    tongue  , you would never have seen ---             
    ## [264]                     --- I do n't want no    sleep   , I do n't. Or *even* ---                   
    ## [265]               --- know I should pull his     hair    *if* he WAS here _b_ ---                   
    ## [266]             --- would be, *even* *if* my     back    were not bad and my ---                    
    ## [267]            --- My very bones is rendered    flabby   by brooding over it. *If* ---              
    ## [268]            --- sharper than a serpent 's    tooth   , *if* he was n't as ---                    
    ## [269]                 --- ago. But *if* he has     gone    to bed, I 'll put ---                      
    ## [270]                 --- But *if* he has gone      to     bed, I 'll put a ---                       
    ## [271]                  --- *if* he has gone to     bed    , I 'll put a paper ---                     
    ## [272]            --- *if* he came sneaking and   sniffing  about the property, he should ---          
    ## [273]          --- And, *if* looking into this     eye     of mine, he dares to ---                   
    ## [274]                --- me now again, upon my    knees   , *if* it would spare him ---               
    ## [275]                  --- beg and pray, or my    heart    will break *if* this goes ---              
    ## [276]                  --- way, *if* I draw my     arm     over your shoulder like this, ---          
    ## [277]                    --- see a black on my     nose   , tell me so; *if* you ---                  
    ## [278]                --- say to me under those    heads   . But *if* I may, with ---                  
    ## [279]               --- _b_ Not even, *if* his    hands    war n't tied, he would ---                 
    ## [280]            --- anything, *if* I have n't    sleep    _b_ _b_ _b_ _b_ _b_ ---                    
    ## [281]               --- have one in your noble    heart   . Respect my good name. *If* ---            
    ## [282]              --- better for her ! Do n't    rouse    her, *if* you can help ---                 
    ## [283]          --- fetched a bundle under your     arm    , from among that timber, *if* ---          
    ## [284]          --- flogging, and that *if* his     skin    and bones are not tingling, ---            
    ## [285]               --- that *if* his skin and    bones    are not tingling, aching, and ---          
    ## [286]             --- Harmon 's arm round your    waist    now, my pretty. *If* ever ---              
    ## [287]             --- _b_ _b_ this touches the    blood    of the family. *If* Mr ---                 
    ## [288]               --- _b_ Lor bless her dear    heart   , when she has lived *as* ---               
    ## [289]                 --- we let 'em have live    bodies  . *If* you had kept the ---                 
    ## [290]                 --- _b_ _b_ _b_ _b_ Dear    heart    alive ! *If* we had known ---              
    ## [291]             --- the dog. Look after your     legs    *if* you do _b_ _b_ ---                    
    ## [292]       --- Show the gentleman in, Barney;     wake    up first, *if* convenient _b_ ---          
    ## [293]       --- the gentleman in, Barney; wake      up     first, *if* convenient _b_ _b_ ---         
    ## [294]                  --- _b_ _b_ _b_ Burn my     body   , *if* he is n't more ---                   
    ## [295]            --- upon her, whispered in my     ear     that *if* her baby was ---                 
    ## [296]               --- that *if* her baby was     born    alive, and thrived, the day ---            
    ## [297]       --- and a opera-glass between your  shoulders , *if* you want to come ---                 
    ## [298]                    --- I had his bull 's    throat   between my fingers now. *If* ---           
    ## [299]            --- bull 's throat between my   fingers   now. *If* he comes back, ---               
    ## [300]                   --- eyes on her son 's     face   , 'that *if* an enthusiastic, ardent, ---   
    ## [301]            --- *If* you buried him fifty     feet    deep, and took me across ---               
    ## [302]             --- strength, *if* I 'm once    roused  . I only want a little ---                  
    ## [303]                 --- *if* you mix it with    biling   water, it 'll go nigh ---                  
    ## [304]              --- and should have gone to    sleep   , as fast as Newgate, *if* ---              
    ## [305]                   --- one ! I 'll eat my     head    *if* he is not a ---                       
    ## [306]                   --- _b_ He 'll eat his     head   , *if* he does n't _b_ ---                  
    ## [307]                    --- stars I 've got a     head   ; for *if* we had n't ---                   
    ## [308]                 --- 'll let her a little    blood   , without troubling the doctor, *if* ---    
    ## [309]              --- proclaim it with my own     lips    upon the spot, *if* I ---                  
    ## [310]             --- child, *if* it should be     born    alive, and ever come of ---                
    ## [311]         --- child would share her gentle    heart   , and noble nature. *If* he ---             
    ## [312]              --- idiot. *If* that 's the     eye     of the law, the law ---                    
    ## [313]              --- I might possess at your     feet   , and *if* you still adhered ---            
    ## [314]                --- what I wanted, *if* I     woke    him now, but I know ---                    
    ## [315]                   --- him, sir -- in the     leg    , *if* you please; nothing else ---         
    ## [316]        --- *if* you please; nothing else    wakes    him -- thank you. Undo ---                 
    ## [317]            --- -- but really, *if* their complexions were a little better, do ---               
    ## [318]              --- hand corner of his left     eye    . " *IF* _b_ _b_ _b_ _b_ ---                
    ## [319]                --- of his rage, *if* his     arm     had not been stayed by ---                 
    ## [320]              --- Sammy, *if* you 'd been     born    in that station o' life ---                
    ## [321]               --- will be my excuse. The     back    kitchen 's empty, Sir. *If* ---            
    ## [322]                  --- *if* I found he was  insensible to kindness, I 'd try ---                  
    ## [323]                --- much -- you could n't   swallow   that, *if* the child did ---               
    ## [324]             --- manner. " I 'll kick his    brains   out, *if* he has any ---                   
    ## [325]              --- any --, or fracture his    skull    *if* he has n't. " Exerting ---            
    ## [326]           --- thoughts, and hidden in my    heart    -- *if* it ever had ---                    
    ## [327]             --- that young lady from any     lips   ; and that *if* I knew ---                  
    ## [328]                 --- *if* you wish her to    thirst   for it. Judiciously show a ---             
    ## [329]             --- you would shout and shed    tears    for anything, *if* it made ---             
    ## [330]        --- will always remember it, dear    Heart    ! I will remember it *as* ---              
    ## [331]                   --- he ! I 'll have my     head    took off, *if* he was ---                  
    ## [332]             --- your heels is where your     head    is, *if* such should be ---                
    ## [333]               --- put the stoppers to my     lips   . *If* I had wanted to ---                  
    ## [334]               --- _b_ _b_ _b_ *If* those     eyes    of yours were bed-winches _b_ ---          
    ## [335]               --- a handful of that dark     hair    upon your head, *if* you ---               
    ## [336]             --- that dark hair upon your     head   , *if* you lay a finger ---                 
    ## [337]                 --- head, *if* you lay a    finger   on me _b_ _b_ _b_ ---

``` r
# N3.4 ["Measurement: Volume"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("N3.4"), context = 0)
y
```

    ## [1]          --- a person 's body into    pins    and needles, with their *pints* ---         
    ## [2]       --- person 's body into pins     and    needles, with their *pints* all ---         
    ## [3]          --- 's body into pins and   needles , with their *pints* all ways. ---           
    ## [4]     --- under the cushion for your    head   . Here 's a burial *volume*. ---             
    ## [5]      --- *Quart* of double stout a    head   . *Pint* of wine too, if ---                 
    ## [6] --- *volume* of our Registers. Her    birth   is in what I call ---                       
    ## [7]    --- the first *volume*; she lay   asleep  , on this very floor, with ---               
    ## [8]     --- had been half drowned, and swallowing a *gallon* of it _b_ ---                    
    ## [9]    --- *a* *pint* of oatmeal. " My    heart   ! " says the ungrateful villain, " what ---

``` r
# I1.3+ ["Money: Price"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("I1.3+"), context = 0)
y
```

    ## [1]            --- *priceless* gift of such a  heart as yours, of such a ---                   
    ## [2]                --- go a smearing your wet  face  against the *expensive* mourning that --- 
    ## [3]    --- other *costly* ingredients, of the brains of pheasants _b_ _b_ _b_ ---              
    ## [4]              --- *mark* *upon* him at his  birth. I have sat with him ---                  
    ## [5] --- description, ornamented with angels '  heads from the most *expensive* dies. ---       
    ## [6]         --- of *valuable* books under his   arm , and a five-pound note in ---             
    ## [7]    --- breathless interest). Has a wooden   leg ; finds a wooden leg *expensive*, ---      
    ## [8]            --- wooden leg; finds a wooden   leg  *expensive*, going over the stones; ---

``` r
# S7.4+ ["Permission" +]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("S7.4+"), context = 0)
y
```

    ## [  1]           --- Durden puts on her *approving*    face  , and it 's done _b_ ---                     
    ## [  2]           --- _b_ Dame Durden 's *approving*    face   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [  3]                     --- _b_ _b_ Liz, you 're   tired   and ill. *Let* me take ---                  
    ## [  4]            --- graciously *let* me kiss your    hand   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [  5]                    --- *Let* me look at your  forehead _b_ _b_ _b_ _b_ _b_ ---                     
    ## [  6]                  --- you ? *Let* me see your    face   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [  7]                    --- _b_ *Let* me see your    face  , I say _b_ _b_ _b_ ---                      
    ## [  8]                     --- -- *let* me see your    face   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [  9]                    --- _b_ _b_ and *let* the   hands   of no honest man touch ---                  
    ## [ 10]                --- *Let* them keep their red   noses   for bottles and tankards. These ---         
    ## [ 11]                  --- and our faith. *Let* ME   sleep   on a chair -- the ---                       
    ## [ 12]                --- be trodden down by Papist    feet  . *Let* the horses be saddled ---            
    ## [ 13]                   --- on me. Oh ! *let* your   heart   be softened by your own ---                 
    ## [ 14]                     --- a faint blush in her    face  , 'you would have *let* me ---               
    ## [ 15]                   --- gape and hold up their   hands   ? *Let* them do it at ---                   
    ## [ 16]                      --- and *let* me lay my    head   upon you. Oh, I am ---                      
    ## [ 17]                   --- now, and he is welcome    back  . *Let* him not put her ---                  
    ## [ 18]                        --- me, if you have a   heart  , Miss Mills. *Let* me die ---               
    ## [ 19]                  --- know, do n't we ? *Let*  sleeping dogs lie - who wants to ---                 
    ## [ 20]                    --- On'y *let* her see my    face   - on'y *let* her beer my ---                
    ## [ 21]              --- goodness, try to *let* your   heart   soften to me, only for ---                  
    ## [ 22]                 --- now desire to extend the    hand   of fellowship, *let* it not ---             
    ## [ 23]                  --- indeed a burden on your   heart  , *let* me try to lighten ---                
    ## [ 24]              --- But *let* these dear rogues     go    to bed; and as no ---                       
    ## [ 25]               --- *let* these dear rogues go     to    bed; and as no house ---                    
    ## [ 26]                --- so trembly and shaky from    head   to foot, and to *allow* ---                 
    ## [ 27]                   --- and shaky from head to    foot  , and to *allow* my feelings ---             
    ## [ 28]                     --- with my hand, and go     to    sleep. Oh, pray, pray, *let* ---            
    ## [ 29]                       --- my hand, and go to   sleep  . Oh, pray, pray, *let* me ---               
    ## [ 30]          --- perfect *right* to replace poor   Fanny   if he chooses; I can ---                    
    ## [ 31]                  --- graced by Mrs Dombey 's    hand  , and *permitted* to hold so ---             
    ## [ 32]                    --- fear I must. *Let* my    arm    go _b_ _b_ _b_ _b_ ---                      
    ## [ 33]           --- patientest and truest of noble   hearts , but *let* me talk to ---                   
    ## [ 34]                 --- every *right* to bend my    head   before what you confide to ---              
    ## [ 35]            --- my friend Dombey suffers from   bodily  weakness, and would *allow* me ---          
    ## [ 36]                --- once more, on my desolate   heart  , *let* me lay this dear ---                 
    ## [ 37]                   --- *let* me lay this dear    head  , for the last time _b_ ---                  
    ## [ 38]                    --- spoke of my sister 's   tears  . My sister would have *let* ---             
    ## [ 39]                     --- _b_ _b_ and *let* my    eyes   be rid of the sight ---                     
    ## [ 40]                 --- a weight strapped to his    back   besides. *Let* him alone. I ---             
    ## [ 41]               --- whipped you under his left    arm   , and with his *right* he ---                
    ## [ 42]             --- there ? *Let* him turn those    eyes   of his on me. I ---                         
    ## [ 43]                         --- I 'll show you a   wrist  . Molly, *let* them see your ---             
    ## [ 44]               --- Molly, *let* them see your   wrist   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 45]               --- Molly, *let* them see your   wrist   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 46]                 --- *let* them see both your   wrists . Show them. Come _b_ _b_ ---                
    ## [ 47]                   --- once *let* you kiss my   cheek   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 48]                     --- her throw it over my shoulders. Do n't *let* her lift ---                  
    ## [ 49]                        --- such to it, on my shoulders - and, *let* people suppose what ---        
    ## [ 50]                     --- may be, I will never    tire   of trying. Will you *let* ---               
    ## [ 51]                    --- and *let* me lay this    head   of mine upon a loving ---                   
    ## [ 52]                    --- a long rest. *Let* me   sleep   in the morning _b_ _b_ ---                  
    ## [ 53]                 --- -- and *let* my thankful   tears   fall on it; for I ---                       
    ## [ 54]                   --- Father, dear, I am not   tired  ; *let* me come back presently, ---          
    ## [ 55]                    --- you *let* her put her    foot   upon your family, and thank ---             
    ## [ 56]                     --- you cry to ease your    head  , Little Mother, *let* me cry ---            
    ## [ 57]                   --- to be down in Bleeding   Heart   Yard by *rights*; but I ---                 
    ## [ 58]                   --- matter I place in your   hands  . I *authorize* you now to ---               
    ## [ 59]                   --- care of this poor cold    hand  , Miss Dorrit. Do n't *let* ---              
    ## [ 60]                   --- only thing for a proud  stomach . *Let* him eat up every ---                 
    ## [ 61]               --- dear friend Jeremiah to my    arms   ! Open the door, and *let* ---              
    ## [ 62]                      --- _b_ _b_ But you are   tired  , sir. *Let* me make you ---                 
    ## [ 63]                     --- _b_ _b_ _b_ _b_ Dear   Fanny  , *let* me say first, that ---               
    ## [ 64]                  --- *Permit* me to ask you,   Fanny   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 65]                 --- *Allow* me, sir. Take my    arm    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 66]                     --- says it is) to *let*  sleeping dogs lie, it 's just ---                    
    ## [ 67]              --- doctor. *Let* me touch your   pulse   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 68]                   --- There, *let* me try to   sleep  . Leave the candle where it ---              
    ## [ 69]           --- have some *right*, having been    born   a member of this family, ---                
    ## [ 70]                --- than you are never drawed   breath  -- *let* me see the ---                     
    ## [ 71]               --- Come ! *Let* us make haste    back   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 72]                     --- *Let* us hope it may   awake   a moral sense within him ---                
    ## [ 73]                   --- _b_ Will you hold your   tongue , sir, and *let* me speak ---                
    ## [ 74]                      --- but *let* me put my    lips   to it when I am ---                         
    ## [ 75]                      --- and *let* me put my    lips   to it when I am ---                         
    ## [ 76]                  --- very soon come under my   hands  . *Allow* me to illustrate this. ---         
    ## [ 77]             --- Pip ? Human nature. What are    legs   ? Human nature. Then *let* us ---           
    ## [ 78]                  --- *let* us have plenty of    leg    pieces, Pip, and I 'll ---                  
    ## [ 79]                   --- in. *Let* me kiss your    hand   for all your goodness to ---                
    ## [ 80]                    --- to stand up with your    back   agin the wall *right* in ---                
    ## [ 81]                    --- If you could set your    back   *right* slap agin that curtain-peg, ---     
    ## [ 82]                     --- _b_ _b_ and *let* my    face   be ! As long as I ---                       
    ## [ 83]                --- to himself; and *let* her   sleep   as long as she likes. ---                   
    ## [ 84]                      --- and *let* me put my    lips   to it, when I am ---                        
    ## [ 85]                      --- and a zone for your   waist   ! Ah ! Beautiful ! *Let* us see ---         
    ## [ 86]                  --- about us; when our cold   hearts  cease to beat, *let* warm ---               
    ## [ 87]                --- cease to beat, *let* warm   hearts  be beating near; *let* our ---              
    ## [ 88]       --- penance and mortification on their   heads  , keep them down, and *let* ---              
    ## [ 89]                   --- _b_ *Let* me see ! Who   sleeps  in Brooks's 's bed, my ---                  
    ## [ 90]                 --- pony run *right* off his    legs  , and me obliged to come ---                 
    ## [ 91]                    --- But you must dry your    eyes   first, and compose yourself. *Let* ---      
    ## [ 92]            --- yourself. *Let* me raise your    head  . There -- there _b_ _b_ ---                 
    ## [ 93]                  --- and *let* him pull your    nose  , he 'd have got it ---                      
    ## [ 94]              --- G., and *let* the favourite    wake   'em _b_ _b_ _b_ _b_ ---                     
    ## [ 95]                    --- _b_ *let* me see your    face  . No ? Ah ! that was but ---                 
    ## [ 96]               --- with you, *let* loose some   blood  , and swear you came to ---                  
    ## [ 97]                --- it again. *Let* us wander  barefoot through the world, rather than ---          
    ## [ 98]                   --- and *let* me wring its    neck   will you ? He said I ---                    
    ## [ 99]                  --- back. If you *let* your    hand   tremble so, we can never ---                
    ## [100]               --- *permitted*, to fly in the    face   of your superiors in this ---               
    ## [101]                --- should *let* him have his   sleep   out _b_ _b_ _b_ _b_ ---                     
    ## [102]                       --- I count them on my  fingers  ? *Let* them rest though; they ---          
    ## [103]                    --- _b_ _b_ _b_ hold your   tongue  if you please, and *let* ---                
    ## [104]           --- strong reason, *let* pass your    lips   what I am going to ---                      
    ## [105]          --- purposely *let* father find the    body   ? It seemed a'most wicked and ---           
    ## [106]                  --- *Let* him never put his    head   inside that door. And *let* ---             
    ## [107]                 --- traces of emotion on our   cheeks , *let* him construe them as ---             
    ## [108]                    --- you wanted to pull my    nose  , and you have *let* me ---                  
    ## [109]                   --- say. *Let* me wet your    lips   again with this brandy. I ---               
    ## [110]                   --- say. *Let* me wet your    lips   again. I hurried all I ---                  
    ## [111]                    --- _b_ *Let* me wet your    lips   again. Am I to open ---                     
    ## [112]                   --- you. *Let* me wet your    lips   again, and your forehead. There. ---        
    ## [113]               --- fallen into Mr Fledgeby 's   hands  . *Let* me tell you that, ---                
    ## [114]                    --- he would n't have had   brains  enough to say it. *Let* ---                 
    ## [115]                  --- be *allowed* to wash my   hands  , only you find me out ---                   
    ## [116]               --- the light, John. Shut your    eyes  , sir, and *let* me take ---                 
    ## [117]                   --- we *let* 'em have live   bodies . If you had kept the ---                    
    ## [118]                  --- and save us ! Wash your   hands  , and *let* me part your ---                 
    ## [119]                   --- and *let* me part your    hair   nicely for you, child _b_ ---               
    ## [120]                 --- *Let* me whisper in your    ear    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [121]                 --- own words. From your own    lips  , *let* me hear it _b_ ---                   
    ## [122]                --- _b_ _b_ Carry your memory    back   -- *let* me see -- ---                      
    ## [123]                      --- _b_ Here; lend us a    hand  , and *let* me get off ---                   
    ## [124]           --- hospital nurse, set our rotten   hearts  on any man, and *let* ---                   
    ## [125]                   --- 'll *let* her a little   blood  , without troubling the doctor, if ---       
    ## [126]                  --- *Let* that pass. He was    born   in this town _b_ _b_ ---                    
    ## [127]              --- passing his hand across his  forehead; " Hutley -- Hutley -- *let* ---            
    ## [128]                    --- *let* him. He hid his    face   in his burning hands, and ---               
    ## [129]                     --- that boy, he 's gone     to    sleep again. -- Joe, *let* ---              
    ## [130]                       --- boy, he 's gone to   sleep   again. -- Joe, *let* down ---               
    ## [131]                    --- *Let* me lean on your    arm    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [132]                --- _b_ Mr. Winkle, take your   hands   off. Mr. Pickwick, *let* me ---             
    ## [133]                      --- *let* me get out of  hearing  of those prosy politics _b_ ---             
    ## [134]              --- the honour of grasping your    hand  . *Permit* me, Sir, to shake ---             
    ## [135]                 --- Sammy, to hear from your    lips  , as you *let* yourself be ---               
    ## [136]   --- awaken unpleasant recollections in her   breast , without her *consent* and *permission* --- 
    ## [137]                   --- *let* him show his red    nose   in the Markis o' Granby ---                 
    ## [138]                     --- wish you 'd *let* me   bleed   you _b_ _b_ _b_ _b_ ---                     
    ## [139] --- tickets ! Does our fiendish contemporary   wince   ? *Let* him writhe, in impotent ---         
    ## [140]                    --- n't *let* me see your    hand   go nigh 'em. For I ---                      
    ## [141]                  --- Do n't *let* your sober    face   elate you, however; you do ---              
    ## [142]                 --- they only know what your   breath  tells them. *Let* it deceive ---            
    ## [143]               --- street. *Let* me take your    arm   , Miss Pross. This is not ---                
    ## [144]                     --- to *let* me move his    hand   away. The wound was a ---                   
    ## [145]                     --- *Let* me but lift my   finger  _b_ _b_ _b_ _b_ _b_ ---                     
    ## [146]                   --- you *let* me hold your    hand   ? I am not afraid, but ---                  
    ## [147]                 --- *let* me hold your brave    hand  , stranger _b_ _b_ _b_ _b_ ---

### Concordances of “semantic tag collocates”: Non-quotes

``` r
# N3.4- ["Measurement: Volume" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.4-"), context = 0)
y
```

    ## [ 1]            --- a general impression that his   skull   was *compressible* by those means. ---     
    ## [ 2]     --- too violently *compressed* about the   waist  , and with a sharp nose ---                 
    ## [ 3]            --- by an additional tightness of    face  , thin elongation of *compressed* lips, --- 
    ## [ 4]    --- face, thin elongation of *compressed*    lips  , and sidewise look, which intense ---      
    ## [ 5]                      --- a part of her lower    lip    is *compressed* under her teeth ---        
    ## [ 6]            --- lip is *compressed* under her   teeth   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 7]    --- inflexible resolution; his brows were  puckered, and his lips *compressed*, with ---       
    ## [ 8]             --- brows were puckered, and his    lips   *compressed*, with deep and settled ---    
    ## [ 9]              --- the crowd, you saw strained    eyes   and lips *compressed*; it would ---        
    ## [10]                --- you saw strained eyes and    lips   *compressed*; it would have been ---       
    ## [11]    --- thought *compressible* even into that    face  . The scar made by the ---                  
    ## [12]                      --- that shut up like a    bite  . *Compressing* her lips, in sympathy ---   
    ## [13]           --- like a bite. *Compressing* her    lips  , in sympathy with the snap, ---            
    ## [14]                   --- to me, than the mental endurance I saw *compressed* now within ---          
    ## [15]         --- *compressed* now within both his   hands   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [16]                   --- a figure of brass. Her    lips   were tightly *compressed*, as if ---       
    ## [17]        --- returned, sitting with her folded    arms  , and knitted brows, and *compressed* ---   
    ## [18]             --- her folded arms, and knitted   brows  , and *compressed* lips as if ---           
    ## [19]      --- and knitted brows, and *compressed*    lips   as if she were bent ---                    
    ## [20]              --- his elbows squared, and his   hands   on his knees, *compressing* the ---        
    ## [21]       --- with a *compressed* and determined   mouth   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [22] --- Mrs. Sparsit, suddenly *compressing* her   mouth   _b_ _b_ _b_ _b_ _b_ ---                    
    ## [23]                --- proud eyes, in the lifted  nostril , in the handsome but *compressed* ---      
    ## [24]          --- but *compressed* and even cruel   mouth  . Cover either two of those ---             
    ## [25]             --- fixed look of suspicion, and    lips   angrily *compressed* _b_ _b_ _b_ ---       
    ## [26]       --- which parted his thin *compressed*    lips  , and puckered up the bad ---               
    ## [27]          --- his thin *compressed* lips, and  puckered up the bad lines about ---                 
    ## [28]     --- thin *compressed* lips, and puckered     up    the bad lines about his ---                
    ## [29]     --- down unbidden, and *compressing* his    lips  , which were for the moment ---             
    ## [30]               --- and a *compression* of the   mouth  , that might have been a ---                
    ## [31]                --- this threat; and with her    lips   *compressed*, and her hands clenched, ---  
    ## [32]           --- her lips *compressed*, and her   hands   clenched, looked alternately at the ---    
    ## [33]          --- him with savage resolution: his   teeth   so tightly *compressed* that the ---       
    ## [34]   --- tightly *compressed* that the strained    jaw    seemed starting through his skin; ---      
    ## [35]            --- boy, who had been effectually   roused  by the *compression* of a ---              
    ## [36]                --- had failed to awaken. The    lips   which had been *compressed* in ---         
    ## [37]     --- wanting among them; nor *compressed*    lips  , white with what they suppressed; ---      
    ## [38]                       --- at the top of each  nostril . In those two *compressions*, or ---       
    ## [39]       --- and desperate *compression* of the    lips   in sleep, inspired the mender ---          
    ## [40]             --- *compression* of the lips in   sleep  , inspired the mender of roads ---

``` r
# H4- ["Residence" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("H4-"), context = 0)
y
```

    ## [ 1]              --- with a wild and *vacant*     eye    , and crooning some uncouth song ---       
    ## [ 2]        --- his *vacant* look and restless     eye    ; were all in keeping with ---             
    ## [ 3]   --- countenance, and pervading his very     legs   , presented but a *vacant* appearance, --- 
    ## [ 4]         --- pale in the looking-glass; my     eyes    had a *vacant* appearance; and ---        
    ## [ 5]         --- a *vacant* appearance; and my     hair    - only my hair, nothing else - ---        
    ## [ 6]                 --- up, until it left his     face    quite *vacant*, and the suit ---          
    ## [ 7]            --- it, and slowly shaking his     head    at the *vacant* chair, for ---            
    ## [ 8]      --- *vacant* air with her shrivelled     fist    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 9]       --- caught them in his *unoccupied*     hand   , and holding them, and still ---          
    ## [10]                   --- with a child in her     arms   , whose *unoccupied* hand was hastily ---  
    ## [11]       --- in her arms, whose *unoccupied*     hand    was hastily rearranging the upper ---     
    ## [12]       --- any *vacant* appointment on the     face    of this earth, so many ---                
    ## [13]                 --- with his elbow on the     back    of a *vacant* chair, and ---              
    ## [14]        --- gold watch in his *unoccupied*     hand   , and conversed with Mrs Gamp; ---         
    ## [15]          --- and *looked* as *vacant* and unconscious as ever mortal looked. Arthur ---         
    ## [16]         --- a *vacant* smile and admiring     face    to all that his new ---                   
    ## [17]         --- view he gave his *unoccupied*     hand    to Nell, and bidding her ---              
    ## [18]         --- strolled out with a noiseless     foot    and an *unoccupied* countenance. As ---   
    ## [19]          --- say -- with his *unoccupied*     hand   . He and Venus were necessarily ---        
    ## [20]               --- at once; and passed the     back    of his *unoccupied* hand briskly ---      
    ## [21]          --- the back of his *unoccupied*     hand    briskly across his eyes, he ---           
    ## [22]  --- *unoccupied* hand briskly across his     eyes   , he left a tear in ---                    
    ## [23] --- Sikes, seizing Oliver 's *unoccupied*     hand    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [24]        --- daughter, who had bestowed her     hand    upon a *non-resident* waiter, who ---

``` r
# A1.3- ["Caution" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("A1.3-"), context = 0)
y
```

    ## [ 1]                      --- even in his dress (his   hair   *carelessly* disposed, and his neckkerchief ---    
    ## [ 2]  --- returned Richard, *carelessly* tossing his   hair   from his forehead _b_ _b_ ---                      
    ## [ 3]                 --- to task, with that laughing   face   and *heedless* manner and with ---                 
    ## [ 4]         --- lashes which concealed his downcast   eyes  , but an air of *careless* ---                      
    ## [ 5]               --- uncombed locks, he had fallen  asleep  in a posture as *careless* ---                     
    ## [ 6]                --- his chin nearly touching his   knees ; and *heedless* of the dangling ---                
    ## [ 7]             --- the *incautious* fulness of his   heart  'pulling-up' at all manner of ---                  
    ## [ 8]                  --- a *careless* motion of his   hand   towards his hat _b_ _b_ ---                        
    ## [ 9]                    --- his face flushed and his   eyes   sparkling with delight, *heedless* of ---          
    ## [10]        --- the roofs blistered the *incautious*   hand   that touched them, and the ---                     
    ## [11]                  --- I had *impetuously* set my   heart  on, had no right to ---                            
    ## [12]                    --- for its sign The Railway   Arms  ; but that might be *rash* ---                      
    ## [13]              --- The limp and *careless* little   hand   that Mr Dombey took in ---                         
    ## [14]               --- soon fall *unheeded* from her   hands  again. _b_ _b_ _b_ _b_ ---                         
    ## [15]                --- smote upon the *prodigal* 's  breast  so sharply when he saw ---                         
    ## [16]              --- away with nothing expressed in   face   or figure but *careless* beauty ---                
    ## [17]  --- head-gear, fluttering round her *reckless*   face   _b_ _b_ _b_ _b_ _b_ ---                            
    ## [18]                 --- and strained her rich black   hair   with *heedless* cruelty, and brought ---           
    ## [19]              --- *impulsively* put out both her   hands  and said _b_ _b_ _b_ ---                           
    ## [20]              --- might fall upon the *heedless*   head  , and light heart, then; remained ---               
    ## [21]              --- the *heedless* head, and light   heart , then; remained to be seen. ---                    
    ## [22]                  --- The visitor, more with his   eyes   than by the slight *impulsive* ---                 
    ## [23]            --- slight *impulsive* motion of his   hand  , entreated her to be reassured ---                 
    ## [24]                    --- high opinion of her; but   Fanny , *impetuous* at most times, might ---              
    ## [25]             --- _b_ _b_ returned the *careless*   Fanny  _b_ _b_ _b_ _b_ _b_ ---                            
    ## [26]                    --- a *careless* wave of his   hand   _b_ _b_ _b_ _b_ _b_ ---                            
    ## [27]                   --- a *careless* wave of both   hands , as if the subject were ---                        
    ## [28]                  --- said Martin. He tossed his   head   in a *careless* manner afterwards, ---             
    ## [29]                         --- _b_ _b_ _b_ _b_ His   arms   rested *carelessly* on his knees ---               
    ## [30]         --- needle-work stood *unheeded* at her   elbow ; her supper, spread on a ---                       
    ## [31]                      --- trying to throw up her eyebrows *carelessly*, and pout her rosy ---                
    ## [32]           --- up her eyebrows *carelessly*, and   pout   her rosy lips, as if ---                           
    ## [33]             --- *carelessly*, and pout her rosy   lips  , as if she were the ---                            
    ## [34]               --- so *rash*, and laying violent   hands  upon a quantity of stone ---                       
    ## [35]               --- heard the tread of *slipshod*   feet  , and the chilly cry of ---                         
    ## [36]                    --- his clenched hand as the   faces  of the two *profligates* rose ---                  
    ## [37]                  --- _b_ _b_ Nicholas waved his   hand   *carelessly*, and concealing the indisposition --- 
    ## [38]                  --- couch side, and waving his   hand   in assumed *carelessness* _b_ _b_ ---              
    ## [39]       --- Ralph, *carelessly*, and averting his   face   _b_ _b_ _b_ _b_ _b_ ---                            
    ## [40]                       --- in his chair with his    arm   thrown *carelessly* over the back, ---             
    ## [41]            --- arm thrown *carelessly* over the   back  , and now and then lifted ---                       
    ## [42]                     --- Here, then, he sat, one    leg   cocked *carelessly* over the other, ---            
    ## [43]            --- *carelessly* over the other, his   chin   resting on the palm of ---                         
    ## [44] --- scolding mothers, stamping their *slipshod*   feet   with noisy threats upon the ---                    
    ## [45]                  --- had been standing with his   hands  in his pockets looking *carelessly* ---            
    ## [46]              --- *impetuous* answer rose to his   lips   _b_ _b_ _b_ _b_ _b_ ---                            
    ## [47]           --- had released) *carelessly* by the    arm  , a little above the elbow ---                      
    ## [48]                  --- himself down with his left    arm   *carelessly* thrown across his left ---            
    ## [49]         --- *carelessly* thrown across his left    leg   a little above the knee, ---                       
    ## [50]                     --- the knee, and the right    arm   as *carelessly* thrown over the ---                
    ## [51]             --- as *carelessly* thrown over the   elbow  of the wooden chair, with ---                      
    ## [52]                     --- up their station in his  breast , too, for he was *blithe* ---                      
    ## [53]                --- smoking a pipe, swinging one    leg   *carelessly* to and fro, and ---                   
    ## [54]                    --- _b_ A pair of *slipshod*   feet   shuffled, hastily, across the bare ---             
    ## [55]          --- of *careless* levity, withdrew her   eyes  ; but as he turned towards ---                      
    ## [56]                  --- the ground, she tossed her   head   with affected *carelessness* as she ---            
    ## [57]                       --- a few inches from his   head  , and *carelessly* replacing it very ---            
    ## [58]         --- throwing the ball *carelessly* from   hand   to hand; and several other ---                     
    ## [59]               --- *remissness* had left him. He   awoke  to this, and he awoke ---                          
    ## [60]           --- and looking *carelessly* over his shoulder to Mr. Pickwick _b_ _b_ ---                        
    ## [61]                    --- a *careless* wave of his   hand  , as if he waved that ---                           
    ## [62]        --- streaming white hair, his remarkable   face  , and the *impetuous* confidence of ---

``` r
# I3.2 ["Work and employment: Professionalism"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("I3.2"), context = 0)
y
```

    ## [ 1]         --- at the *writing-table*, who sat     biting    the feather of her pen ---               
    ## [ 2]                    --- with the game in his      hand    , but with a high *reputation* ---        
    ## [ 3]      --- experienced a slight difficulty in  respiration  (such as a *carpenter* meets ---         
    ## [ 4]     --- and his *secretary*, with slippered      feet    , and legs stretched out before ---       
    ## [ 5]   --- *secretary*, with slippered feet, and      legs     stretched out before the fire, ---       
    ## [ 6]        --- here the *secretary* clasped his     hands     _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 7]      --- the humble *secretary*, laying his      hand     upon his heart _b_ _b_ ---               
    ## [ 8]          --- left the *secretary* alone, to      yawn     and shake himself, and finally ---       
    ## [ 9]         --- _b_ The *secretary* drooped his      head     with an expression of perfect ---        
    ## [10]     --- the *secretary*, with meekly folded     hands     _b_ _b_ _b_ _b_ _b_ ---                  
    ## [11]             --- _b_ The *secretary* put his      hand     before his eyes to shade ---             
    ## [12]       --- elbow, and made divers remarkable     faces     -- the *secretary* gave them ---         
    ## [13]          --- _b_ The *secretary* rubbed his     hands     and bowed, as though he ---              
    ## [14]                --- laying his hand upon the    shoulder   of his cringing *secretary*, and ---     
    ## [15]       --- said the *secretary*, warming his     hands     again _b_ _b_ _b_ _b_ ---                
    ## [16]              --- _b_ _b_ The *secretary* 's      face    , as Dennis roared with laughter, ---     
    ## [17]        --- whispering in his *secretary* 's      ear      _b_ _b_ _b_ _b_ _b_ ---                  
    ## [18]     --- George, pressing his *secretary* 's      arm      tight within his own, and ---            
    ## [19]       --- said the *secretary*, turning his      face     homewards _b_ _b_ _b_ _b_ ---            
    ## [20]               --- his head, and keeping his      eyes     upon the *secretary* 's face ---         
    ## [21]            --- eyes upon the *secretary* 's      face     _b_ _b_ _b_ _b_ _b_ ---                  
    ## [22]    --- replied the *secretary*, nursing his      leg      _b_ _b_ _b_ _b_ _b_ ---                  
    ## [23]         --- There still remained the fourth      body    , and for that the *secretary* ---        
    ## [24] --- *reputation*, immediately fell upon her     knees     and began to scream very ---             
    ## [25]                --- do ? Whether he had been      born     a *carpenter*, or a coach-painter, ---   
    ## [26]           --- now sat, watching the strange     faces     of *accountants* and others, who ---     
    ## [27]             --- to sit watching the strange     faces     of the *accountants* and others, ---     
    ## [28]      --- with various small attentions, the      head     *accountant*: from whom Mr Perch ---     
    ## [29]               --- off it, to propitiate the      head     *accountant*, who was to get ---         
    ## [30]             --- *bellman* as they set their      feet     upon the stones of the ---               
    ## [31]                   --- had shown no trace of consciousness. The *carpenters* had a joke ---         
    ## [32]       --- cried the *secretary*, laying his      hand    , with growing familiarity, upon the ---  
    ## [33]                  --- was ! When he laid his      hand     upon the *mason* 's shoulder, ---        
    ## [34]                --- hand upon the *mason* 's    shoulder  , giving him directions, how pleasant --- 
    ## [35]              --- _b_ _b_ The *Secretary* 's      eyes     glanced with so much meaning ---         
    ## [36]                --- As on the *Secretary* 's      face     there was a nameless cloud, ---          
    ## [37]        --- the *Secretary* drove Mrs Boffin      back     to the Bower, and found ---              
    ## [38]               --- beggars; and how does the     heart     of the *Secretary* fail him ---          
    ## [39]                      --- that he has such a     heart     as never was. The *Secretary* ---        
    ## [40]         --- observant of the *Secretary* 's      face     and again addressing him _b_ ---         
    ## [41]          --- the *Secretary*, with a gloomy      brow    . _b_ _b_ _b_ _b_ _b_ ---                 
    ## [42]                 --- old face and the bright      eyes    , the *Secretary* repeated _b_ _b_ ---    
    ## [43]         --- Boffin made, the *Secretary* 's      face     changed no more than a ---               
    ## [44]         --- the *Secretary*, with a beaming      face     _b_ _b_ _b_ _b_ _b_ ---                  
    ## [45]                     --- paper he had in his      hand    , towards his late *Secretary* _b_ ---    
    ## [46]           --- the late *Secretary* in every     dimple    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [47]                    --- his hand to his bare      head    , and stared at the *Secretary*. ---      
    ## [48]          --- _b_ _b_ The *secretary* having    sneezed    in a very impressive manner, ---

``` r
# N3.1 ["Measurement: General"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.1"), context = 0)
y
```

    ## [ 1]        --- with *measured* tread and folded      arms    , as if it were a ---                         
    ## [ 2]               --- and *measure* it with his      hand    , until he hastily draws his ---              
    ## [ 3]          --- sunburnt cheek and bright dark      eye     , rapidly *measures* his height and ---       
    ## [ 4]             --- now *measured* him with his      eye      _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 5]            --- Hugh *measured* him with his      eye     , he *measured* Hugh, regarding him ---       
    ## [ 6]              --- *measure* of liquor in his      hand    , and filled their glasses as ---             
    ## [ 7]                     --- in the Judge 's own      hand    , of *inestimable* value, -- being ---        
    ## [ 8]               --- When I *measured* Dora 's     finger    for a ring that was ---                      
    ## [ 9]              --- a yard *measure* under his      arm     . A dressmaker, always stabbed in ---         
    ## [10]        --- *measure* by his lively youthful      face     and manner, ran eagerly up ---               
    ## [11]          --- then, *measuring* him with her      eyes     from head to foot, said ---                  
    ## [12]                     --- he still had in his      hand    , he had been *measuring*, a ---              
    ## [13]               --- and cowslip wine had been    quaffed    from the small squat *measuring* ---         
    ## [14]            --- them, and they *measured* my      head    , some on 'em - they had ---                  
    ## [15]                      --- him as if his grey      eye      were *measuring* it _b_ _b_ ---              
    ## [16]                 --- good company of about a      foot     in width, standard *measure*, Mrs ---        
    ## [17]                --- _b_ _b_ _b_ _b_ repeated     Fanny    , with *immeasurable* scorn _b_ _b_ ---       
    ## [18]                   --- by a bad passion from    quaffing   his full *measure* of evil, ---              
    ## [19]      --- settling the *measurements* of the      body     of a dress for her ---                       
    ## [20]             --- the barge, and waving their     hands     to her in solemn *measure*; ---              
    ## [21]            --- Winkle 's *measure* with his      eye     , and that feature glistened with ---         
    ## [22]                  --- buried his head in his     hands    , and ruminated; while Wardle *measured* ---  
    ## [23] --- travelling-shawl, which merged into his      chin     by such imperceptible *gradations*, that --- 
    ## [24]            --- confidence in himself, and a consciousness of *immeasurable* superiority over all ---   
    ## [25]                --- he still retained on his      head    , was a hatband *measuring* about ---         
    ## [26]       --- barred windows had descried other     faces     within, bending over *measures* of ---       
    ## [27]                       --- to and fro in his      cell    , counting its *measurement*, and the ---     
    ## [28]      --- *measured* Madame Defarge with her      eyes    , every inch _b_ _b_ _b_ ---

``` r
# X5.1+ ["Attention" +]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("X5.1+"), context = 0)
y
```

    ## [  1]                      --- standing near us with his    hands    behind him and an *attentive* ---                 
    ## [  2]                  --- an *attentive* smile upon his     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [  3]              --- see, standing with an *attentive*     face    between himself and the lawyer ---                
    ## [  4]              --- stands there with his *attentive*     face   , and his hat and stick ---                        
    ## [  5] --- *attention*, occasionally slightly bending her     head    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [  6]             --- five thousand pairs of fashionable     eyes    upon her, in distrustful *vigilance*, ---         
    ## [  7]          --- distrustful *vigilance*, than the two     eyes    of this rusty lawyer with ---                     
    ## [  8]                   --- fixed his *attention* or his     eyes   , it was only for a ---                            
    ## [  9]                        --- it never rose above his    waist   . Caddy, while she was *observant* ---             
    ## [ 10]               --- claims on his *attention* before    going    to bed. But he happens ---                        
    ## [ 11]                --- on his *attention* before going      to     bed. But he happens not ---                       
    ## [ 12]                --- and turned his kind *attentive*     face    towards me. I could not ---                       
    ## [ 13]              --- watching him with his *attentive*     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 14]                --- interest and *attention* on his     face   , and glancing significantly at the ---            
    ## [ 15]                 --- but sits with most *attentive*     eyes    until the sacked depository of ---                
    ## [ 16]                         --- puts her letter in his    hands    and looks *intently* in his ---                   
    ## [ 17]                    --- and looks *intently* in his     face    while he reads it. A ---                          
    ## [ 18]                        --- Mr. Bucket has read his     face    with the greatest *attention* all ---             
    ## [ 19]         --- the bed-linen, elaborate locomotion on    tiptoe  , *vigilant* peeping at her kinsman ---            
    ## [ 20]                        --- his arms folded and his     head    a little bent, respectfully *attentive* ---       
    ## [ 21]                 --- as suspicious and watching his     face    with the closest *attention* _b_ ---              
    ## [ 22]       --- elder, *concentrating* his strong steady     brow    upon him and smiling confidently ---              
    ## [ 23]               --- indeed, does she *captivate* all    hearts   by her condescension, by her ---                  
    ## [ 24]                         --- the whole power of his     eyes    into one *focus*, and brought ---                 
    ## [ 25]              --- the *attentive* expression of the     face    he turned towards them -- ---                     
    ## [ 26]         --- scrutinising it *attentively*, while a  breathless silence reigned around; for he ---                
    ## [ 27]                       --- bent eagerly down on one     knee   , and gazed *intently* at the ---                  
    ## [ 28]                        --- he had eyed his smiling     face    from time to time *intently* ---                  
    ## [ 29]             --- him *intently* with his glistening     eye     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 30]                       --- out, and perching on his   shoulder  and *addressing* *himself* to Mr ---              
    ## [ 31]              --- sat listening with an *attentive*     face   , until long after the sound ---                   
    ## [ 32]                   --- listened to these words with  breathless *attention*, started that moment to ---           
    ## [ 33]                         --- _b_ _b_ _b_ With eager     eyes    and strained *attention*, Mr Haredale ---         
    ## [ 34]             --- to him *attentively*, began again,    crying   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 35]              --- with the deepest *attention*, her    breath   held, her blue eyes sparkling ---                 
    ## [ 36]             --- Dick, with an *attentive*, puzzled     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 37]            --- grave and *attentive* expression of     face   . _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 38]                     --- had a long, lank, skeleton     hand   , which particularly attracted my *attention*, --- 
    ## [ 39]                       --- would sit, with his grey     head    bent forward, *attentively* listening to ---      
    ## [ 40]                          --- I might have tried to    rouse    a sleeper, before he *heeded* ---                 
    ## [ 41]               --- bright change in her *attentive*     face   , and the object of that ---                       
    ## [ 42]         --- replied Traddles, on whose *attentive*     face    a thoughtful shade had stolen ---                 
    ## [ 43]                  --- great *attention*, and with a     face    that often changed, but had ---                   
    ## [ 44]                         --- I could see her curled     lip    , and her cruel eyes *intently* ---                
    ## [ 45]                      --- curled lip, and her cruel     eyes    *intently* fixed on one place, ---                
    ## [ 46]                    --- faint and trembling, on her     arm    . She *heeded* no more what ---                    
    ## [ 47]         --- Micawber *attentively*, with his whole     face    breathing short and quick in ---                  
    ## [ 48]             --- *attentively*, with his whole face  breathing  short and quick in every ---                      
    ## [ 49]                      --- I looked at her beautiful     face   , *observant* of her work, she ---                 
    ## [ 50]                  --- journeys to Banbury Cross and     back   , *took* sharp *note* of the ---                   
    ## [ 51]               --- and looking *attentively* in her     face   , rejoined _b_ _b_ _b_ _b_ ---                     
    ## [ 52]           --- Beneath the watching and *attentive*     eyes    of Time -- so far ---                             
    ## [ 53]               --- the parlour wall, neither moving     hand    nor foot, suffered so *acutely* ---               
    ## [ 54]                  --- wall, neither moving hand nor     foot   , suffered so *acutely* in his ---                 
    ## [ 55]               --- at the *attentive* Florence, and   frowning  unconsciously as she encouraged him ---           
    ## [ 56]                           --- to hang on Walter 's     lips   , as he regarded him *attentively* ---             
    ## [ 57]                      --- and gently shaking him to    rouse    his *attention*. And when he ---                  
    ## [ 58]              --- attracted his *attention* and his    teeth   , once more _b_ _b_ _b_ ---                        
    ## [ 59]                       --- of his emotions; and his     eyes    *intently* fixed on Mr Carker, ---                
    ## [ 60]              --- he suddenly encountered the round     eyes    of the sleek-headed Rob *intently* ---            
    ## [ 61]                  --- Rob *intently* fixed upon his     face    as if they had never ---                          
    ## [ 62]              --- into the *attentive* and watchful     face    of the boy, he said ---                           
    ## [ 63]           --- with Cleopatra, whose *vigilance* of     eye     in respect of Mr Dombey ---                       
    ## [ 64]                 --- stopped clipping; and with her     head    among the plants, listened *attentively*. ---     
    ## [ 65]                    --- on the counter, whose large     eyes    had been *intently* fixed on ---                  
    ## [ 66]               --- smouldering embers, to raise her     head    with an awakened *attention* to ---               
    ## [ 67]                    --- at the *attentive* and stem     face    opposed to her _b_ _b_ ---                        
    ## [ 68]                    --- of which Edith, holding her     hand   , listened with close *attention*, and ---         
    ## [ 69]                       --- the young thing with the  shoulders , deprived of the *attentions* of ---              
    ## [ 70]                       --- Toots looked up into his     face   , with much *attention* and some ---               
    ## [ 71]               --- cat-like and *vigilant*, but the     eye     of his great chief passed ---                     
    ## [ 72]                 --- crumbled and dropped away. Her     eyes    were *intently* bent upon the ---                 
    ## [ 73]                        --- _b_ _b_ _b_ Turning her     eyes    again on the *attentive* gentleman ---            
    ## [ 74]              --- *attention*, and trotted along on     foot   , by his master 's side, ---                       
    ## [ 75]                    --- so subtle and *vigilant* of     eye    , that Rob quaked before him, ---                  
    ## [ 76]                   --- place and attitude, with his     eyes    *intently* fixed upon the ground, ---             
    ## [ 77]                   --- _b_ _b_ _b_ This *observant*     body    had plenty to say of ---                          
    ## [ 78]             --- Captain, looking *intently* in her     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 79]                 --- Florence followed him with her     eyes   , and looked *intently* in his ---                 
    ## [ 80]                   --- and looked *intently* in his     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 81]                           --- the old woman in his     ear    , and *taking* *note* of every ---                 
    ## [ 82]                --- divers clicking sounds with his    tongue   and teeth, to attract *attention* ---             
    ## [ 83]                     --- sounds with his tongue and    teeth   , to attract *attention* _b_ _b_ ---               
    ## [ 84]           --- with various small *attentions*, the     head    accountant: from whom Mr Perch ---                
    ## [ 85]           --- appear beautiful, in the *observant*     eyes    that watched her _b_ _b_ ---                      
    ## [ 86]                       --- shading it with her lean     hand   , *concentrates* its red spark of ---              
    ## [ 87]          --- incoherent jargon with an *attentive*    frown   , he turns to the Lascar ---                       
    ## [ 88]                   --- of musing benevolence on his     face   , has *attentively* watched every animated ---     
    ## [ 89]                    --- wrong, that he followed her     lips    most *attentively*, with his eyes ---             
    ## [ 90]              --- lips most *attentively*, with his     eyes    as well as hands; carefully ---                   
    ## [ 91]                 --- wooden way, he had *observant*     eyes    for Edwin; and when at ---                        
    ## [ 92]                --- night again, so that *vigilant*     eyes    should be kept on every ---                       
    ## [ 93]                         --- with his hat under his     arm    , as he *addressed* *himself* equally ---          
    ## [ 94]                  --- his *attention* on a handsome     face   , much sunburnt; and the ghost ---                 
    ## [ 95]              --- with the closest *attention*. All unconscious of her presence, he chants ---                    
    ## [ 96]                 --- stood before her, avoiding her     eyes   , that I *took* *note* of ---                      
    ## [ 97]       --- had curiously thoughtful and *attentive*     eyes   ; eyes that were very pretty ---                   
    ## [ 98]     --- curiously thoughtful and *attentive* eyes;     eyes    that were very pretty and ---                     
    ## [ 99]                        --- the kitchen fire with a     hand    on each knee, gazing *intently* ---               
    ## [100]                            --- with a hand on each     knee   , gazing *intently* at the burning ---             
    ## [101]                  --- to claim his *attention*. His    mouth    was such a postoffice of ---                      
    ## [102]                          --- would start out of my     head   . I acknowledged his *attention* incoherently, --- 
    ## [103]                         --- the room, she kept her     eyes    *attentively* on my guardian, and ---             
    ## [104]                          --- a low voice, with her     eyes    *attentively* and entreatingly fixed upon ---     
    ## [105]                --- *attention*, and a quickness of     eye     and hand, very like that ---                      
    ## [106]                 --- *attention*, and were going to    sneeze   _b_ _b_ _b_ _b_ _b_ ---                           
    ## [107]                   --- with his large brown veinous    hands   . I looked at him *attentively* ---                
    ## [108]               --- stood, keenly *observant* of me,    biting   a long end of it ---                              
    ## [109]                            --- with the end at his    mouth    and still *observant* of me ---                   
    ## [110]           --- knitting action, and the *attentive*     eyes   . And I felt absolutely certain ---                
    ## [111]              --- the usual performance, folded his     arms   , and looked with stern *attention* ---            
    ## [112]               --- her *attentively* with his fixed     eye    , surveyed his company with his ---                
    ## [113]            --- mixed expression of his *attentive*     face   . Mrs. Sparsit uttered a gentle ---                
    ## [114]         --- Stephen Blackpool bent his *attentive*     face    - his face, which, like the ---                   
    ## [115]                --- bent his *attentive* face - his     face   , which, like the faces of ---                     
    ## [116]                         --- a slight motion of her     hand   , and *concentrating* her *attention* upon ---     
    ## [117]                   --- and the crowd of *attentive*    faces    turned towards him, was extremely ---             
    ## [118]                       --- and his bundle under his     arm    , Stephen took his *attentive* face ---            
    ## [119]              --- arm, Stephen took his *attentive*     face    along the high road. And ---                      
    ## [120]                  --- mind seemed heavy enough, his     body    was on the *alert*; and ---                       
    ## [121]                            --- to see the other 's     face   ; but each seemed very *attentive*, ---            
    ## [122]           --- same time *attentively* watching the     lips    as they moved, that she ---                       
    ## [123]                      --- and inserting salt in her    mouth   . When these *attentions* had recovered ---        
    ## [124]                      --- while three or four rough    faces    stood crowded close together, *attentively* ---   
    ## [125]                    --- who had a proud *observant*     face   , and had either withdrawn herself ---             
    ## [126]                          --- on the wall, with the     eyes    *intently* looking at his son ---                 
    ## [127]        --- *attentive* listening expression in her     face   , which is seen in the ---                         
    ## [128]                  --- his *attention*, and the grey   eyebrows  turned towards him _b_ _b_ ---                    
    ## [129]                     --- thorns of confusion in the   breasts   of the more *observant* students ---              
    ## [130]            --- thoughts were *preoccupied*, as his     face    showed, and he *took* no ---                      
    ## [131]              --- this *attention* with a momentary    waking   up of manner that had ---                         
    ## [132]            --- *attention* with a momentary waking      up     of manner that had the ---                        
    ## [133]                       --- _b_ She passed her white    hands    over one another, *observant* of ---              
    ## [134]              --- earnest, Clennam again turned his     eyes    *attentively* upon his face. It ---               
    ## [135]                --- his eyes *attentively* upon his     face   . It was as scrubby and ---                        
    ## [136]                    --- Miss Wade with her composed     face    *attentively* regarding her, and suggesting ---   
    ## [137]         --- *attentive* smile, and that repressing     hand    upon her own bosom with ---                       
    ## [138]                        --- her chin resting on her     hand   , followed him with *attentive* and ---            
    ## [139]        --- with *attentive* and darkly distrustful     eyes   ; and Affery stood looking at ---                  
    ## [140]                   --- drooping more heavily on her     hand   , and her eyes *vigilant* and ---                  
    ## [141]                           --- on her hand, and her     eyes    *vigilant* and lowering, the sick ---             
    ## [142]                --- this fitful illumination of his    visage  , looked *intently* and wonderingly at ---         
    ## [143]         --- been strictly *attentive*, keeping his     eyes    fastened on the lady, and ---                     
    ## [144]                         --- and the dignity of the    blood    of the Barnacles, by *diligently* ---             
    ## [145]                        --- with her hands upon his   shoulder , and looked *attentively* in her ---              
    ## [146]                --- and looked *attentively* in her     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [147]    --- at the *attentive*, uncomplainingly shocked     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [148]        --- *vigilant* Blandois stopped, turned his     head   , and looked at them from ---                      
    ## [149]                --- castle of it. His *preoccupied*     face    so clearly denoted the pursuit ---                
    ## [150]                  --- with a steady and *attentive*     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [151]             --- engage their *attentions*, when my    heart    was burning against these ignorant ---            
    ## [152]                      --- hour that passed over his     head    made him more *acutely* sensible. ---             
    ## [153]                --- all. Mrs Clennam 's *attentive*    frown    expanded by degrees into a ---                    
    ## [154]                    --- flatten it between both his    hands   , and to eye Clennam *attentively* ---             
    ## [155]                         --- both his hands, and to     eye     Clennam *attentively* _b_ _b_ _b_ ---             
    ## [156]                 --- him always the one *attentive*    frown   , and the dark revelation before ---               
    ## [157]                     --- touched with his hand. Her     face    was ever frowning, *attentive*, and ---           
    ## [158]                        --- hand. Her face was ever   frowning , *attentive*, and settled _b_ _b_ ---             
    ## [159]        --- fixedly *attentive* in the window-seat,    biting   the rolled up end of ---                          
    ## [160]                 --- seen, the figure attracted all     eyes   . Saunterers pricked up their *attention* ---      
    ## [161]                  --- of *vigilance*, for his glass     eye     had fallen out, and he ---                        
    ## [162]                    --- her, who, with her downcast     eyes    *intently* fixed upon the fire, ---               
    ## [163]                       --- he wore, he searched her     face    *intently* _b_ _b_ _b_ _b_ ---                    
    ## [164]               --- *attentively* in Mr Pecksniff 's     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [165]                  --- at it *intently*; shaking his     head    the while, in a forlorn ---                       
    ## [166]                        --- held up Mr Pecksniff 's     head    without being *taken* *notice* *of* ---           
    ## [167]                            --- at the paper in his     hand   . For the eyes were *attentively* ---              
    ## [168]                           --- in his hand. For the     eyes    were *attentively* cast down upon ---             
    ## [169]             --- his *attention*; such as coughing,   sneezing , clattering the teacups, sharpening the ---       
    ## [170]               --- _b_ retorted Jonas, dangling his     legs    the more, and *taking* no ---                     
    ## [171]                      --- *herself* to John on this     head    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [172]                   --- fact that in the *attentive*     ears    of Mr Pecksniff, the proposition ---              
    ## [173]                       --- at the prospect with his    ankles  , who attracted their *attention* speedily. ---    
    ## [174]                             --- his hand on Tom 's    wrist   , to bespeak his *attention*, and ---              
    ## [175]                           --- this, he held up his     hand    to bespeak Martin 's *attention*. ---             
    ## [176]                   --- such a moment in *attentive*     ears   , might fire the train of ---                      
    ## [177]                   --- dull steadiness of Martin 's     face   , as he looked *attentively* at ---                
    ## [178]      --- Swillenhausen had pleaded a *preoccupied*    heart   , or fallen at her father ---                      
    ## [179]                   --- said the baron, stamping his     foot    to attract *attention*. _b_ _b_ ---               
    ## [180]                        --- some effect on the most  insensible person, and must be *acutely* ---                 
    ## [181]               --- other, looking *intently* in his     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [182]                 --- and some fear, stretched their    necks    forward, and listened *attentively* _b_ ---       
    ## [183]              --- Lillyvick regarded the group with   frowning  and *attentive* eyes, lying in ---                
    ## [184]            --- group with frowning and *attentive*     eyes   , lying in wait for something ---                  
    ## [185]       --- struck them motionless, with *attentive*     ear     and palpitating heart, until the ---              
    ## [186]           --- with *attentive* ear and palpitating    heart   , until the alarm had passed ---                   
    ## [187]                    --- the whole expression of the     face    was *concentrated* in a wrinkled ---              
    ## [188]                --- have been *concentrated* in one     body   , that one body could hardly ---                   
    ## [189]             --- between them, when his *attentive*     ear     caught the rustling of a ---                      
    ## [190]                 --- severe and dangerous, could be  insensible to the unremitting *attentions* of ---            
    ## [191]           --- both *intently* engaged, and wearing    faces    of exultation which contrasted strongly ---       
    ## [192]                         --- began to listen with a     face    of great craftiness and *attention*. ---          
    ## [193]                 --- which *attention* the old lady   frowned   them down instantly, and said ---                 
    ## [194]                 --- to attract her *attention* had    roused   her from her sad reflections ---                  
    ## [195]                        --- a large orange into his    mouth   , and gazing *intently* at the ---                 
    ## [196]                      --- hand to his great flapped     ear    , and counterfeited the closest *attention* ---    
    ## [197]                  --- subject, remained in the same    waking   slumber until his *attention* was ---             
    ## [198]                    --- remained in the same waking   slumber   until his *attention* was attracted ---           
    ## [199]                        --- Brass and Sally, arm in     arm    , claim our polite *attention*. _b_ ---            
    ## [200]              --- Mr Inspector, with an *attentive*     ear     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [201]                          --- and wrote in a rather  tremulous  hand -- Mr Inspector *taking* ---                 
    ## [202]                    --- wrote in a rather tremulous     hand    -- Mr Inspector *taking* sidelong ---             
    ## [203]              --- *taking* sidelong *note* of every     hair    of his head when it ---                           
    ## [204]                        --- listened to her, with a     face    of marked *attention*, though he ---              
    ## [205]             --- read her newspaper with contracted    brows   , and *took* no *notice* until ---                 
    ## [206]                           --- laid a hand upon his     lips    to keep him silently *attentive* ---              
    ## [207]                   --- *attention* in Mrs Lammle 's     face    as she said some words ---                        
    ## [208]                --- determinedly set askew, and his     eyes    watchfully dividing their *attention* between --- 
    ## [209]                       --- him of having closed his     eyes   , or wandered in his *attention* ---               
    ## [210]                  --- pouting, reclined in Betty 's     lap    , *concentrating* his blue eyes on ---             
    ## [211]               --- 's lap, *concentrating* his blue     eyes    on the visitors and shading ---                   
    ## [212]            --- leaning back, *attentive*, with her    elbows   resting on the elbows of ---                      
    ## [213]                --- one book; both with *attentive*    faces   ; Jenny with the sharper; Lizzie ---               
    ## [214]                  --- his *attention* by fixing his     head    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [215]                --- *observant* of the Secretary 's     face    and again addressing him _b_ ---                  
    ## [216]            --- stature and some *compactness*, and   breathed  in a low voice the ---                            
    ## [217]            --- attendant and *attentive*, held her     arm     up _b_ _b_ _b_ _b_ ---                            
    ## [218]                        --- _b_ said the stanch old    heart   , *observant* of Bella 's face: ---                
    ## [219]                 --- heart, *observant* of Bella 's     face   : when I take my seat ---                          
    ## [220]                   --- *observant* of the master 's     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [221]                    --- sought to discover from her     face    what *attention* she had given ---                
    ## [222]                   --- *taking* *heed* of these two    faces   , and what with feeling conscious ---              
    ## [223]                         --- at him with his wooden     leg    , to call his particular *attention* ---           
    ## [224]              --- Wrayburn, very *observant* of his     face    withal _b_ _b_ _b_ _b_ ---                        
    ## [225]                     --- again *take* *note* of his     face    under its evil possession _b_ ---                 
    ## [226]                   --- bow. Fledgeby made his small     eyes    smaller in *taking* special *note* ---            
    ## [227]                        --- to be whispering in his     ear    . He carried so very *attentive* ---               
    ## [228]                    --- _b_ _b_ *Intently* over her   shoulder , without slackening speed, she looked ---         
    ## [229]                       --- went on slowly, with his     eyes    narrowly *observant* of the two ---               
    ## [230]  --- composed; employing themselves, meanwhile, in   sucking   their fingers most *assiduously*, with ---        
    ## [231]        --- themselves, meanwhile, in sucking their   fingers   most *assiduously*, with the view ---             
    ## [232]                      --- that Oliver had fixed his     eyes   , most *intently*, on a portrait ---               
    ## [233]                 --- staircase, and their own white    faces   . They listened *intently*: a profound ---         
    ## [234]                 --- himself *on* *his* *toes*, and   frowning  frightfully. After various exclamations of ---    
    ## [235]                       --- former state; nor did he    rouse    himself until his *attention* was ---             
    ## [236]                     --- the glass, and turning his     ear     to the partition, listened *attentively*: ---     
    ## [237]                --- against the wall, and, scarcely  breathing , listened *attentively* _b_ _b_ _b_ ---           
    ## [238]                       --- parts, made no effort to    rouse    his *attention*. He had sat ---                   
    ## [239]                 --- *attention*. He had sat there,    awake   , but dreaming. Now, he started ---                
    ## [240]                --- looked round on the *attentive*    faces    of his wondering auditory with ---                
    ## [241]                    --- forcing a *gimlet* into the     sole    of his feet, and putting ---                      
    ## [242]                 --- at Mr. Pickwick 's *attentive*     face    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [243]             --- any emergency. Mrs. Sanders, whose     eyes    were *intently* fixed on the ---                  
    ## [244]                     --- large Dutch pipe, with his     eye     *intently* fixed on the round ---                 
    ## [245]                  --- *intently* fixed on the round     face    of the landlord; a jolly-looking ---              
    ## [246]           --- his *attentions*, imprinted her fair   fingers   upon his face, and bounced ---                    
    ## [247]                     --- pulling the shawl over his    mouth    to *concentrate* the fumes of ---                 
    ## [248]                       --- smoking a pipe, with his     eyes    *intently* fixed upon the fire. ---               
    ## [249]              --- same beaming smiles and sparkling     eyes    that had originally *captivated* him ---          
    ## [250]           --- state of remarkable *vigilance*, his     eyes    being wide open, and looking ---                  
    ## [251]                --- and less *attentively*, and his     eyes    in gloomy abstraction sought the ---              
    ## [252]                         --- a sounding snap of his    teeth   . *Observant* of his unwillingness to ---          
    ## [253]                       --- his hands clasped at his     back   , like a docile and *attentive* ---                
    ## [254]                          --- with her hands on his    breast  , and the inquiring and *attentive* ---

``` r
# F3 ["Cigarettes and drugs"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("F3"), context = 0)
y
```

    ## [  1]      --- neckcloth on (*puffing* his very      eyes     out of their natural shape), ---              
    ## [  2]     --- *snuff* and gently fluttering his    fingers    _b_ _b_ _b_ _b_ _b_ ---                       
    ## [  3]            --- and rises with a *smoking*      head    , which he dabs with his ---                   
    ## [  4]          --- says Mr. George, shaking his      head     and still composedly *smoking* _b_ ---        
    ## [  5]               --- the sofa again with his     cheeks    *puffing* over his stiff cravat, ---          
    ## [  6]           --- his *smoking* saucer to his      lips     _b_ _b_ _b_ _b_ _b_ ---                       
    ## [  7]           --- on the hearthstone with his      back     to the *smoked* chimney-piece, and ---        
    ## [  8]      --- countenance, into the trooper 's      face    . After a few more *puffs* ---                 
    ## [  9]              --- *smoked* his pipe with a      face     of grave and serious delight, ---             
    ## [ 10]                 --- put his pipe into his     mouth     again, and *smoked* like one ---              
    ## [ 11]               --- art of *smoking* in his     sleep    , and as his breathing was ---                 
    ## [ 12]         --- another pinch of *snuff*, and      went     to bed _b_ _b_ _b_ ---                        
    ## [ 13]            --- pinch of *snuff*, and went       to      bed _b_ _b_ _b_ _b_ ---                       
    ## [ 14]               --- of *snuff*, and went to      bed      _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 15]          --- *smoked* hot with grease and     blood    , raised a pole-axe, and swearing ---          
    ## [ 16]         --- of *snuff* before, and almost    sneezed    himself into convulsions even then ? ---      
    ## [ 17]     --- the chimney-corner, they all four    quaffed   , and *smoked*, and prosed, and ---            
    ## [ 18]         --- and *smoked*, and prosed, and     dozed    , as they had done of ---                      
    ## [ 19]         --- a very complacent and amiable      face    , took several *puffs* in silence; ---         
    ## [ 20]           --- Mr. Omer, after rubbing his      chin     again, and *smoking* a little ---             
    ## [ 21]          --- supreme contempt for his own     limbs    , as he sat *smoking*, was ---                 
    ## [ 22]           --- soot and *smoke* upon their     skins    ; every age and occupation appeared ---        
    ## [ 23]          --- young curate *smoked* at the     mouth     as he read. The only ---                      
    ## [ 24]               --- resumed her seat on the     bones    , and *smoked* a very short ---                
    ## [ 25]             --- to her shoulders, and her      arms     frothy with soap-suds and *smoking* ---       
    ## [ 26]           --- and bluer and *puffing* his     cheeks    further and further over the ---              
    ## [ 27]              --- of *snuff*, and made him     sneeze    until the tears ran down ---                  
    ## [ 28]             --- among a few tall chimneys    belching   *smoke* all day and night, ---                
    ## [ 29]         --- mantel-shelf gave it into his      hand    , and entreated him to *smoke* ---             
    ## [ 30]            --- *smoker*; but sat with his      eyes     fixed on Florence, and, with ---              
    ## [ 31]      --- like spray, the *smoking* horses    snorting   and plunging as if each ---                   
    ## [ 32]            --- he *smokes*; and then, his      eyes     becoming filmy, answers _b_ _b_ ---           
    ## [ 33]           --- back in chairs, with folded      arms    , or taking *snuff*, or going ---              
    ## [ 34]           --- arms, or taking *snuff*, or     going     to sleep, or writing, or ---                  
    ## [ 35]           --- or taking *snuff*, or going       to      sleep, or writing, or reading ---             
    ## [ 36]            --- tangle of *tobacco* in his      hand    , he seemed to think it ---                    
    ## [ 37]       --- Provis stood *smoking* with his      eyes     on the fire, and I ---                        
    ## [ 38]               --- careful not to move the    shoulder   next me, took a *cigar* ---                   
    ## [ 39]           --- *cigar* from his pocket and      bit      the end off, but showed ---                   
    ## [ 40]                --- for the *cigar* in his     mouth    , which he had forgotten. A ---                
    ## [ 41]             --- at me again, *smoking* my      face     and hair, and for an ---                      
    ## [ 42]          --- again, *smoking* my face and      hair    , and for an instant blinding ---              
    ## [ 43]           --- his *cigar* with his little     finger    _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 44]                --- his *cigar* out of his     mouth    , to shut up his eye (---                      
    ## [ 45]          --- pavement, holding one of his     ankles    in each hand, and *smoking* ---               
    ## [ 46]                 --- of his ankles in each      hand    , and *smoking* peacefully. There seemed ---   
    ## [ 47]   --- *cigarette* from between his parted      lips    , and showed more momentary discomfiture ---   
    ## [ 48]           --- his *cigarette* down to his    fingers    ' ends, Monsieur Rigaud had ---               
    ## [ 49]                --- his drawn sword in his      hand    , *smoking* a *cigar*. He very ---             
    ## [ 50]              --- packet of *snuff* in his      hand    , and turning upon his interrogator ---        
    ## [ 51]       --- turning his *cigar* between his      lips     _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 52]                    --- _b_ And so, with a     snort     and a *puff*, he worked ---                   
    ## [ 53]                   --- with a *puff* and a     snort     _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 54]                    --- and a *puff* and a     snort     occasionally, as if he were ---               
    ## [ 55]         --- _b_ At twenty-three, the same      hand     falteringly presented *cigars* on Sundays --- 
    ## [ 56]                   --- with a *puff* and a     snort     _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 57]                 --- it. He nestled in the     bosom     of the *tobacco* business within ---          
    ## [ 58]            --- his repast and cleaned his    fingers   , took a *cigar* from his ---                  
    ## [ 59]              --- a lighted *cigar* in his      hand    , and brought with him airs ---                
    ## [ 60]                --- put his *cigar* to his      lips     (being evidently no *smoker*), and ---        
    ## [ 61]               --- paper of *snuff* in his      hand     (much to the indignation of ---               
    ## [ 62]               --- a charge. He could only      bite     his nails and *puff* away ---                 
    ## [ 63]        --- wonderful laugh, and series of     snorts    and *puffs*, engendered in Mr ---             
    ## [ 64]             --- bundle of *cigars* in his      hand     _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 65]              --- his neck twisted and one      eye      shut up, stood *smoking* with ---             
    ## [ 66] --- *cigarettes*, and employed his facile     hands     in folding a few for ---                      
    ## [ 67]         --- took his *cigarette* from his     mouth    , and eyed him with a ---                      
    ## [ 68]            --- fell to *smoking* with his      eyes     shut. _b_ _b_ _b_ _b_ ---                     
    ## [ 69]             --- and fire-box ready to his      hand    , and fell to *smoking* _b_ ---                
    ## [ 70]            --- of soup which fanned their     brows    , the odour of stale *tobacco* ---             
    ## [ 71]    --- *tobacco* into another; rested his      chin     upon the rail as before; ---                  
    ## [ 72]                   --- with a julep on his      knee    , and a *cigar* in his ---                     
    ## [ 73]                  --- and a *cigar* in his     mouth    . He caught Mark 's eye, ---                   
    ## [ 74]         --- _b_ _b_ _b_ answered Kedgick,    sucking    his *cigar* _b_ _b_ _b_ ---                   
    ## [ 75]               --- over with knots, in his      hand    ; who *smoking* and chewing as ---             
    ## [ 76]            --- *tobacco* from a pipe, and    inhaled    it in the shape of ---                        
    ## [ 77]           --- of *snuff*, and shaking his      head     gravely _b_ _b_ _b_ _b_ ---                   
    ## [ 78]                 --- with a *cigar* in his     mouth    , and read to him, by ---                      
    ## [ 79]             --- was no *smoker*): and his      eyes     on Morleena, who sat upon ---                 
    ## [ 80]                   --- with a straw in his     mouth     issuing out of the *tobacco-shop*, ---        
    ## [ 81]      --- smuggled *cigars* under the very      nose     of the Custom House, and ---                  
    ## [ 82]     --- devoured gigantic prawns with the     heads     and tails on, chewed *tobacco* ---            
    ## [ 83]               --- and then kicking up his      legs     and *smoking* violently. Mr Brass ---         
    ## [ 84]               --- of the *tobacco* on his    nervous    system), took the opportunity of ---          
    ## [ 85]          --- the *tobacco* on his nervous     system   ), took the opportunity of slinking ---        
    ## [ 86]     --- Eugene, leaning back, folding his      arms    , *smoking* with his eyes shut, ---            
    ## [ 87]          --- his arms, *smoking* with his      eyes     shut, and speaking slightly through ---       
    ## [ 88]            --- *smoked* and flared in the      neck     of a stone bottle on ---                      
    ## [ 89]       --- thus delivers hmself, his right      hand     extended, his *smoking* saucer in ---         
    ## [ 90]       --- said Eugene, *smoking* with his      eyes     on the fire _b_ _b_ ---                       
    ## [ 91]               --- with his *cigar* in his     mouth    , to exalt its flavour by ---                  
    ## [ 92]            --- _b_ _b_ Eugene, *cigar* in     mouth     and pen in hand, tossed ---                   
    ## [ 93]          --- chair, and *smoked* with his      eyes     negligently turned on the informer, ---       
    ## [ 94]     --- Lightwood also *smoked*, with his      eyes     negligently turned on the informer ---        
    ## [ 95]                 --- with a *cigar* in his     mouth    , his coat thrown back, and ---                
    ## [ 96]    --- Composedly *smoking*, he leaned an     elbow     on the chimneypiece, at the ---               
    ## [ 97]          --- utter, but stood leaning his      head     upon his hand, *smoking*, and ---             
    ## [ 98]             --- leaning his head upon his      hand    , *smoking*, and looking imperturbably at ---  
    ## [ 99]         --- fast- waning *cigar* from his      lips     to glance at it _b_ ---                       
    ## [100]             --- took his *cigar* from his      lips     in surprise, and looked at ---                
    ## [101]       --- pretty bride, with a *narcotic* consciousness of having dreamed a dream. ---                
    ## [102]     --- sat *smoking*. Bradley leaned his     elbows    on his knees, and his ---                     
    ## [103]   --- _b_ retorted Riderhood, shaking his      head     as he *smoked* _b_ _b_ ---                    
    ## [104]        --- *smoking* a pipe, swinging one      leg      carelessly to and fro, and ---                
    ## [105]          --- fumes of the *tobacco*, fell     asleep   . _b_ _b_ _b_ _b_ _b_ ---                      
    ## [106]             --- took his *cigar* from his     mouth    , and struck the table violently ---           
    ## [107]                 --- with a *cigar* in his     mouth     _b_ _b_ _b_ _b_ _b_ ---                       
    ## [108]                  --- as he said this, and    inhaled    the pinch of *snuff* with ---                 
    ## [109]                 --- great red pipe in his     mouth    , and was *smoking*, and staring ---           
    ## [110]                 --- it at Mr. Pickwick 's     elbow    , and took *snuff* for two ---                 
    ## [111]            --- *smoking* a pipe, with his      eyes     intently fixed upon the fire. ---             
    ## [112]     --- of *snuff* with various grotesque  contractions of countenance, eulogistic of the ---         
    ## [113]           --- *snuff-* box first into the     chest     of Mr. Pickwick, and then ---                 
    ## [114]            --- shook the *snuff* from his    fingers    as if he had shaken ---                       
    ## [115]             --- of *snuff*, and shook his      head    ; as elegantly despondent as he ---            
    ## [116]           --- Lorry paused, and shook his      head     at him in the *oddest* ---                    
    ## [117]           --- he stood *smoking* with his      hand     on the back of her ---                        
    ## [118]    --- caps were *smoking*, drinking, and    sleeping  , by a watch-fire. Here he ---

``` r
# S1.2.3- ["Egoism" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("S1.2.3-"), context = 0)
y
```

    ## [ 1]                --- *unassuming* man. From beneath his     feet    , at such times, as from ---                       
    ## [ 2]                         --- gas and coughs behind his     hand    , *modestly* anticipating profit. Mr. Snagsby, --- 
    ## [ 3]                         --- moist eye and an inflamed     nose    , who *modestly* takes a position ---              
    ## [ 4]                           --- natural it is to gentle    hearts    to be *considerate* and delicate ---              
    ## [ 5]          --- of *self-depreciation* and contracts his   eyebrows   a little more _b_ _b_ ---                         
    ## [ 6]                   --- ashes (or hair-powder) on their     heads   , symptomatic of their great *humility*, ---       
    ## [ 7]                   --- great *humility*, loll away the    drowsy    mornings in the little windows ---                
    ## [ 8]                           --- husband to be melted to     tears    by these affectionate *self-sacrifices* _b_ ---   
    ## [ 9]                         --- And there she stopped and   shivered  , for her *modesty* caught cold ---                
    ## [10]                          --- up their minds to *meek*   endurance  and patient resignation. Mrs Varden ---           
    ## [11]                 --- and *humility* and *lowliness* of     heart    were virtues. Wherefore she desired ---           
    ## [12]               --- the secretary, with *meekly* folded     hands    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [13]                --- long-suffering, and so much *meek*   endurance , under her trials, and breathed ---               
    ## [14]                      --- the desk again, watching his      eye     - *humbly* watching his eye, as ---               
    ## [15]                   --- his eye - *humbly* watching his      eye    , as he rules a ciphering-book ---                 
    ## [16]                         --- and Uriah Heep walk past,      arm     in arm: Uriah *humbly* sensible ---               
    ## [17]                            --- Heep walk past, arm in      arm    : Uriah *humbly* sensible of the ---               
    ## [18]                      --- *bashful*, and he buried his     face     in her skirts, to her ---                         
    ## [19]                  --- *retiring* manners, with a comic     head     of hair, and eyes that ---                        
    ## [20]                    --- very *meekly*, and shaking his     head     as he surveyed me _b_ ---                         
    ## [21]                         --- to the dutiful and *meek*   endurance  of the present. Such idle ---                     
    ## [22]                           --- *meek* woman, of a fair  complexion , with her eyebrows always elevated, ---           
    ## [23]            --- observed Solomon, *meekly* rubbing his     hands    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [24]                          --- upon the ground, and his     head     bowed, *humbly* listening to the ---              
    ## [25]                   --- the *unassuming* *style* of his     hair     -- which (as already hinted) ---                  
    ## [26]                        --- him, and suffer her loving     heart    *humbly* to approach him, without ---             
    ## [27]                     --- spread something dry upon her   shoulders , and hovered *humbly* about her, ---              
    ## [28]                       --- to him, with her commanding     face     exacting his *humility*, her disdainful ---       
    ## [29]           --- exacting his *humility*, her disdainful      lip     repulsing him, her bosom angry ---                
    ## [30]                         --- the Captain, in a violent perspiration, stood *meekly* looking at Mrs ---                
    ## [31]                --- returned Mrs. Sparsit, shaking her     head     with her State *humility* _b_ ---                 
    ## [32]                             --- a *meek* shake of her     head     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [33]                         --- make out Little Dorrit 's     face    ; she was so *retiring*, plied ---                 
    ## [34]                 --- *retiring* childish form, and the     face     in which he now saw ---                           
    ## [35]                       --- the faithful fulness of her     heart   , and *modestly* said, raising her ---             
    ## [36]                  --- and *modestly* said, raising her     eyes     appealingly to her new friend ---                 
    ## [37]                  --- Mr Sparkler *humbly* offered his      arm    . Miss Fanny accepting it, was ---                 
    ## [38]                     --- the *bashful* Member shut his     eyes     quite tight _b_ _b_ _b_ ---                       
    ## [39]                           --- a moustache -- a shaggy   moustache  too; nothing in the *meek* ---                    
    ## [40]                             --- as he pressed his hot     hands    together, and replied, with *humility* ---        
    ## [41]                         --- Pecksniff took him by the      arm    , when he *meekly* rose _b_ ---                    
    ## [42]                               --- was a man of *meek*   endurance , and Mr Jonas was his ---                         
    ## [43]                         --- touch of the *coy* little     hand    , that he glanced down to ---                      
    ## [44]            --- *bashful* arrangement, Moddle gave his      arm     to Tom; and Miss Pecksniff ---                    
    ## [45]                        --- him, and lay her *bashful*     hand     upon his shoulder, and not ---                    
    ## [46]                       --- her *bashful* hand upon his   shoulder  , and not be willing to ---                        
    ## [47]                     --- *meekly* shook his poor, grey     head    , and thanked old Martin in ---                    
    ## [48]                          --- the whole scene with her     eyes     *modestly* fixed upon the ground, ---             
    ## [49]    --- *considerate* and affectionate conduct brought     tears    into the eyes of Mr ---                           
    ## [50]                      --- Mr Snawley, casting down his     eyes     with an air of *humility*, ---                    
    ## [51]                     --- said Mrs Nickleby, fixing her     eyes     *modestly* on the ground _b_ ---                  
    ## [52]                            --- the earth, was, in his     hands   , the *meekest* and most tractable ---             
    ## [53] --- constrained, reserved, *diffident*, troubled. His     eyes     were on Miss Bella for ---                        
    ## [54]                         --- removed his hand from his     nose    . Some natural *diffidence* assailed him ---       
    ## [55]                     --- The child *meekly* raised his     eyes    , and encountered those of Mr. ---                 
    ## [56]             --- gardener and sub-gardener with *meek*     faces   , to whom (the gardeners, not ---                  
    ## [57]                   --- white-faced man, in a perpetual perspiration, bowed *meekly*, to the great ---                 
    ## [58]                     --- Dodson turned round, bent his     head     *meekly*, and smiled _b_ _b_ ---                  
    ## [59]                --- who *modestly* concealed his spiky     head     from the observation of Tellson ---

``` r
# N3.8- ["Measurement: Speed" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.8-"), context = 0)
y
```

    ## [  1]  --- Smallweed inquires, *slowly* rubbing his      legs     _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [  2]         --- he observes, *slowly* rubbing his     hands     _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [  3]                --- says Mr. Guppy, taking his      arm      again and walking him *slowly* ---                            
    ## [  4]  --- self-possessed, looked after by admiring      eyes    , passes away *slowly* *down* the ---                          
    ## [  5]       --- he *slowly* replied, roughening his      head     more and more _b_ _b_ ---                                     
    ## [  6]        --- short one-sided inclination of his      head     from the neck and *slowly* ---                                
    ## [  7]                      --- of his head from the      neck     and *slowly* shook it _b_ ---                                 
    ## [  8]       --- shuffling up, *slowly* scooping the    knuckles   of his right hand round ---                                   
    ## [  9]            --- and *slowly* rubbing his rusty      legs     up and down, up and ---                                       
    ## [ 10]          --- very *slowly* rubbing his gloved     hands    , as if, to his cold ---                                       
    ## [ 11]                 --- very *slowly* took from a breast-pocket a stained, discoloured paper which ---                        
    ## [ 12]                 --- him. He *slowly* laid his      face     down upon her bosom, drew ---                                 
    ## [ 13]            --- John Willet *slowly* shook his      head    , and thereupon his friends *slowly* ---                       
    ## [ 14]              --- his blooming daughter on the     cheek    , and *slowly* repaired to Mrs ---                             
    ## [ 15]               --- of two *slow* travellers on      foot    , making towards Chigwell. _b_ _b_ ---                         
    ## [ 16]             --- _b_ John *slowly* brought his      eyes     to bear upon him, looked ---                                  
    ## [ 17]                  --- at the other 's downcast      eyes    , which brightened *slowly* as he ---                          
    ## [ 18]           --- floor, and *slowly* beating the      palm     of one hand with the ---                                      
    ## [ 19]                      --- a hearty slap on the      back    , which Hugh was not *slow* ---                                
    ## [ 20]                 --- *slowly* up and down with      eyes     that sought the ground, and ---                               
    ## [ 21]                 --- curl *slowly* off, and to     sniff     the grateful fragrance of the ---                             
    ## [ 22]           --- went *slowly* away, turning his      head     from time to time, and ---                                    
    ## [ 23]                   --- or, bearing it upon his    shoulder  , paced *slowly* up and down, ---                              
    ## [ 24]               --- *slow*. What phantom of the     brain     did he pursue; and why ---                                    
    ## [ 25]              --- 's meat, came skulking past,   barefooted  -- going *slowly* away because ---                            
    ## [ 26]      --- waggons rumbled through the *slowly*     waking    streets, the early cries were ---                             
    ## [ 27]                       --- at the blind man 's     elbow    , and *slowly* followed, towards the ---                       
    ## [ 28]                --- *slow* process with him --      went     to sleep with one eye ---                                     
    ## [ 29]                   --- he *slowly* sunk into a    slumber   , he was conscious of its ---                                  
    ## [ 30]             --- more *slowly*. He carried his      head     on one side, partly in ---                                    
    ## [ 31]                  --- 's bridle drawn over his      arm     , walked *slowly* up and down ---                              
    ## [ 32]             --- he said, *slowly* turning his      eyes     towards me. 'Well ! If you ---                                
    ## [ 33]                --- in a woeful condition. The     soles     had shed themselves *bit* *by* ---                            
    ## [ 34]                  --- _b_ Uriah, with his long     hands     *slowly* twining over one another, ---                        
    ## [ 35]                    --- _b_ _b_ Here his right      hand     came *slowly* and feebly from ---                             
    ## [ 36]                   --- over a *slow* fire; the     palms     of my hands, hot plates ---                                   
    ## [ 37]                      --- with a letter in his      hand    . He was *taking* *his* *time* ---                             
    ## [ 38]          --- house, *slowly* fitting his long    skeleton   fingers into the still longer ---                             
    ## [ 39]        --- *slowly* fitting his long skeleton    fingers    into the still longer fingers ---                             
    ## [ 40]       --- eyes, and disdainfully inclined her      head    ; then, *slowly* opening her eyes, ---                         
    ## [ 41]          --- head; then, *slowly* opening her      eyes    , resumed _b_ _b_ _b_ _b_ ---                                  
    ## [ 42]            --- _b_ said Traddles, rubbing his     hands     *slowly* over one another _b_ ---                             
    ## [ 43]       --- sentiment, and *slowly* shaking his      head     as he poised himself upon ---                                 
    ## [ 44]              --- he had *slowly* restored his      face     to its natural form _b_ ---                                   
    ## [ 45]                   --- a *slow* curling of her      lip      _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [ 46]       --- himself, after wringing his wounded      hand     for sometime, *slowly* drew off ---                           
    ## [ 47]                 --- very *slowly* back to me,     licks     my hand, and lifts his ---                                    
    ## [ 48]                        --- to a motion of her      hand     at the window, drove *slowly* ---                             
    ## [ 49]      --- Chillip, *slowly* shaking his little      head     again _b_ _b_ _b_ _b_ ---                                     
    ## [ 50]                  --- a little while, with her      chin     upon her hand. *Slowly* raising ---                           
    ## [ 51]                    --- with her chin upon her      hand    . *Slowly* raising her eyes to ---                             
    ## [ 52]            --- her hand. *Slowly* raising her      eyes     to mine, she said _b_ ---                                     
    ## [ 53]                  --- _b_ My aunt withdrew her      eyes     from mine, as *slowly* as ---                                 
    ## [ 54]            --- by *slow* degrees, towards the     heart     of that great region which ---                                
    ## [ 55]                  --- _b_ Mr Dombey turned his      head     away, and going *slowly* to ---                               
    ## [ 56]            --- began the Captain, rolling his      eyes     *slowly* round the little room, ---                           
    ## [ 57]             --- returned old Sol, rubbing his     hands     *slowly*, and considering the matter ---                      
    ## [ 58]          --- that species, and her *creeping*      face    , some half-a-dozen more: crouched on ---                      
    ## [ 59]          --- descended *slowly* to the little      back     parlour, and, seated in his ---                               
    ## [ 60]             --- said the Captain, shaking his      head     *slowly* _b_ _b_ _b_ _b_ ---                                  
    ## [ 61]                    --- _b_ were rising to his      lips     -- but *slowly* and with ---                                  
    ## [ 62]                    --- _b_ Mr Carker bent his      head     *slowly*, and very softly rubbed ---                          
    ## [ 63]             --- _b_ She *slowly* withdrew her      eyes     from his face, and turning ---                                
    ## [ 64]      --- experienced little but the *rolling*      back     of that strong tide upon ---                                  
    ## [ 65]                   --- a little cloud from his      lips    , *slowly* puffed it forth, as ---                             
    ## [ 66]             --- *slower* and heavier, and his      face     more sternly thoughtful; as the ---                           
    ## [ 67]                     --- made her so *slow* of    hearing   , that a footfall without had ---                              
    ## [ 68]            --- *slowly* emptied it, shook his      head    , and began to draw his ---                                    
    ## [ 69]               --- the *creeping* track of his      hand     upon the table. At the ---                                    
    ## [ 70]              --- it, and *slowly* shaking his      head     at the vacant chair, for ---                                  
    ## [ 71]      --- breaking her silence, without moving      eye      or limb, answered *slowly* _b_ ---                            
    ## [ 72]            --- silence, without moving eye or      limb    , answered *slowly* _b_ _b_ _b_ ---                            
    ## [ 73]            --- watches apparently in a *slow*  perspiration, tarnished sugar-tongs with ineffectual legs, ---             
    ## [ 74]                 --- uttered no sound, and her   breathing   was no *slower* _b_ _b_ ---                                   
    ## [ 75]       --- Minor Canon, *slowly* releasing the      hand     he had taken in his ---                                       
    ## [ 76]                 --- with his bundle under his      arm     , *slowly* found and counted out ---                           
    ## [ 77]         --- looked reflective, and nodded her      head     *slowly*; as who should say ---                               
    ## [ 78]                --- she *slowly* gets upon her      feet    , with an air of disappointment, ---                           
    ## [ 79]    --- chilled and shaking, *slowly* recovers consciousness of where he is, and ---                                       
    ## [ 80]            --- middle-aged *slow* man, with a     mouth     like a fish, dull staring ---                                 
    ## [ 81]              --- it with a *slowly* searching      eye      _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [ 82]                       --- with her hand on my    shoulder  , but more and more *slowly*. ---                              
    ## [ 83]         --- he interrupted, shaking his great      head     very *slowly* _b_ _b_ _b_ ---                                 
    ## [ 84]                   --- learn a lesson from his      face    , and *slowly* replied _b_ _b_ ---                             
    ## [ 85]     --- and comprehension - in the *sluggish*   complexion  of his face, and in ---                                       
    ## [ 86]          --- the *sluggish* complexion of his      face    , and in the large awkward ---                                 
    ## [ 87]              --- elongation of Mr. Wemmick 's     mouth    , powerfully suggestive of his *slowly* ---                    
    ## [ 88]       --- *slowly* and gradually stealing his      arm      round Miss Skiffins 's waist. ---                             
    ## [ 89]             --- and *slowly* rubbed his right      hand     over his head _b_ _b_ ---                                     
    ## [ 90]                    --- got up, and linked his      arm      in mine, and we *slowly* ---                                  
    ## [ 91]            --- at me, *slowly* unclenched his      hand     and drew it across his ---                                    
    ## [ 92]                   --- fall like a plummet. He   swallowed   *slowly*, tilting up the bottle ---                           
    ## [ 93]                  --- *slowly*; and he held my      hand     while all the others were ---                                 
    ## [ 94]             --- towards them *slowly*, for my     limbs     were weak, but with a ---                                     
    ## [ 95]             --- went downstairs and the fixed      eye      of Philosophy - and its *rolling* ---                         
    ## [ 96]         --- of Philosophy - and its *rolling*      eye     , too - soon lost the three ---                                
    ## [ 97]             --- to the inside, with suspended     breath    and with a *slow* footstep. ---                               
    ## [ 98]                    --- than to rest his weary      head    ; but, by *slow* degrees as ---                                
    ## [ 99]             --- he said, turning his furrowed      face     *slowly* about, that he might ---                             
    ## [100]                   --- _b_ _b_ MRS. SPARSIT 'S     nerves    being *slow* to recover their ---                             
    ## [101]                  --- Mr. Sleary, who with his     mouth     open and his *rolling* eye ---                                
    ## [102]              --- mouth open and his *rolling*      eye      as immovably jammed in his ---                                
    ## [103]                       --- on the rug, and his     thumbs    *slowly* revolving over one another. ---                      
    ## [104]                    --- _b_ _b_ He carried his     finger    *slowly* *down* to the wrist, ---                             
    ## [105]             --- finger *slowly* *down* to the     wrist    , and round the wrist, and ---                                 
    ## [106]                 --- _b_ _b_ _b_ Releasing the      hand     by *slow* degrees, he drew ---                                
    ## [107]                      --- it out and wiped his    forehead   with it, *slowly* repeating _b_ ---                           
    ## [108]                     --- _b_ _b_ She shook her      head    , after each *slow* repetition of ---                          
    ## [109]        --- *slow* determination of his turbid     blood     to his temples, whether a ---                                 
    ## [110]                     --- child, in a medley of     tears     and congratulations, chopping-boards, *rolling-pins*, and --- 
    ## [111]             --- He *slowly* stretched out the      hand     that had been upon his ---                                    
    ## [112]             --- complaining that he could n't    breathe   , he *slowly* fell into a ---                                  
    ## [113]                   --- he *slowly* fell into a    slumber   . Clennam had abundant occupation for ---                      
    ## [114]                  --- silence of the room, her      hand     *slowly* slackened and failed in ---                          
    ## [115]               --- Aunt then moistened her ten    fingers    in *slow* succession at her ---                               
    ## [116]               --- in *slow* succession at her      lips    , and wiped them in exactly ---                                
    ## [117]         --- to conjugate, that his *sluggish*     blood     and his long coat-cuffs became ---                            
    ## [118]        --- his grand staircase, *slowly*, and     tired    , and looked into various chambers ---                         
    ## [119]              --- went, more *slowly* and more     tired    , up the staircase to his ---                                  
    ## [120]                 --- at the bottom, rubbed his      hair     and *slowly* appended to his ---                              
    ## [121]               --- _b_ _b_ john 's incredulous      face     *slowly* softened into a face ---                             
    ## [122]             --- face *slowly* softened into a      face     of doubt. He rose, backed ---                                 
    ## [123]                    --- on his back a bursting     chest     of oranges, poured *slowly* through ---                       
    ## [124]             --- *slowly* opened, and a little   blear-eyed , weazen-faced, ancient man came creeping ---                  
    ## [125]       --- separation; of her quiet monotonous   endurance  , and her *slow* anxiety from ---                              
    ## [126]                       --- be known by a heavy      eye      and a dull *slow* manner; ---                                 
    ## [127]          --- By *slow* degrees, however, some     heads     and shoulders appeared, and connecting ---                    
    ## [128]       --- became silent; gradually rubbed her      nose     more and more *slowly* along ---                              
    ## [129]                      --- James 's Square at a      hand     gallop, and coming *slowly* into ---                          
    ## [130]                     --- taking the old man 's      arm      in his, and walking *slowly* ---                              
    ## [131]               --- pew, by *slow* degrees, his      hair    , his forehead, his eyebrow, his ---                           
    ## [132]             --- *slow* degrees, his hair, his    forehead  , his eyebrow, his eye. She ---                                
    ## [133]                 --- _b_ Mr Nadgett rubbed his     hands     *slowly*, stroked his chin, looked ---                        
    ## [134]           --- his hands *slowly*, stroked his      chin    , looked round the room, and ---                               
    ## [135]                          --- him a tap on the      head     with the *rolling-pin*, and still ---                         
    ## [136]              --- him seemed to overspread his      face    , and *slowly* change it. *Slowly*, ---                        
    ## [137]            --- her arms tighter, suffered her      head     to roll *slowly* from side ---                                
    ## [138]                  --- and fro, took Chuffey 's      arm     , and *slowly* followed Nadgett out. ---                       
    ## [139]              --- grim silence, and rubbed his     hands     *slowly* over each other: cracking ---                        
    ## [140]         --- walked *slowly* westward with his     hands     behind him _b_ _b_ _b_ ---                                    
    ## [141]               --- _b_ said Ralph, rubbing his     hands     *slowly* over each other _b_ ---                              
    ## [142]             --- *leisurely* applied it to his     mouth     _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [143]                     --- he drew a long *slow*     breath   , and still maintaining his position ---                       
    ## [144]                    --- up her lips, shook her      head     in a *slow* and doubtful ---                                  
    ## [145]     --- further discussion, Sir Mulberry Hawk     yawned   , and very *leisurely* turned back. ---                        
    ## [146]                      --- arm nearly up to the    shoulder  , and *slowly* drew forth this ---                             
    ## [147]                  --- *slow* degrees, as a man    rousing    himself from heavy slumber, to ---                            
    ## [148]                 --- and supporting him on his      arm      while they walked *slowly* among ---                          
    ## [149]              --- lethargic and heavy were his    slumbers  . Regaining his faculties by *slow* ---                        
    ## [150]                    --- body, as he rubbed his     hands     *slowly* round, and round, and ---                            
    ## [151]               --- should kill himself and his     blood     come *creeping*, creeping, on the ---                         
    ## [152]             --- *slow* and feeble degrees his consciousness came back; but the mind ---                                   
    ## [153]                --- hold of her grandfather 's      hand    , and Mr Codlin sauntering *slowly* ---                        
    ## [154]               --- and was quite resigned; his      eye      *slowly* wandering about during the ---                       
    ## [155]                --- a compliant smile, and his     brows     *slowly* unbent. By the time ---                              
    ## [156]                --- dropped upon its hands and     knees    , and crawled away. How *slowly* ---                           
    ## [157]                  --- senses -- and the *slow*     waking    up, and finding one 's ---                                    
    ## [158]                  --- -- and the *slow* waking       up     , and finding one 's self ---                                  
    ## [159]       --- portentous gravity, and nodding his      head     once, in a *slow* and ---                                     
    ## [160]            --- an evil conscience, and making    slumber    horrible -- in these *slow* ---                               
    ## [161]               --- _b_ said Quilp, rubbing his     hands     very *slowly*, and pressing them ---                          
    ## [162]      --- returned *slowly*, being pretty well    breathed   with his run _b_ _b_ ---                                      
    ## [163]             --- the dwarf, stretching out his      arms    , and walking *slowly* on _b_ ---                              
    ## [164]                      --- man to lean upon his      arm     , conducted him with *slow* and ---                            
    ## [165]          --- *slowly* and knowingly, with his      head     stuck on one side, as ---                                     
    ## [166]                --- she *slowly* cast down her      eyes     _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [167]                   --- _b_ _b_ More serious of      face    , and more *slow* of action, ---                               
    ## [168]                      --- the face. It was the      face     belonging to a naturally *slow* ---                           
    ## [169]          --- by *slow* approaches removed his      hand     from his nose. Some natural ---                               
    ## [170]                  --- grave *slow* wave of his      head     _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [171]       --- _b_ *slowly* returns that practical   anatomist  , after drinking _b_ _b_ _b_ ---                               
    ## [172]                 --- is *slowly* raised, and a      head     *slowly* looks in out of ---                                  
    ## [173]              --- the horse. Opening his heavy      eyes    , he *slowly* broke into a ---                                 
    ## [174] --- forefinger, and, *slowly* recovering that      hand    , settled his chin in it ---                                   
    ## [175]                  --- was seen standing at the      foot     of the second mound, *slowly* ---                             
    ## [176] --- straightway, and, *leisurely* leaning his      arms     on the open window of ---                                     
    ## [177]           --- walk *slowly* on, with downcast      eyes    . He put her hand to ---                                       
    ## [178]                  --- *slow* heavy rubs of his      hand     across his forehead, as if ---                                
    ## [179]                --- went on *slowly*, with his      eyes     narrowly observant of the two ---                             
    ## [180]  --- other. Bradley, *slowly* withdrawing his      eyes    , turned his face to the ---                                   
    ## [181]                    --- _b_ _b_ _b_ Bradley 's      face     darkened, and his hand *slowly* ---                           
    ## [182]                 --- 's face darkened, and his      hand     *slowly* closed on the purse ---                              
    ## [183]                    --- twisted his cap in his     hands    , and walked *slowly* from the ---                             
    ## [184]          --- frightful form *slowly* rear its      head    , to drive him mad with ---                                    
    ## [185]         --- walked *slowly* away, tapping his      chin     with the cover of the ---                                     
    ## [186]                   --- more surely on the dead      body    , than does this *slow* *creeping* ---                         
    ## [187]             --- crept *slowly* on. Oliver lay     awake     for some time, counting the ---                               
    ## [188]                 --- _b_ Mr. Bumble opened his      eyes    ; read the advertisement, *slowly* and ---                     
    ## [189]              --- a *creeping* sickness at his     heart    , which seemed to warn him ---                                 
    ## [190]                --- by *slow* degrees, he fell     asleep   . _b_ _b_ _b_ _b_ _b_ ---                                      
    ## [191]        --- Brownlow, *slowly*, and fixing his      eyes     upon the other 's face ---                                    
    ## [192]          --- drew them *slowly* off. Blanched      face    , sunken eyes, hollow cheeks, beard ---                        
    ## [193]       --- *slowly* off. Blanched face, sunken      eyes    , hollow cheeks, beard of three ---                            
    ## [194]                 --- _b_ _b_ Sikes carried his      eyes     *slowly* up the wall behind ---                               
    ## [195]   --- glass of brandy-and-water, and *slowly*   swallowed   half of it, opened the ---                                    
    ## [196]             --- masticating when he last fell     asleep   , and *slowly* obeyed his master ---                           
    ## [197]           --- *slow* degrees supported by the      arms     of his anxious friends. _b_ ---                               
    ## [198]                         --- on the fat boy 's    shoulder  , and walk *leisurely* to the ---                              
    ## [199]        --- capacious shawls which muffled his     throat    and chest, and *slowly* uttered ---                           
    ## [200]              --- which muffled his throat and     chest    , and *slowly* uttered these sounds ---                        
    ## [201]                --- *slowly* forward on men 's   shoulders  . A dead silence pervaded the ---                              
    ## [202]               --- and coeval stockings on his      legs    , *slowly* desisted from his occupation ---                    
    ## [203]             --- and turning *slowly* upon his      heel    , disappeared from his sight. _b_ ---                          
    ## [204]                     --- up the corners of his     mouth    , shook his head *slowly* from ---                             
    ## [205]                   --- of his mouth, shook his      head     *slowly* from side to side ---                                
    ## [206]              --- having once more grasped his      hand    , walked *slowly* away, revolving in ---                       
    ## [207]           --- Pickwick turned *slowly* on his      heel    , and rejoined his friends. _b_ ---                            
    ## [208]     --- replied Jackson, *slowly* shaking his      head     _b_ _b_ _b_ _b_ _b_ ---                                       
    ## [209]                    --- And, with a very grave      face    , Mr. Weller *slowly* read as ---                              
    ## [210]               --- said Mr. Roker, shaking his      head     *slowly* from side to side, ---                               
    ## [211]          --- of cheerfulness, passed over his      face     too, as he *slowly* said ---                                  
    ## [212]         --- gentleman in *slowly* shaking his      head     from side to side, and ---                                    
    ## [213]                      --- boy, in a *slow* and     sleepy    voice _b_ _b_ _b_ _b_ ---                                     
    ## [214]          --- company, and *slowly* lifted his      hand    , upon which every man (including ---                          
    ## [215]          --- *slowly* opened inward under his      hand    , and he looked into the ---                                   
    ## [216]                 --- hands the whole time. His      eyes     came *slowly* back, at last, ---                              
    ## [217]                 --- looking at him with sharp      eyes    , and *slowly* drawing a hand ---                              
    ## [218]              --- eyes, and *slowly* drawing a      hand     across his florid face _b_ ---                                
    ## [219]                  --- and his snuff-box in his      hand    , *slowly* passed among the mirrors ---                        
    ## [220]                     --- hand turn cold in the      hand     that *slowly* released and dropped ---                        
    ## [221]              --- would *slowly* fall from her     hands    , and her eyes would be ---                                    
    ## [222]                  --- fixed on the writer, his      hand     *slowly* and softly moved down ---                            
    ## [223]   --- *leisurely*, the new postilions follow,    sucking    and plaiting the lashes of ---                                
    ## [224]          --- follow, sucking and plaiting the     lashes    of their whips; *leisurely*, the ---

``` r
# N3.6 ["Measurement: Area"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.6"), context = 0)
y
```

    ## [ 1]           --- has *stretched* forth its unwholesome     hand    to spoil and corrupt would ---                
    ## [ 2]               --- was nursing *stretched* forth its     arms    and cried out to be ---                       
    ## [ 3]                  --- _b_ _b_ *Stretching* forth his    flabby   paw, Mr. Chadband lays the ---                
    ## [ 4]                --- with those two lean affectionate     arms    of his *stretched* forth _b_ ---              
    ## [ 5] --- small-clothes, *stretches* his symmetrical silk     legs    with the air of a ---                         
    ## [ 6]                 --- his confidential friend and his     hand    *stretched* forth ready to take ---           
    ## [ 7]           --- out accordingly, and *stretching* her     neck    over the handrail, she descried, ---          
    ## [ 8]           --- chimney-corner; the other, Hugh, who,   sleeping  too, lay *stretched* upon the ---             
    ## [ 9]         --- staggering in, *stretching* himself and   yawning   according to custom, and presenting ---       
    ## [10]          --- sure, the bystanders *stretched* their   throats   indeed; and he went on ---                    
    ## [11]     --- spreading honeysuckle, and *stretching* his     legs    across the threshold so that ---              
    ## [12]                      --- brief *space*, for when he    awoke   , the rich light had faded, ---                
    ## [13]                      --- men lay *stretched* at his     feet   : the one he had marked, ---                   
    ## [14]                          --- the same moment a lean     neck    was *stretched* over the parapet, ---         
    ## [15]                  --- under sentence sounding in his     ears   , and their hands, *stretched* our ---         
    ## [16]                          --- in his ears, and their    hands   , *stretched* our through the gratings ---     
    ## [17]                        --- only other tenant of the     cell   , who lay, *stretched* at his ---              
    ## [18]                        --- Hugh came forth from his     cell    as they did, *stretching* himself ---         
    ## [19]    --- whole tumultuous concourse *stretched* their   throats  , and cheered with all their ---               
    ## [20]                     --- my jacket, I *stretched* my     neck    eagerly to look for the ---                   
    ## [21]                              --- to look up. A fair     hand    was *stretched* forth to me ---               
    ## [22]                            --- a show of taking the     hand    he *stretched* across to me; ---              
    ## [23]                     --- the possession of their few     feet    of *space*, with their little ---             
    ## [24]                    --- them on, and *stretched* his     feet    enjoyingly upon the fender _b_ ---            
    ## [25]                        --- beams upon him, from the     head   , across a cheerful *space* that ---           
    ## [26]                        --- said Mr Carker, with his    mouth    *stretched* to the utmost _b_ ---             
    ## [27]            --- observed Mr Carker, *stretching* his    mouth    wider yet _b_ _b_ _b_ ---                     
    ## [28]                 --- watchful manner; in whose false    mouth   , *stretched* but not laughing; in ---         
    ## [29]                 --- and fro, casks blockading every     foot    of *space*, and, in the ---                   
    ## [30]                         --- then, with even the hot    tongue   revealing itself through the *stretched* ---  
    ## [31]        --- revealing itself through the *stretched*    mouth   , as the eyes encountered Mr ---               
    ## [32]                   --- the *stretched* mouth, as the     eyes    encountered Mr Dombey 's _b_ ---              
    ## [33]                   --- into town repeating, with his    mouth    *stretched* to the utmost, as ---             
    ## [34]             --- the Manager, *stretching* forth his     arm     _b_ _b_ _b_ _b_ _b_ ---                       
    ## [35]                    --- *space* between the giant 's     feet   , as yet, is only blighted ---                 
    ## [36]                         --- he said, with his false    mouth    distended to its fullest *stretch* ---        
    ## [37]              --- 's dressing-room when an imperious     hand    was *stretched* towards the door; ---         
    ## [38]                        --- it between his thumb and    finger  , and hastily clearing a *space* ---           
    ## [39]                   --- to reply, she *stretched* her     arm     out, pointing to the chair. ---               
    ## [40]                          --- if he were eluding the    hands    of the dead people, *stretching* ---          
    ## [41]                        --- with one of her withered     arms    *stretched* out of the chair, ---             
    ## [42]                          --- clear *space* of a few     feet    between the table and the ---                 
    ## [43]                          --- of it, and holding the     hand    that he *stretched* forth to ---              
    ## [44]                          --- and now stood with his     hand    before his face. She *stretched* ---          
    ## [45]                        --- with his hand before his     face   . She *stretched* out hers, as ---             
    ## [46]                --- of houses, where the inhabitants    gasped   for air, *stretched* far away ---             
    ## [47]                           --- he began to droop and     tire   , and at last *stretched* himself ---          
    ## [48]     --- surprise, Mistress Affery, *stretching* her     eyes    wide at himself, as if ---                    
    ## [49]              --- apparently *stretch* on to include    Fanny    _b_ _b_ _b_ _b_ _b_ ---                       
    ## [50]                 --- _b_ said John, *stretching* his     hand    across the tea-tray, 'if too ---              
    ## [51]                    --- _b_ _b_ _b_ *Stretching* his     body    out on the only three ---                     
    ## [52]         --- gentleman, *stretching* forth his right     arm    , which was so tightly wedged ---              
    ## [53]                     --- _b_ _b_ replied his friend,   yawning   and *stretching* himself _b_ _b_ ---          
    ## [54]              --- said, *stretching* forth his right     hand    _b_ _b_ _b_ _b_ _b_ ---                       
    ## [55]                 --- he *stretched* himself upon his     back    again and resumed the book ---                
    ## [56]                    --- were seen to *stretch* their    necks    and stand upon their toes, ---                
    ## [57]             --- they could possibly *stretch* their     legs    without converting themselves into double --- 
    ## [58]                       --- stage -- to *stretch* his     legs    as he said -- and ---                         
    ## [59]                   --- in his chair, *stretched* his     legs    out before the fire, and ---                  
    ## [60]                  --- minutes, he returned, with his     legs    thoroughly *stretched*, if the hue ---        
    ## [61]             --- had evidently been *stretching* his     legs   , on the old principle, not ---                
    ## [62]                 --- which, he *stretched* his weary    limbs   , and soon fell asleep. _b_ ---                
    ## [63]                --- and some fear, *stretched* their    necks    forward, and listened attentively _b_ ---     
    ## [64]        --- they evinced, by various half-suppressed    yawns    and *stretchings* of their limbs, ---         
    ## [65]                --- yawns and *stretchings* of their    limbs   , an obvious inclination to retire ---         
    ## [66]              --- wings, and there *stretched* their    necks    to have a peep at ---                         
    ## [67]                            --- _b_ _b_ At length he    yawned  , *stretched* himself, and rose; walked ---    
    ## [68]                   --- Hawk lay *stretched* upon his     back   , on the couch to which ---                    
    ## [69]                     --- taught him, and folding his    hands    and *stretching* them wildly in ---           
    ## [70]                          --- looked at her with his     eyes    *stretched* wide; and opened and ---          
    ## [71]           --- dungeons *stretched* their cramp cold    limbs    and cursed the stone that ---                 
    ## [72]                    --- up and *stretched* his short     arm     across the table. After a ---                 
    ## [73]                          --- long in lulling her to    sleep   . The old man was *stretched* ---              
    ## [74]                 --- Her worthy lord *stretched* his     neck    and eyes until she had ---                    
    ## [75]                   --- lord *stretched* his neck and     eyes    until she had crossed the ---                 
    ## [76]                       --- a *space*, and drew their    breath   softly, as if they feared ---                 
    ## [77]               --- cried the dwarf, *stretching* his     neck    to obtain a better view ---                   
    ## [78]                         --- bar to soften the human    breast  . The available *space* in it ---              
    ## [79]                     --- bigger, that *space* was so     girt    in by corpulent little casks, ---             
    ## [80]                           --- hair, and then in his     nose   ; and then he *stretched* himself ---          
    ## [81]                     --- _b_ She had *stretched* her    hands    up with that higher and ---                   
    ## [82]                        --- fire and musing with his     face    to it, *stretched* the legs ---               
    ## [83]                     --- face to it, *stretched* the     legs    of the rose-coloured Turkish trousers ---     
    ## [84]                   --- when she sees him *stretched* unconscious, asks the doctor, with clasped ---            
    ## [85]                  --- *space*; and then, raising his     head   , and heaving a gentle sign, ---               
    ## [86]            --- _b_ *Stretching* forth her trembling   fingers   as she spoke, the old ---                     
    ## [87]               --- upright, and was *stretching* her     arms    towards them _b_ _b_ _b_ ---                  
    ## [88]             --- still lay *stretched*, helpless and unconscious, on his bed of clay. ---                      
    ## [89]              --- and *stretching* forth their green     arms    over the thirsty ground, converted ---        
    ## [90]                       --- a limited *space*, by the   physical  weakness to which we have ---                 
    ## [91]        --- Sawyer, playfully *stretching* forth his     arms   , and skipping from side to ---                
    ## [92]                        --- sucking the rust off his   fingers   in his absorption, *stretched* his ---        
    ## [93]              --- in his absorption, *stretched* his     neck    to hear who they were. ---                    
    ## [94]                       --- or so, he was *stretched*  insensible on the ground. _b_ _b_ ---

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
Rdev -e "rmarkdown::render('DNov_quotes_non-quotes.Rmd')"
```
