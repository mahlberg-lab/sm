-   [Data](#data)
    -   [Get the corp\_text objects](#get-the-corp_text-objects)
    -   [Create a data.table where each column is a set of types for the
        tokens](#create-a-data.table-where-each-column-is-a-set-of-types-for-the-tokens)
    -   [Corpus size](#corpus-size)
-   [Unmatched tokens](#unmatched-tokens)
-   [Analysis: 1. Comparing manually chosen, specific body part terms +
    “lexical” collocates in 19C quotes
    vs. non-quotes](#analysis-1.-comparing-manually-chosen-specific-body-part-terms-lexical-collocates-in-19c-quotes-vs.-non-quotes)
    -   [Figure 1: Plot of specific, manually chosen body part terms
        +“lexical” collocates in 19C quotes
        vs. non-quotes](#figure-1-plot-of-specific-manually-chosen-body-part-terms-lexical-collocates-in-19c-quotes-vs.-non-quotes)
-   [Analysis: 2. Comparing B1 + all “lexical” collocates in 19C quotes
    vs. non-quotes](#analysis-2.-comparing-b1-all-lexical-collocates-in-19c-quotes-vs.-non-quotes)
    -   [Number of (lexical) types & tokens in B1 &
        examples](#number-of-lexical-types-tokens-in-b1-examples)
        -   [Quotes](#quotes)
        -   [Non-quotes](#non-quotes)
    -   [Concordances of “lexical”
        collocates](#concordances-of-lexical-collocates)
        -   [Concordances: Non-quotes](#concordances-non-quotes)
        -   [Figure 2: Plot of B1 +“lexical” collocates in 19C quotes
            vs. non-quotes](#figure-2-plot-of-b1-lexical-collocates-in-19c-quotes-vs.-non-quotes)
-   [Analysis: 3. Comparing B1 + all semantic types in 19C quotes
    vs. non-quotes](#analysis-3.-comparing-b1-all-semantic-types-in-19c-quotes-vs.-non-quotes)
    -   [Figure 3: Plot of B1 + “semantic tag collocates” in 19C quotes
        vs. non-quotes](#figure-3-plot-of-b1-semantic-tag-collocates-in-19c-quotes-vs.-non-quotes)
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
quotes_files <- list.files("./api-output-sem-tagged/19C/quote_corp_text_objects/", full.names = TRUE)
quotes_objects <- lapply(quotes_files, readRDS)
quotes_text <- corp_text_rbindlist(quotes_objects)

non_quotes_files <- list.files("./api-output-sem-tagged/19C/nonquote_corp_text_objects/", full.names = TRUE)
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

    ## [1] 1695408

Non-quotes

``` r
#Count tokens without the co-occurrence barriers (i.e. ssubset boundaries) _b_ (NA)
sum(non_quotes_text$tokens$token!="_b_", na.rm = TRUE)
```

    ## [1] 2898455

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

Analysis: 1. Comparing manually chosen, specific body part terms + “lexical” collocates in 19C quotes vs. non-quotes
====================================================================================================================

``` r
quotes_text$tokens$type <- with(quotes_type_store, lc_tokens)
quotes_text$tokens$type[is.na(quotes_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers
non_quotes_text$tokens$type <- with(non_quotes_type_store, lc_tokens)
non_quotes_text$tokens$type[is.na(non_quotes_type_store$semantic_tags)] <- NA  # reintroduce the cooccurence barriers

head(quotes_text$tokens, 20)
```

    ##     idx         type start end        token
    ##  1:   1         <NA>    13  15          _b_
    ##  2:   2         <NA>    17  19          _b_
    ##  3:   3         <NA>    21  23          _b_
    ##  4:   4         <NA>    25  27          _b_
    ##  5:   5         <NA>    29  31          _b_
    ##  6:   6          god    33  35          God
    ##  7:   7        grant    37  41        grant
    ##  8:   8           he    43  44           he
    ##  9:   9           be    46  47           be
    ## 10:  10          not    49  51          not
    ## 11:  11 disappointed    53  64 disappointed
    ## 12:  12            i    68  68            I
    ## 13:  13         know    70  73         know
    ## 14:  14          not    75  77          not
    ## 15:  15          how    79  81          how
    ## 16:  16           he    83  84           he
    ## 17:  17        would    86  90        would
    ## 18:  18         bear    92  95         bear
    ## 19:  19           it    97  98           it
    ## 20:  20         <NA>   100 102          _b_

``` r
head(non_quotes_text$tokens, 20)
```

    ##     idx        type start end       token
    ##  1:   1        <NA>    13  15         _b_
    ##  2:   2        <NA>    17  19         _b_
    ##  3:   3        <NA>    21  23         _b_
    ##  4:   4        <NA>    25  27         _b_
    ##  5:   5        <NA>    29  31         _b_
    ##  6:   6         all    33  35         All
    ##  7:   7        true    37  40        true
    ##  8:   8   histories    42  50   histories
    ##  9:   9     contain    52  58     contain
    ## 10:  10 instruction    60  70 instruction
    ## 11:  11      though    73  78      though
    ## 12:  12          in    81  82          in
    ## 13:  13        some    84  87        some
    ## 14:  14         the    90  92         the
    ## 15:  15    treasure    94 101    treasure
    ## 16:  16         may   103 105         may
    ## 17:  17          be   107 108          be
    ## 18:  18        hard   110 113        hard
    ## 19:  19          to   115 116          to
    ## 20:  20        find   118 121        find

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

Figure 1: Plot of specific, manually chosen body part terms +“lexical” collocates in 19C quotes vs. non-quotes
--------------------------------------------------------------------------------------------------------------

``` r
plot(results)
```

![](19C_quotes_non-quotes_files/figure-markdown_github/body_parts_19C_quotes_vs_non_quotes_lexical-1.png)

``` r
plot(results[x=="eyes"])
```

![](19C_quotes_non-quotes_files/figure-markdown_github/eyes_19C_quotes_vs_non_quotes_lexical-1.png)

Analysis: 2. Comparing B1 + all “lexical” collocates in 19C quotes vs. non-quotes
=================================================================================

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

    ## [1] 10600

``` r
# Top 20 frequency of (lexical) types tagged as B1
freq_list <- (as.data.frame(sort(table(quotes_text$tokens[type=="B1"]$token), decreasing = TRUE)))
head(freq_list, 20)
```

    ##      Var1 Freq
    ## 1   heart  899
    ## 2    face  572
    ## 3    eyes  559
    ## 4    hand  557
    ## 5    head  513
    ## 6   hands  400
    ## 7    body  339
    ## 8   blood  328
    ## 9   sleep  282
    ## 10  tired  207
    ## 11   hair  199
    ## 12   born  197
    ## 13   lips  163
    ## 14   back  161
    ## 15    eye  152
    ## 16   feet  147
    ## 17   arms  135
    ## 18     to  135
    ## 19    arm  134
    ## 20 tongue  130

``` r
# All "token types" tagged as B1 in quotes
unique(tolower(a[type == "B1"]$tokens))
```

    ## [1] "tongue, hands, benumbed, sweat, legs, heads, joint, fanny, feet, head, whipping, hand, body, ears, blood, eyes, hearts, face, heart, bodies, born, lips, knee, flesh, eye, breathed, foot, vein, bit, lip, tired, teeth, faces, back, ear, go, to, sleep, bed, arms, nerves, hair, going, torso, nose, throat, bosom, birth, beard, asleep, beards, tired, hearing, arm, tire, napping, mouth, hands, wake, sleepy, snoring, snooze, thirsty, leg, breath, waking, sleeping, snore, neck, shiver, bite, thirst, shoulders, bleeds, goes, bone, skin, cell, blow, out, chest, finger, lick, licking, went, hearts, tongues, pug-nose, shoulder, brains, nap, tears, gore, foreheads, thumb, gnawing, gnaw, gnawed, bones, awoke, breast, limbs, frown, frowned, spitted, complexion, tremulous, bodily, noses, fingers, skull, insensible, sleep, breathe, endurance, slumbers, bleeding, knees, woke, awake, slept, wine-skins, blood, lashes, thirsts, cheeks, eye, limb, sleeps, hunchback, palates, back, breathing, waist, entrails, necks, roused, rouse, elbow, nimble, heads, hand, drowsy, rouse, shivering, nervous, systems, brain, falling, wakes, up, joints, held, my, kidneys, muscular, mouths, digestible, tissue, stomach, flabby, forehead, brow, eyebrows, chin, mole, eyelids, gnaws, backs, tooth, jaw, snap, free, crying, rib, breathless, cheek, bleed, soles, lap, baldness, shivered, breast-pocket, on, all, fours, shivering, gasps, sleepiness, lungs, thumbs, system, nocturnal, toes, facial, cardiac, anatomy, physical, tiptoe, spluttered, half, sucked, nerve, fangs, jaws, sniff, dimples, omnia, frowning, brows, veins, gulping, swallow, forefeet, wrist, wakened, gone, fist, breathing-time, collar-bone, organ, ribs, steeple-chases, bone-, mustache, lash, backbone, unsaid, visage, organs, muscles, swallows, bitten, off, skeleton, consciousness, chests, profile, stay, swallowed, frowns, physique, toe, gasping, hair's-breadth, pregnant, sucks, palm, unborn, bled, pulses, breasts, wince, palate, winces, elbows, sleeping-draught, girt, freckled, unconscious, pulse, steeplechase, ringlets, sucking, lips, in, round, fall, cells, face, breathes, sleepless, awakes, suck, snapped, hairs, wake, sleep-walking, throats, beat, manus, moustache, go, lapping, lapping, tear, spleen, eyelashes, tires, pore, arm., rousing, hymen, body., eye-lashes, thirsting, orb, complexions, agile, gall, licked, put, looks, numbed, ankle, hill-top, disembowelling, anatomical, knuckles, marrow, heel, waken, waked, des, bust, snivel, appanage, palmistry, spue, wrists, doze, furrowed, bloodshot, natal, physically, thirsted, secrete, inhale, gasp, torpor, head, brow, slumber, fast, blue-eyed, wakening, build, spine, kip, black-puddings, blooded, liver, foot, feeler, sacra, biles, awakening, throat, sleeping, looking, hair-dye, awaking, pastern, shoulder-blade, liver-colored, barefoot, lymphatic, sniffs, torpidity, yawning, dozed, beating, freckles, sole, spit, flesh, squat, fallen, scowling, swallowing, skins, sneeze, kidney, spitting, yawns, ankles, shivers, asleep, staying, busts, born, moles, bladders, hump-back, biting, gore, pitchfork, codicil, shins, bald, chins, benumbing, turpin, horsewhipping, stomachs, arteries, sniffing, rump, give, half-asleep, wide, rooms, bleed, eye-lids, look, teething, scowl, pungency, moustachios, contractions, freckles, oral, tibia, orbs, face., bosoms, exhales, fringe, snapping, pallium, tush, room, scowls, dark, haired, lapped, quaffs, quaffed, exuviae, breathest, sleepest, awake, sneezed, gnawest, sinews, unborn, gasped, exhalation, haunch, palms, exigent, eyelid, ear-holes, nimbly, coeur, bums, navel, serous, coeur, cuirass, nucleus, inhaled, belly, ocular, one-eyed, thighs, pouting, kips, calving, corporal, fists, sleepy, birth, ticker, mustachios, heart, arms, bites, baldheaded, spits, blear-eyed, nap, to, jugular, slumbering, panted, eyebrow, hiccup, giveth, breast-bone, proboscis, panting, escutcheon, blink, mustachio, nostrils, eyelash, womb, phalanx, skeletons, artery, behind, perspiration, phlegm, tears, slobbering, slobber, exhale, lacerating, heart-disease, lacerate, snaps, tongue"

### Non-quotes

``` r
b <- corp_type_lookup(non_quotes_text)

# Number of tokens tagged as B1 in non-quotes
nrow(non_quotes_text$tokens[type=="B1"])
```

    ## [1] 36441

``` r
# Top 20 frequency of (lexical) types tagged as B1
freq_list <- (as.data.frame(sort(table(non_quotes_text$tokens[type=="B1"]$token), decreasing = TRUE)))
head(freq_list, 20)
```

    ##       Var1 Freq
    ## 1     face 3236
    ## 2     eyes 3164
    ## 3     hand 2576
    ## 4     head 1852
    ## 5    heart 1838
    ## 6    hands 1345
    ## 7     lips  941
    ## 8      arm  771
    ## 9      eye  757
    ## 10    hair  682
    ## 11    arms  668
    ## 12   tears  633
    ## 13    feet  597
    ## 14    back  534
    ## 15    body  533
    ## 16   sleep  426
    ## 17 fingers  365
    ## 18   mouth  351
    ## 19     ear  346
    ## 20   blood  339

``` r
# All "token types" tagged as B1 in non-quotes
unique(tolower(b[type == "B1"]$tokens))
```

    ## [1] "feet, hands, heart, awoke, head, rouse, gall, body, nerves, hand, tear, eye, waken, eyes, backs, lap, sleep, face, consciousness, swallowed, tears, half-asleep, hair, complexion, numbness, fists, nose, cheeks, fist, went, to, bed, fingers, mouth, ear, arm, shoulder, ears, cheek, put, tire, fanny, spitting, faces, roused, throat, visage, waist, bite, legs, knees, shoulders, nerve, back, hearts, heads, room, crying, go, awake, ringlets, tired, born, yawn, shivered, forehead, eyebrows, brows, breathless, finger, arms, hairs, insensible, unconscious, skin, muscles, palm, brow, skull, breath, sucking, swallow, hearing, tongue, panting, gasping, foot, lip, birth, slumbering, breathed, blood, bodily, busts, bit, yawning, eyelids, elbow, chest, beard, chin, lips, breast, free, fallen, asleep, build, moustaches, thinness, sole, knee, limbs, bosom, dimple, teeth, neck, wrist, pulses, thumbs, pouting, tip-toe, pant, bones, sleeping, mouths, bodies, tremulous, unsay, veins, flesh, endurance, slept, waking, bald, ribs, pouted, physical, corporal, perspiration, hip, slumber, toes, thirst, brains, elbows, thirsty, frown, gone, drowsy, woke, snorts, beards, cell, yawned, going, brain, bosoms, frowns, appanages, stomach, ankles, ankle, joints, bled, backbone, tooth, limb, cheekbone, finger-nails, vein, leg, bone, blow, out, tooth-powder, breathing, joint, shivering, frowned, organ, cuirass, heel, work, furrowed, skeletons, skins, snorting, nostrils, gasped, emaciated, appendage, slumbered, tiptoe, fertility, organs, lung, breasts, exhaled, noses, tongues, bellies, fringes, exhalations, frowning, cadaverous, numbed, entrails, scowling, nerved, dozing, half, slumbers, tan, respiration, shiver, thirsting, erection, bleeding, scowled, mole, bowels, respirations, breaths, gore, tear, barefooted, tears, foreheads, pulse, muscular, lash, sinews, scowl, nocturnal, roused, tendons, torpor, girt, hunchback, nimble, rousing, jaw, skinny, muscle, panted, quaffed, body, breathings, wrists, gnawing, chests, contraction, waists, shoulder-blades, cheek-bones, spine, wake, gasp, frowning, drowsiness, barefoot, breast-pocket, sleepless, head, squat, jaws, half, behind, sleepy, fast, gasps, lungs, exhalation, eyeball, sleep, splutters, creepers, pubic, wincing, perspiring, palms, snoring, gastric, fertilities, eyes, face, champing, freckled, spinal, breathe, spits, hand-glass, physically, hips, skeleton, dozed, scowling, chiffonier, thirsting, up, nervous, system, heart, unready, snapped, beat, sleeps, fall, lips., breathing-time, appendix, blinked, agile, antennae, finger-tips, forearm, creeper, numb, fringe, skin-, fangs, gnaws, profile, falling, freckles, bronzed, profiles, dewlap, sniffing, gnawed, gigot, dimples, births, wince, puckered, body-servant, beard, nap, wakened, swallowing, wakefulness, omnia, pursed, blooded, sneeze, snore, doze, snorted, sleepiness, yawns, ejaculate, wakening, nerving, spitted, headless, digestible, sweat, palm-trees, tanned, puckering, bleed, round, epidermis, metamorphosis, mustache, lashes, physique, thumb, instep, throats, cervical, vertebrae, pregnant, reflex, necks, shins, facial, baldness, look, liver-colored, bitten, benumbing, eyelashes, stayed, benumbed, waked, breathes, rouses, systole, diastole, stolidity, thong, biting, marrow, complexions, winced, corpuscles, eyelash, byssus, sucked, awaked, pout, licking, laps, emaciation, awakening, anatomy, nostril, orbs, nape, eyebrow, guttural, nasal, sleepy-eyed, rib, well-built, retina, bust, finger-tip, hand, arms, awaking, lobe, siesta, nucleus, bladder, chest-voice, eyed, breathing-place, holding, her, well-endowed, kidney, unborn, ocular, palate, pins, and, needles, soles, tissue, teething, beating, toe, swallows, blinking, moue, underlip, inhales, suck, held, his, looking, des, eyeballs, nimbly, sweated, gnaw, hiccoughed, vertebra, snort, moustache, firm, licked, lapped, unwound, belly, woke, sleep-walking, wakes, refraction, sniff, cerebral, awakes, sperm, exhale, overslept, gulped, unconscious, impassiveness, knuckles, looks, drowse, consciousness., eyes., eye-lashes, tan, eye., appendages, collation, pulmonary, birth, given, ligaments, arteries, artery, thirsted, twinkling, flabby, sallowness, in, ringletted, secreted, orb, blink, bosomed, snored, rooms, oral, hill-top, fore-feet, cells, hill-tops, fang, tongues, unshod, keen-eyed, awaking, deglutition, inhale, wake, breasting, on, all, fours, furrowing, fertilised, physically, eyelid, anatomical, balder, splutter, gulp, womb, passage, drowsed, chins, buttocks, inhaled, agility, clot, erections, blood-relation, freckles, harmonium, child-bearing, three-legged, leg-bone, phalanx, biles, wide, hiccuped, eye-balls, wedged, lymphatic, bald-headed, bloodshot, wrist, pastern, escutcheons, blood-shot, spider-like, organ-loft, mustaches, pursing, lacerating, looked, chloroform, one-handed, blood-vessels, pregnancy, foot-sore, wee, quavering, pore, blear-eyed, foot-sore, unsaid, spittings, consciousness, wee, spit, bellied, hair's-breadth, skulls, off, stomachs, miller, stay, star-flowers, blue-eyed, snout, whipping, thumbnail, scalp, bites, hilltops, secrete, appendix, gore, perspire, anatomist, humpback, breathing-space, liver, waking, cranium, sweating, eye-lids, shivers, exhaling, blooding, eye-sockets, nostrils, prickles, unwinding, somnolence, expression, thighs, hold, uncoiling, endurance, moles, impassivity, plasticity, clots, unrolling, tissue-paper, sleeping, unrefreshed, lapping, pitch-fork, tiring, feeler, droppings, gave, coeur, pungency, escutcheon, spleen, collar-bone, endurances, quaffing, heart, breathless, quaff, iron, gnaw, pallium, birth, your, thongs, ears, breathe, hiccups, phlegm., phlegm, saliva, tip-toes, contractions, anatomists, course, childbirth, mustachios, shoeless, hiccupped, phalanx, sniffed, orally, coagulation, hairlike, perspirations, bleeds, hearing, outskirt, fertilization, physiological, black-puddings, tarsus, livers, snores, driven, pores, vitalizations, cusped, visages, faeces, saucer-eyed, one-eyed, frown, hand., foot, coeur, go, lick, knuckles, hand-, eyebrows, inhaling, scutcheon, sniffling, steeplechase, snapping, snoozed, jowls, gulping, cuirasses, beetle-browed, legged, corporal, gulp, gigots, wakens, slept, ticker, gizzard, blowing, secreting, back, whippings, bloods, ringlet, scapulas, haunch, tired, blood-vessel, paunch, mustachio, pricker, proboscis, pitchfork, gored, licks, pyrrhic, under-lip, skinned, snap, lugs, scowls, spat, staying, respired, faces, chiffoniers, sleepy, heart-, lie, collar-bones, winces, born, insensible, spluttered"

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

    ## [ 1]        --- *replied* she, shaking her bright  ringlets in vivacious scorn _b_ _b_ ---              
    ## [ 2]     --- *replied* she, haughtily tossing her    head  ; then, after a moment 's ---                
    ## [ 3]               --- _b_ _b_ _b_ *replied* she,  yawning  _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 4]              --- wine-cup from its master 's    lips  . Sometimes those beneath *replied* with --- 
    ## [ 5] --- *replied*, hesitatingly, and turning her    eyes   away whipped the rhododendron bush ---      
    ## [ 6]      --- *replied* Dorian, moving the screen    back   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 7]                   --- at once, and shook his    head  . With a laugh he *replied* ---              
    ## [ 8]            --- she *replied*, she raised her   finger  and pointed to her forehead ---             
    ## [ 9]                        --- to her in her own   tongue : she *replied* briefly at first, ---        
    ## [10]               --- _b_ Sue *replied*, and her    eyes   filled. _b_ _b_ _b_ _b_ ---                 
    ## [11]              --- and *replied* with a loving   heart   to the boisterous and surprised ---         
    ## [12]          --- _b_ *replied* he, clutching her    arm    to pull her up. _b_ ---                     
    ## [13]        --- evening. The reddleman turned his    head  , and *replied* in sad and ---               
    ## [14] --- *replied* Humphrey, without removing his    eyes   from the fire. He was ---                   
    ## [15]              --- _b_ *replied* the girl. Her    lips   were quivering, and tears so ---            
    ## [16]             --- _b_ *replied* Mrs. Hale, her   cheek   flushing _b_ _b_ _b_ _b_ ---                
    ## [17]        --- *replied* the Doctor, shaking his    head   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [18]             --- *replied* he, drawing up his    head  , and holding it erect _b_ ---               
    ## [19]                  --- _b_ _b_ Ione placed her    hand   in his, but *replied* not ---               
    ## [20]            --- *replied* the priest, and his    face   grew paler _b_ _b_ _b_ ---                  
    ## [21]        --- _b_ _b_ *replied* Elizabeth, with   tears   in her eyes _b_ _b_ ---                     
    ## [22]         --- writing and, without raising his    head  , coolly *replied* _b_ _b_ _b_ ---           
    ## [23]                --- _b_ _b_ _b_ he *replied*,   biting  his lips. Elizabeth hoped she ---           
    ## [24]             --- _b_ he *replied*, biting his    lips  . Elizabeth hoped she had silenced ---       
    ## [25]              --- _b_ _b_ she *replied*, with   tears   in her eyes _b_ _b_ ---                     
    ## [26]               --- *replied* by looking in my    face   and laughing _b_ _b_ _b_ ---                
    ## [27]                  --- _b_ _b_ _b_ *replied* a tremulous voice _b_ _b_ _b_ _b_ ---                   
    ## [28]            --- *replied* only by nodding his    head  . His heart was too full ---                 
    ## [29]      --- George *replied*, showing his white   teeth  , and giving his ambrosial whiskers ---      
    ## [30]          --- *replied* Maria, tossing up her    head  . _b_ _b_ _b_ _b_ _b_ ---                    
    ## [31]                --- all, was trembling on his    lips  , when Emmy *replied* _b_ _b_ ---            
    ## [32]           --- *replied* the boy, finding his   tongue  at last _b_ _b_ _b_ ---                     
    ## [33]    --- _b_ *replied* Catherine, striking one    hand   on her forehead, and the ---                
    ## [34]               --- to himself, screwed up his    nose   and *replied* _b_ _b_ _b_ ---               
    ## [35]         --- _b_ *replied* Jacob, nodding his    head   with an air of gloomy ---                   
    ## [36]              --- asked where she proposed to   sleep   that night. She *replied* that ---

``` r
# returned
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("returned"), context = 0)
y
```

    ## [ 1]               --- as he *returned* through the    back    premises _b_ _b_ _b_ _b_ ---                        
    ## [ 2]                  --- *returned* to the girl 's    heart  , as water to the long-parched ---                   
    ## [ 3]            --- *returned* to her features. Her    eyes    were fixed on the short ---                         
    ## [ 4]         --- _b_ _b_ *returned* Goisvintha with breathless eagerness _b_ _b_ _b_ _b_ ---                       
    ## [ 5]                      --- sigh as he spoke. His    head    *returned* to its old downcast ---                  
    ## [ 6]                --- head drooped, and again his    hands   *returned* mechanically to their old ---            
    ## [ 7]                  --- her mind darkened and her    heart   writhed. Twice she *returned* the ---               
    ## [ 8]                 --- had *returned* to bury the    body    of their chieftain in the ---                       
    ## [ 9]          --- and never *returned*, touched the    heart   of the fast-sinking man as ---                      
    ## [10]              --- more. Mr. Neal 's overhanging  eyebrows  lowered ominously as he *returned* ---              
    ## [11]               --- *returned* to Miss Milroy 's complexion on the instant. She snatched ---                    
    ## [12]              --- and *returned* with a smiling    face    and a side look of ---                              
    ## [13]                  --- _b_ The reflection of her    face    changed slowly. The color *returned* ---            
    ## [14]                --- The color *returned* to her   cheeks  , the delicious languor began to ---                 
    ## [15]            --- *returned* the doctor, with his    hand    to his ear _b_ _b_ ---                              
    ## [16]                --- next they *returned* to the    face    which, at present unaffected by ---                 
    ## [17]   --- *returned* it without speaking, inwardly   wincing  under Lush 's mode of ---                           
    ## [18]                     --- she kissed him on each    cheek  , and he *returned* the kisses. ---                  
    ## [19]                     --- She wrested one of her    hands   from his, and *returned* his ---                    
    ## [20]        --- *returned* his action, pressing his    tears   away _b_ _b_ _b_ _b_ ---                            
    ## [21]                        --- and not to take her    eyes    off her till we *returned*, ---                     
    ## [22]            --- moors, and appearing before the    eyes    of belated travellers. I *returned* ---             
    ## [23]                  --- her hand and examined her    pulse  ; then she *returned* to her ---                     
    ## [24]               --- She *returned*; with her own    hands   cleared her knitting apparatus and ---              
    ## [25]                        --- _b_ _b_ he said. He  swallowed the contents and *returned* it ---                  
    ## [26]               --- _b_ I *returned*, putting my    hands   and my purse behind me ---                          
    ## [27]          --- *returned*, sometimes a good deal    tired  , and not a little weather-beaten, ---               
    ## [28]                  --- said she, and holding his    hand    *returned* to the child with ---                    
    ## [29]                 --- _b_ _b_ _b_ _b_ Thoroughly    tired   at last Sue *returned* to ---                       
    ## [30]                  --- look *returned* to Sue 's    face    when she was alone _b_ ---                          
    ## [31]                 --- she threw herself upon his    neck   , weeping there. He *returned* her ---               
    ## [32]                      --- by the beating of his    fist    on the table, Tom *returned* ---                    
    ## [33]              --- poisoned arrow into Philip 's    heart  , had *returned* to the carriage-house, ---          
    ## [34]                 --- *returned* to the nurse 's     lap   . _b_ _b_ _b_ _b_ _b_ ---                            
    ## [35]            --- _b_ *returned* Bob, nodding his    head    aside _b_ _b_ _b_ _b_ ---                           
    ## [36]              --- leggings had fainted upon the     ear   , Wildeve *returned* to the room ---                 
    ## [37]                --- After this he *returned* on    foot    some part of the way ---                            
    ## [38]                --- which naturally fell to his    hands  , and afterwards *returned* to the ---               
    ## [39]              --- were an unusual exertion. His    face    *returned* into its lines of ---                    
    ## [40]               --- Margaret, -- all were there.    Fanny   had *returned*, screaming up-stairs as ---          
    ## [41]              --- pink colour *returned* to her    lips   , although the rest of her ---                       
    ## [42]      --- she *returned*, carrying Johnnie, his    face    all smeared with eating, and ---                    
    ## [43]         --- merry brightness *returned* to his    eyes   , the lips just parted to ---                        
    ## [44]                --- *returned* to his eyes, the    lips    just parted to suggest the ---                      
    ## [45]             --- _b_ *returned* Pansa, with his    mouth   full of wild boar. _b_ ---                          
    ## [46]                  --- and *returned* it with an     eye    of proud defiance _b_ _b_ ---                       
    ## [47] --- *returned* Arbaces, imperiously waving his    hand    _b_ _b_ _b_ _b_ _b_ ---                             
    ## [48] --- *returned* Arbaces, familiarly leaning his     arm    on the priest 's shoulder ---                       
    ## [49]                --- dragged off the stunned and insensible gladiator, *returned* with rueful countenances. --- 
    ## [50]                   --- had been driven from her    face   , *returned* for half a minute ---                   
    ## [51]                --- as I smiled, his smoothened    brow    *Returned* as glad a smile. ---                     
    ## [52]                  --- has *returned* wet to the    skin   , and has no change of ---                           
    ## [53]                     --- The colour came to her    cheek  ; the deep brightness *returned* to ---              
    ## [54]          --- deep brightness *returned* to her     eye   ; her step that at first ---                         
    ## [55]             --- Her father held her death-cold    hand   ; she *returned* his pressure: her ---               
    ## [56]           --- she *returned* his pressure: her    lips    moved, and still she murmured ---                   
    ## [57]                      --- The blood rose to the    cheek   of Sybil, and then *returned* ---                   
    ## [58]               --- *returned* as quickly to the    heart  ; her trembling hand pressed that ---                
    ## [59]     --- white-coated animals *returned* to the     eye    in rays almost dazzling, even ---                   
    ## [60]                 --- His Majesty 's Regiment of    Foot   , *returned* from yellow fever, in ---               
    ## [61]                  --- these parties were by the    ears   , he might have *returned* and ---                   
    ## [62]      --- four others formed the representative    body    which *returned* the two members ---                
    ## [63]    --- natural spirit and self-possession. The    blood   had *returned* to her hitherto ---                  
    ## [64]            --- *returned* to her hitherto pale    cheek  , and the fire to an ---                             
    ## [65]               --- they saw me *returned*, and,  benumbed  to my very heart, I ---                             
    ## [66]        --- *returned*, peevishly rising to her    feet    _b_ _b_ _b_ _b_ _b_ ---                             
    ## [67]                       --- the world to see his    face    again - that my heart *returned* ---                
    ## [68]                   --- his face again - that my    heart   *returned* to Thrushcross Grange in ---             
    ## [69]                 --- _b_ _b_ Mrs. Heathcliff 's     lip    quivered slightly, and she *returned* ---           
    ## [70]                         --- how he was; he had   fallen   asleep. She *returned*, and asked ---               
    ## [71]                      --- he was; he had fallen   asleep  . She *returned*, and asked me ---                   
    ## [72]                         --- I did, I could not    sleep  . He *returned* after midnight, and, ---             
    ## [73]                  --- his knees, and raised his    hands  , and *returned* thanks that the ---                 
    ## [74]                    --- beach struck cold to my    heart  . I *returned* to the house ---                      
    ## [75]                         --- It fell on my left  shoulder . I *returned* it heavily on ---                     
    ## [76]               --- *returned* it heavily on his    head   . He staggered back and jostled ---                  
    ## [77]                        --- handed it to him at     arm    's length, and *returned* to ---

``` r
# cried
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("cried"), context = 0)
y
```

    ## [  1]        --- helmet-crest suddenly fell at my    feet   , and a voice *cried* to ---              
    ## [  2]     --- _b_ *cried* Goisvintha, seizing the    hand    of Hermanric, and gazing with ---        
    ## [  3]              --- _b_ he *cried*, fixing his    eyes    in furious scorn and indignation ---     
    ## [  4]           --- _b_ _b_ _b_ *cried* Vetranio,   rousing  himself from his short lethargy ---      
    ## [  5]         --- she *cried*, stretching out her   skinny   hand towards Rome _b_ _b_ ---            
    ## [  6]      --- *cried*, stretching out her skinny    hand    towards Rome _b_ _b_ _b_ ---             
    ## [  7]      --- _b_ *cried* Numerian, dropping the    hand    of Antonina, and pointing to ---         
    ## [  8] --- resist it, strengthened her iron-strung   nerves  . She neither *cried* for help ---        
    ## [  9]           --- *cried* Allan, leaping to his    feet   , his ruddy face aflame with ---          
    ## [ 10]        --- *cried* old Pedgift, rubbing his    hands   cheerfully when the servant had ---      
    ## [ 11]          --- _b_ _b_ *cried* Midwinter, his    eyes    aflame, and his hot Creole ---           
    ## [ 12]             --- *cried* at last, waving his    hand    towards the rain-lashed window which --- 
    ## [ 13]             --- _b_ I *cried* with clenched    hands   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 14]                --- first chair that came to    hand   , and *cried* out loud (we ---            
    ## [ 15]               --- gave way, and letting her    head    rest against her mother, *cried* ---     
    ## [ 16]           --- _b_ *cried* Mab, clasping her    hands   and stooping toward Mirah 's ---         
    ## [ 17]         --- of self-change -- confession --  endurance. If she *cried* toward him, ---          
    ## [ 18]            --- the child cries whose little    feet    have fallen backward -- *cried* ---      
    ## [ 19]             --- her, till she stretched her    arms    out straight, and *cried* with ---       
    ## [ 20]           --- *cried* his aunt, shaking her    head    at him. _b_ _b_ _b_ ---                  
    ## [ 21]          --- *cried* the lad, clenching his    fists  . _b_ _b_ _b_ _b_ _b_ ---                 
    ## [ 22]          --- *cried* Dorian, leaping to his    feet    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 23]          --- *cried* the lad, clutching the    arms    of his chair with trembling ---          
    ## [ 24]              --- for sin, nor those smiling    lips    have *cried* out on God ---              
    ## [ 25]        --- _b_ *cried* Dorian, stamping his    foot    on the ground _b_ _b_ ---                
    ## [ 26]         --- *cried* Dorian, starting to his    feet    and walking down the conservatory ---    
    ## [ 27]               --- knees, and raising up her    hands  , *cried* the same words in ---           
    ## [ 28]             --- listens, and leaping to his    feet   , he *cried* out to me ---                
    ## [ 29]                 --- glad look came into his    eyes    as I *cried* out _b_ ---                 
    ## [ 30]                    --- _b_ I *cried* as our    hands   met _b_ _b_ _b_ _b_ ---                  
    ## [ 31]             --- 's shoulder, and laying his    head    on his breast, *cried* for ---           
    ## [ 32]                  --- laying his head on his   breast  , *cried* for a while silently, ---       
    ## [ 33]                       --- a sob he laid his    head    on my shoulder and *cried* ---           
    ## [ 34]                     --- laid his head on my  shoulder  and *cried* like a wearied ---           
    ## [ 35]                --- slept, she woke from her    sleep   and, seeing me, *cried* out ---          
    ## [ 36]           --- _b_ *cried* Emma, putting her    hand    before her face, and jumping ---         
    ## [ 37]       --- *cried* Emma, turning her glowing   cheeks   towards him; for, while she ---          
    ## [ 38]           --- _b_ *cried* Emma, shaking her    head    _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 39]               --- _b_ *cried* I, putting my    hands   before my eyes, for I ---                
    ## [ 40]               --- hellish desires. I put my    hand    before my eyes, and *cried* ---          
    ## [ 41]                   --- put my hand before my    eyes   , and *cried* out in agony ---            
    ## [ 42]              --- father. I stretched out my    hand    to him and *cried* _b_ ---               
    ## [ 43]            --- _b_ *cried* she, tossing her    head    with all its curls, as ---               
    ## [ 44]                --- her little hands from my    neck   ; and I *cried* over her ---              
    ## [ 45]           --- she *cried*, turning away her    face    that he might not see ---                
    ## [ 46]           --- _b_ *cried* Sue, covering her    eyes    with her hand _b_ _b_ ---                
    ## [ 47]                      --- on the turn of her     toe    till Arabella *cried* from the ---       
    ## [ 48]             --- The small child squared its    mouth   and *cried* silently, with an ---        
    ## [ 49]       --- he *cried*, striking his clinched    fist    upon the side of the ---                 
    ## [ 50]            --- _b_ he *cried*, stamping his    foot    upon the frosty ground _b_ ---           
    ## [ 51]      --- she *cried*, suddenly clasping her    hands  , and looking up at the ---               
    ## [ 52]                --- she *cried*, in a faint,  tremulous voice _b_ _b_ _b_ _b_ ---                
    ## [ 53]            --- she *cried*, between her set    teeth   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 54]            --- *cried* my lady, pushing her    hair    fiercely from her white forehead, ---    
    ## [ 55]              --- her, touched the source of    tears  , and he *cried* aloud. Poor ---          
    ## [ 56]            --- could no longer restrain her    tears  , and *cried* aloud in spite ---          
    ## [ 57]              --- and she *cried* herself to    sleep   that night. _b_ _b_ _b_ ---              
    ## [ 58]                   --- very bad wound in his    foot   , and *cried* out so dreadfully ---       
    ## [ 59]     --- *cried* the reddleman, slapping his    hand    against the side of his ---              
    ## [ 60]    --- _b_ _b_ *cried* Eustacia, passionate    tears   in her eyes _b_ _b_ ---                  
    ## [ 61]            --- _b_ he *cried*, pressing his    lips    to her face _b_ _b_ ---                  
    ## [ 62]              --- had staid a minute longer,    Fanny   would have *cried* at his ---            
    ## [ 63]       --- with. His tenderness released her    tears  ; and she *cried* bitterly _b_ ---        
    ## [ 64]         --- stranger who *cried* herself to    sleep   that first night in the ---              
    ## [ 65]               --- _b_ _b_ *cried* Mary, her    eyes    brightening _b_ _b_ _b_ _b_ ---          
    ## [ 66]           --- her having *cried* herself to    sleep  ; when, as they were going ---            
    ## [ 67]   --- *cried* Captain Harville, putting his    hand    on her arm, quite affectionately ---     
    ## [ 68]          --- _b_ *cried* Nydia, casting her    eyes    round the apartment with so ---          
    ## [ 69]           --- _b_ she *cried*, clasping her    hands   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 70]          --- *cried* the girl, wringing her    hands   _b_ _b_ _b_ _b_ _b_ ---                  
    ## [ 71]        --- scream; then, falling before the    feet    of the slave, she *cried*, ---           
    ## [ 72]           --- it fiercely with his clenched    fist   , he *cried* aloud in what ---            
    ## [ 73]             --- _b_ he *cried*, placing his    hands   before his eyes, as to ---               
    ## [ 74]           --- _b_ _b_ *cried* Miss Bingley,    tired   of a conversation in which ---           
    ## [ 75]              --- in the landing place, who, breathless with agitation, *cried* out _b_ ---      
    ## [ 76]             --- and when the other children    awoke   they *cried* bitterly, and begged ---    
    ## [ 77]        --- Retty Priddle *cried* herself to    sleep  . _b_ _b_ _b_ _b_ _b_ ---                 
    ## [ 78]     --- she *cried* fearfully, slipping her    hand    from the glove as from ---               
    ## [ 79]            --- room, and *cried* her little    heart   out. _b_ _b_ _b_ _b_ ---                 
    ## [ 80]                    --- _b_ She held out one    hand   . She *cried* fit to break ---            
    ## [ 81]             --- which Rebecca held down her    head    the more and *cried* bitterly ---        
    ## [ 82]             --- *cried* out, falling on his    neck    and kissing him many times. " ---        
    ## [ 83]                 --- _b_ _b_ Jos clasped his    hands   and *cried* _b_ _b_ _b_ ---              
    ## [ 84]                --- _b_ _b_ *cried* she, her   fingers  tingling to repeat the act, ---          
    ## [ 85]             --- at the stairs'-head, hid my    face    in my hands, and *cried* ---             
    ## [ 86]                       --- hid my face in my    hands  , and *cried* _b_ _b_ _b_ ---             
    ## [ 87]           --- _b_ *cried* he, wrenching his    head    free, and grinding his teeth. ---        
    ## [ 88]          --- *cried* he, wrenching his head    free   , and grinding his teeth. _b_ ---         
    ## [ 89]                      --- _b_ _b_ I wrung my    hands  , and *cried* out; and Mr. ---            
    ## [ 90]       --- *cried*, struggling to release my     arm   , which he had seized: but ---            
    ## [ 91]          --- _b_ _b_ _b_ *cried* Catherine, swallowing her greeting _b_ _b_ _b_ ---             
    ## [ 92]          --- _b_ _b_ _b_ *cried* Catherine,   sucking  her damaged lip, and watching ---        
    ## [ 93]  --- *cried* Catherine, sucking her damaged     lip   , and watching the conflagration with --- 
    ## [ 94]               --- *cried*, and said she was    tired   of living: her life was ---              
    ## [ 95]              --- disturbed when she at last    went    to bed -- she *cried* ---                
    ## [ 96]                   --- when she at last went     to     bed -- she *cried* out ---               
    ## [ 97]                     --- she at last went to     bed    -- she *cried* out in ---                
    ## [ 98]          --- _b_ he *cried*, stretching his    arms    luxuriously _b_ _b_ _b_ _b_ ---          
    ## [ 99]            --- he *cried*, springing to his    feet    with the activity of a ---               
    ## [100]       --- Frenchwomen about me lifted their    hands   in admiration, and *cried* in ---

``` r
# rejoined
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("rejoined"), context = 0)
y
```

    ## [1] --- he *rejoined*, unconsciously pressing her hand closer and closer, in the ---              
    ## [2]         --- again laughed. Then, stamping his foot violently, *rejoined*, perhaps to give ---

``` r
# glancing
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("glancing"), context = 0)
y
```

    ## [ 1]      --- gratified vanity, her smiling blue  eyes , now slyly *glancing* towards her ---            
    ## [ 2]      --- the letter. With quick, *glancing*  eyes , she had made herself mistress ---               
    ## [ 3] --- his chapel, *glancing* with penetrating   eye  at each inhabitant of the ---                    
    ## [ 4]         --- he continued, *glancing* at the  blood on Antonina 's dress, and ---                    
    ## [ 5]               --- said the detective with a shiver, *glancing* round him at the ---                 
    ## [ 6]            --- came in, sleeking down their  hair , and *glancing* shyly about, from ---            
    ## [ 7]                  --- it up, her large brown  eyes  *glancing* bright as a wave-washed ---           
    ## [ 8]            --- admiration, or her full blue  eyes  from *glancing* mildly at her ---                
    ## [ 9]              --- and when on *glancing* her   eye  towards Jane Fairfax she caught ---              
    ## [10]         --- case, with her quick *glancing*  eyes  _b_ _b_ _b_ _b_ _b_ ---                          
    ## [11]                --- look came over Maggie 's  face , and, just *glancing* at Stephen, ---            
    ## [12]          --- looking at him helplessly, her  eyes  *glancing* immediately from him to ---           
    ## [13]              --- of her gown, her wandering  eyes , now *glancing* here, now there, ---             
    ## [14]                    --- _b_ _b_ He shook his  head , *glancing* sideways up at Margaret ---          
    ## [15]               --- of its contents, when his   eye  suddenly *glancing* upon the face ---            
    ## [16]        --- eye suddenly *glancing* upon the  face  of Nydia, he was so ---                          
    ## [17]             --- Arbaces to himself, and his   eye , *glancing* round the amphitheatre, betrayed --- 
    ## [18]      --- not help frequently *glancing* her   eye  at Mr. Darcy, though every ---                   
    ## [19]          --- angel 's forehead; an upraised   arm  and hand, *glancing* like a ---                  
    ## [20]           --- forehead; an upraised arm and  hand , *glancing* like a ray, pointed ---              
    ## [21]                   --- _b_ _b_ Jos waved his  hand , scornfully *glancing* at the same ---           
    ## [22]        --- the Marquess, and *glancing* his   eye  over it with the rapidity ---                    
    ## [23]            --- out, his shoulders bent, his  head  reclined, and his eyes *glancing* ---            
    ## [24]              --- his head reclined, and his  eyes  *glancing* _b_ _b_ _b_ _b_ ---                   
    ## [25]                   --- bent, his head on his  chest, and his eyes *glancing*. The ---                
    ## [26]                   --- on his chest, and his  eyes  *glancing*. The imitation was perfect ---        
    ## [27]                 --- his chin resting on his breast, and his raised eyes *glancing* ---              
    ## [28]              --- his breast, and his raised  eyes  *glancing* _b_ _b_ _b_ _b_ ---                   
    ## [29]                      --- _b_ _b_ _b_ _b_ he gasped, *glancing* up to the frowning ---

``` r
# resting
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("resting"), context = 0)
y
```

    ## [  1]   --- occupied, and *resting* her clenched   hands   on her knees _b_ _b_ ---                      
    ## [  2]           --- the other *resting* with her    head   on his shoulder, Antonina listened ---        
    ## [  3]                   --- to look over it. His    eye   , *resting* idly on the title-page, ---        
    ## [  4]         --- the poor wretch, *resting* his    arms   on the wall and touching ---                  
    ## [  5]            --- his knees, with his clasped   hands   *resting* on the balcony rail. ---            
    ## [  6]           --- the table, and *resting* her   elbow   near it _b_ _b_ _b_ ---                       
    ## [  7]              --- _b_ _b_ _b_ Hermione, her    arm    *resting* on a pillar, was ---                
    ## [  8]        --- into an arm-chair *resting* his   elbows  and fitting his palms and ---                 
    ## [  9]         --- an instant; then *resting* his  fingers  on his hips again, and ---                    
    ## [ 10]           --- *resting* his fingers on his    hips   again, and thrusting out his ---              
    ## [ 11]   --- down the drawing-room, *resting* her   elbow   on one palm while she ---                     
    ## [ 12]             --- *resting* her elbow on one    palm   while she leaned down her ---                 
    ## [ 13]        --- risen again, stretching out one    arm    and then *resting* it on ---                  
    ## [ 14]               --- then *resting* it on her    head  , with a low moan which ---                    
    ## [ 15]     --- the drawing-room at Offendene, one    hand   and elbow *resting* on the ---                
    ## [ 16]             --- at Offendene, one hand and   elbow   *resting* on the back, and ---                
    ## [ 17]             --- and elbow *resting* on the    back  , and the other hand thrust ---                
    ## [ 18]                  --- back to the door, his   hands   *resting* on each other and ---               
    ## [ 19]       --- elevation of pitch, squaring his   elbows  and *resting* a hand on ---                   
    ## [ 20]             --- his elbows and *resting* a    hand   on each knee _b_ _b_ ---                      
    ## [ 21]               --- *resting* a hand on each    knee   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 22]          --- sat astride it, *resting* his   fists   and chin on the back ---                      
    ## [ 23]            --- it, *resting* his fists and    chin   on the back _b_ _b_ ---                       
    ## [ 24]       --- a little distance, *resting* her    arms   slightly on the tall back ---                 
    ## [ 25]              --- on the sea, *resting* her   cheek   on her hand, looking less ---                 
    ## [ 26]             --- *resting* her cheek on her    hand  , looking less shattered than when ---         
    ## [ 27]              --- this big sorrowing man 's    head   *resting* on me, as though ---                
    ## [ 28]               --- _b_ _b_ _b_ *Resting* my    head   on Helen 's shoulder, I ---                   
    ## [ 29]         --- *resting* against it. Two thin   hands  , joined under the forehead, and ---           
    ## [ 30]                --- a man with his clenched   hands   *resting* on his knees, and ---               
    ## [ 31]           --- the bedclothes round her; my   elbow  , *resting* on a corner of ---                 
    ## [ 32]               --- had surprised him -- his    arm    *resting* on the gate, his ---                
    ## [ 33]             --- *resting* on the gate, his    face   directed towards the west. He ---             
    ## [ 34]            --- as he reseated himself, his    eyes   *resting* on the ground as ---                
    ## [ 35]           --- silent, his quaint and weird    face   set, and his eyes *resting* ---               
    ## [ 36]                --- weird face set, and his    eyes   *resting* on things they did ---              
    ## [ 37]                 --- she burst out, and her    eye    *resting* on him a moment, ---                
    ## [ 38]               --- My lady, with her little    hand   *resting* lightly upon the opposite ---       
    ## [ 39] --- that half-recumbent attitude, with her   elbow   *resting* on one knee, and ---                
    ## [ 40]             --- her elbow *resting* on one    knee  , and her perfect chin supported ---           
    ## [ 41]             --- answer. She stood with her   finger  *resting* lightly upon the handle ---         
    ## [ 42]              --- upon the hearth, with his    arm    *resting* upon the chimney-piece _b_ ---      
    ## [ 43]             --- in Figtree Court, with his   elbows  *resting* upon the arms of ---                
    ## [ 44]          --- his elbows *resting* upon the    arms   of his chair, and his ---                     
    ## [ 45]               --- on her little stool, her    head   *resting* on her father 's ---                
    ## [ 46]             --- *resting* on her father 's    knee  , and sleeping as soundly as ---               
    ## [ 47]      --- the bright moonlight without; her    head   *resting* its weariness against the ---       
    ## [ 48]              --- table on which her folded    arms   were *resting*, and her head ---              
    ## [ 49]           --- arms were *resting*, and her    head   was hidden within them. It ---                
    ## [ 50]             --- as if eagerly talking; her    eyes   never *resting* on any object, ---            
    ## [ 51]               --- father sat Job Legh, his    head   in his hands, and *resting* ---               
    ## [ 52]                  --- Legh, his head in his   hands  , and *resting* his elbow on ---               
    ## [ 53]           --- his hands, and *resting* his   elbow   on the little family table, ---               
    ## [ 54]           --- prone and *resting* on their   elbows  something like small sphinxes; and ---        
    ## [ 55]          --- pencil, and was *resting* his    head   on one hand, while Tom ---                    
    ## [ 56]              --- *resting* his head on one    hand  , while Tom was learning forward ---           
    ## [ 57]         --- _b_ he answered, *resting* his    head   on his hand, and looking ---                  
    ## [ 58]              --- *resting* his head on his    hand  , and looking at her as ---                    
    ## [ 59]         --- lean forward, *resting* on her    arms   and moving her feet about, ---                
    ## [ 60] --- Tulliver leaned forward, *resting* his   elbows  on the armchair, and looking ---              
    ## [ 61]           --- _b_ Maggie was *resting* her   elbow   on the table, leaning her ---                 
    ## [ 62]             --- had a good sound *resting*   sleep  . Mr. Hale suggested, that something ---       
    ## [ 63]              --- _b_ _b_ _b_ *Resting* his    hand   upon the house-table, Nicholas Higgins ---    
    ## [ 64]         --- once more in his stretched-out    arms  , *resting* upon the table as ---              
    ## [ 65]              --- leaning his head upon his    hand  , his arm *resting* on his ---                 
    ## [ 66]                --- head upon his hand, his    arm    *resting* on his knee. He ---                 
    ## [ 67]               --- his arm *resting* on his    knee  . He did not get up ---                        
    ## [ 68]            --- spoke. He was *resting* his    head   on his two hands, and ---                     
    ## [ 69]            --- more closely hidden was the    face  , almost *resting* on the table ---            
    ## [ 70]       --- ghastly hag *resting* her deadly    eyes   upon them; yet seemingly serene ---           
    ## [ 71]                 --- minute or two with his    chin   *resting* on his hand, diligently ---         
    ## [ 72]              --- his chin *resting* on his    hand  , diligently occupied in the continued ---     
    ## [ 73]          --- sat looking fixedly down, her    chin   *resting* on her hand, and ---                
    ## [ 74]              --- her chin *resting* on her    hand  , and she did not change ---                   
    ## [ 75]                    --- _b_ _b_ _b_ Here my    eye   , *resting* on the flyleaf of ---              
    ## [ 76]            --- the table and *resting* his    feet   on the empty fire-place _b_ ---               
    ## [ 77]      --- outside girls *resting* round the   waist   of Tess; her arms on ---                      
    ## [ 78]         --- on her three-legged stool, her    face   sideways, her right cheek *resting* ---       
    ## [ 79]           --- her face sideways, her right   cheek   *resting* against the cow, and ---            
    ## [ 80]          --- down, *resting* flat on their foreheads and gazing on the ground, ---                 
    ## [ 81]                  --- she was seated in his    arms   and *resting* against his shoulder ---        
    ## [ 82]         --- arms and *resting* against his  shoulder _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 83]              --- the man 's narrative, her    eyes   *resting* absently on the luggage ---         
    ## [ 84]            --- she waited by *resting* her    hand   on her hip, and her ---                       
    ## [ 85]              --- *resting* her hand on her    hip   , and her elbow against the ---                
    ## [ 86]        --- sheaves, and *resting* upon his   elbow   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 87]               --- *resting* on his wife 's   bosom   _b_ _b_ _b_ _b_ _b_ ---                       
    ## [ 88]           --- Cleveland heard him with his    head   *resting* on both his arms. ---               
    ## [ 89]             --- head *resting* on both his    arms  . He started at the last ---                   
    ## [ 90]                --- from his seat, with his   hands   *resting* on the table, over ---              
    ## [ 91]            --- crossed behind him, and his    chin   *resting* upon his chest, but ---             
    ## [ 92]            --- his chin *resting* upon his   chest  , but his eyes at the ---                      
    ## [ 93]          --- nut almost *resting* upon his    foot  . At length, by well-proportioned degrees, --- 
    ## [ 94]             --- not attempt to disturb the  slumbers of their host. *Resting* his ---              
    ## [ 95]           --- of their host. *Resting* his    feet   on the hobs, his Highness, ---                
    ## [ 96]          --- his heels close together, his    toes   out square, his hands *resting* ---           
    ## [ 97]               --- his toes out square, his   hands   *resting* on his knees, which, ---            
    ## [ 98]           --- arms crossed behind him, his    chin   *resting* on his breast, and ---              
    ## [ 99]              --- his chin *resting* on his   breast , and his raised eyes glancing ---             
    ## [100]               --- lay beneath me, with one    arm    and hand *resting* on the ---                 
    ## [101]                   --- me, with one arm and    hand   *resting* on the white coverlid, ---          
    ## [102]          --- the folded parchment, and his    head   *resting* on his clenched fist. ---           
    ## [103]         --- head *resting* on his clenched    fist  . The Count stood between us ---               
    ## [104]                       --- to feel as if my    hand   was tainted by *resting* on ---               
    ## [105]            --- tainted by *resting* on his    arm   . _b_ _b_ _b_ _b_ _b_ ---                      
    ## [106]                   --- end of the room, her    arms   *resting* wearily on a table, ---             
    ## [107]                   --- at each step with my    foot   before I risked *resting* my ---              
    ## [108]                      --- -- when I saw her    hand   *resting* open on the coverlid, ---           
    ## [109]                   --- on it, with his left    arm    *resting* on the table. The ---

### Figure 2: Plot of B1 +“lexical” collocates in 19C quotes vs. non-quotes

This plot is restricted to effect sizes over 1, i.e. more than twice as
frequent.

``` r
plot(results[abs(effect_size)>1])
```

![](19C_quotes_non-quotes_files/figure-markdown_github/B1_19C_quotes_vs_non_quotes_lexical-1.png)

Analysis: 3. Comparing B1 + all semantic types in 19C quotes vs. non-quotes
===========================================================================

``` r
quotes_text$tokens$type <- with(quotes_type_store, semantic_tags)
non_quotes_text$tokens$type <- with(non_quotes_type_store, semantic_tags)

head(quotes_text$tokens, 20)
```

    ##     idx  type start end        token
    ##  1:   1  <NA>    13  15          _b_
    ##  2:   2  <NA>    17  19          _b_
    ##  3:   3  <NA>    21  23          _b_
    ##  4:   4  <NA>    25  27          _b_
    ##  5:   5  <NA>    29  31          _b_
    ##  6:   6    S9    33  35          God
    ##  7:   7   A9-    37  41        grant
    ##  8:   8    Z8    43  44           he
    ##  9:   9   A3+    46  47           be
    ## 10:  10    Z6    49  51          not
    ## 11:  11 E4.2-    53  64 disappointed
    ## 12:  12    Z8    68  68            I
    ## 13:  13 X2.2+    70  73         know
    ## 14:  14    Z6    75  77          not
    ## 15:  15    Z5    79  81          how
    ## 16:  16    Z8    83  84           he
    ## 17:  17   A7+    86  90        would
    ## 18:  18    M2    92  95         bear
    ## 19:  19    Z8    97  98           it
    ## 20:  20  <NA>   100 102          _b_

``` r
head(non_quotes_text$tokens, 20)
```

    ##     idx   type start end       token
    ##  1:   1   <NA>    13  15         _b_
    ##  2:   2   <NA>    17  19         _b_
    ##  3:   3   <NA>    21  23         _b_
    ##  4:   4   <NA>    25  27         _b_
    ##  5:   5   <NA>    29  31         _b_
    ##  6:   6  N5.1+    33  35         All
    ##  7:   7  A5.2+    37  40        true
    ##  8:   8 T1.1.1    42  50   histories
    ##  9:   9  A1.8+    52  58     contain
    ## 10:  10   Q2.2    60  70 instruction
    ## 11:  11     Z5    73  78      though
    ## 12:  12     Z5    81  82          in
    ## 13:  13     N5    84  87        some
    ## 14:  14     Z5    90  92         the
    ## 15:  15  I1.1+    94 101    treasure
    ## 16:  16    A7+   103 105         may
    ## 17:  17    A3+   107 108          be
    ## 18:  18   O4.5   110 113        hard
    ## 19:  19     Z5   115 116          to
    ## 20:  20   A10+   118 121        find

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

Figure 3: Plot of B1 + “semantic tag collocates” in 19C quotes vs. non-quotes
-----------------------------------------------------------------------------

``` r
plot(results)
```

![](19C_quotes_non-quotes_files/figure-markdown_github/B1_19C_quotes_vs_non_quotes_semantic-1.png)

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

    ## [  1]                  --- my word ! but he *shall*     sweat     for it _b_ _b_ _b_ ---                           
    ## [  2]                    --- *to* tell you about my      eyes    , I was talking about my ---                      
    ## [  3]                --- does steal Miss Rosalie 's     heart    , it *will* only humble her ---                   
    ## [  4]                     --- because it 's not his      vein    . I *'ll* tell you all ---                        
    ## [  5]          --- prejudice *shall* ever escape my      lips    , provided you *will* -- " _b_ ---                
    ## [  6]                 --- and would not *soon* grow     tired     of; and to confess the ---                       
    ## [  7]                   --- man who *shall* lay his     heart     at my feet, and implore ---                      
    ## [  8]                   --- *will* be open to every      eye     ; and that, unless she loses ---                  
    ## [  9]                    --- he clutched her by the      back    , and killed her *in* *a* ---                     
    ## [ 10]                  --- not *going* *to* lose my      head     because I see a fine ---                         
    ## [ 11]                   --- that you *'ll* cut your     throat    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 12]                  --- Gruddock 's gate, at the      back     of the farmyard. We *'ll* ---                    
    ## [ 13]                        --- I hope with all my     heart     that you *will* be happy ---                     
    ## [ 14]                 --- Mamma, I believe I *will*       go      at once to bed _b_ ---                           
    ## [ 15]                       --- I *will* go at once       to      bed _b_ _b_ _b_ _b_ ---                          
    ## [ 16]                      --- *will* go at once to      bed      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 17]                --- well, if possible, I *'ll*       go      to bed _b_ _b_ _b_ ---                           
    ## [ 18]                   --- if possible, I *'ll* go       to      bed _b_ _b_ _b_ _b_ ---                          
    ## [ 19]                   --- possible, I *'ll* go to      bed      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 20]                    --- No. I *shall* never be     tired     of you -- never weary ---                        
    ## [ 21]       --- *will* answer your question boldly.     Tired     of you ! I fancy that ---                        
    ## [ 22]                  --- this moment. And even my     heart     *shall* not blame you for ---                    
    ## [ 23]                   --- none *shall* dare in my    hearing    to speak against you. I ---                      
    ## [ 24]                  --- *'ll* tell you what, his      nose     *will* be out of joint ---                       
    ## [ 25]                         --- it. I have set my     heart     upon it, and *shall* be ---                      
    ## [ 26]                    --- does n't grow under my      feet    . You *wo* n't often find ---                     
    ## [ 27]             --- *tomorrow*; then, if I should       go      to sleep, you know, you ---                      
    ## [ 28]                      --- then, if I should go       to      sleep, you know, you *'ll* ---                   
    ## [ 29]                         --- if I should go to     sleep    , you know, you *'ll* be ---                      
    ## [ 30]                     --- If you really are not     tired    , I think we *will* go ---                        
    ## [ 31]                      --- n't a stitch to your      back    . You *'ll* have company back ---                 
    ## [ 32]                        --- and get rid of the     blood    . I *'ll* be down in ---                          
    ## [ 33]               --- *shall* never be divided in     heart    , my love _b_ _b_ _b_ ---                         
    ## [ 34]               --- to congratulate you on that      head    . So you 're *going* *to* ---                     
    ## [ 35]                  --- they *wo* n't break your      back     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 36]                   --- more *shall* hold up my      head     again _b_ _b_ _b_ _b_ ---                        
    ## [ 37]                 --- not *going* *to* break my      legs     if I know it _b_ ---                             
    ## [ 38]                       --- *'ll* put it in the     hands     of a friend, of course; ---                      
    ## [ 39]              --- the bitter reproaches of his      face     when I *shall* meet him ---                      
    ## [ 40]                          --- as I ask for the      hand     that you *will* not give ---                     
    ## [ 41]                   --- put the affair into the     hands     of my lawyers *tomorrow* morning ---             
    ## [ 42]                      --- you *'ll* know of my     tongue    you *'ll* learn from the ---                     
    ## [ 43]                         --- it has made me so     tired    , and I believe I *'ll* ---                       
    ## [ 44]                     --- and I believe I *'ll*       go      to bed. Do you know ---                          
    ## [ 45]                      --- I believe I *'ll* go       to      bed. Do you know I ---                           
    ## [ 46]                     --- believe I *'ll* go to      bed     . Do you know I do ---                            
    ## [ 47]                      --- _b_ _b_ I fear their     hearts    *will* be cold also _b_ ---                      
    ## [ 48]                     --- lady says she is very     tired    , and *will* lie down till ---                    
    ## [ 49]                        --- ever I blow my own     brains    out I *sha* n't be ---                           
    ## [ 50]                    --- the blame on the wrong   shoulders  . If you *'ll* take my ---                        
    ## [ 51]                        --- _b_ _b_ _b_ _b_ My      head     is splitting, and Sarah *shall* ---              
    ## [ 52]         --- because your heart understands my     heart    . And you *will* not be ---                       
    ## [ 53]                   --- _b_ Lady Julia *wo* n't      bite     her, I know, and I ---                           
    ## [ 54]                         --- at the end of his     thumb    . I was *going* *to* be ---                       
    ## [ 55]         --- *to-morrow*, and Dingles with his   shoulders   smothered with rabbits. And then ---             
    ## [ 56]                      --- Ere long the call to      arms     arose among our nation. *Soon* ---               
    ## [ 57]               --- the softest emotions of the     heart    . It *will* free the prisoned ---                 
    ## [ 58]           --- Here my mutinous slaves *shall*     sleep     after their day 's labour. ---                   
    ## [ 59]               --- are the brutal herd) *will*     sleep     as unconcernedly in their new ---                
    ## [ 60]                       --- _b_ _b_ _b_ _b_ _b_     Sleep     ! It *will* be a most ---                        
    ## [ 61]                --- of the sulphur lake *will*    breathe    Sabian odours for them over ---                  
    ## [ 62]                 --- as these my slaves *will*     sleep     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 63]         --- their repose beneath. They *will*      wake     at an instant 's notice, ---                     
    ## [ 64]                 --- for the *future* about my     bodily    necessities. What would you say ---              
    ## [ 65]                   --- was the guardian of the     heart    ; through me they *shall* see ---                 
    ## [ 66]           --- among another people, until the      arms     of a conqueror *shall* have ---                  
    ## [ 67]                     --- _b_ _b_ Return to his     bosom    ; you *shall* never more be ---                   
    ## [ 68]                 --- on my children 's corpses    bleeding   at my feet ! *Will* a ---                        
    ## [ 69]                 --- 's corpses bleeding at my      feet     ! *Will* a famine that I ---                     
    ## [ 70]           --- innocent and the youthful ! Her     bones     *shall* rot on the plains ---                    
    ## [ 71]                   --- But you *will* shed her     blood     -- you are honourable and ---                    
    ## [ 72]                    --- -- you *will* shed her     blood     ! And I _b_ _b_ _b_ ---                          
    ## [ 73]            --- give you strength; you *shall*     sleep    , and I *will* watch that ---                     
    ## [ 74]            --- *to-morrow* be burnt over your      head    , when we may be staved ---                       
    ## [ 75]              --- withdraw all mercy from your     heart    , she *will* glare upon me ---                    
    ## [ 76]                  --- upon me with her fearful      eyes    , she *will* kill me at ---                       
    ## [ 77]                    --- *will* kill me at your      feet     ! I *shall* die after all ---                    
    ## [ 78]                  --- would say, old sucker of   wine-skins , that he *will* attain the ---                   
    ## [ 79]                       --- _b_ _b_ Show us her      face     ! Whose tent *will* she visit ---                
    ## [ 80]                   --- that she *will* shed my     blood     ! Having none to love me, ---                    
    ## [ 81]                          --- a dog, it is the      hand     of Bacchus that *shall* sever ---                
    ## [ 82]              --- forces which *will* stir the     heart     of every man in your ---                         
    ## [ 83]               --- violence *will* not open my      lips     ! Slay me, you *will* gain ---                   
    ## [ 84]             --- *shall* trample him under our      feet     ! -- this boy, who has ---                       
    ## [ 85]            --- sunshine and peace, *will* any     hearts    among all the glad population ---                
    ## [ 86]                      --- or I *will* rend you      limb     by limb, as I rent ---                           
    ## [ 87]                   --- *will* rend you limb by      limb    , as I rent the stones ---                        
    ## [ 88]                       --- not of it, when she     sleeps   , I *shall* come softly to ---                    
    ## [ 89]                   --- that when she opens her      eyes     they *shall* open on me ---                      
    ## [ 90]                  --- *shall* be written on my     heart     with the name of my ---                          
    ## [ 91]                --- worms *will* prey upon our     bodies   , no hired mourners *will* howl ---               
    ## [ 92]              --- that *shall* now approach my      lips     ! _b_ _b_ _b_ _b_ _b_ ---                        
    ## [ 93]                   --- it has dropped from the     hands     of the rest, *will* fire ---                     
    ## [ 94]               --- the mob *shall* pollute the      body     of my poor boy _b_ ---                           
    ## [ 95]            --- childless *shall* drink of thy     blood     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 96]               --- ones *will* gather round my     knees     again. The living have no ---                    
    ## [ 97]                   --- to the last grain ! The     flesh     of our beasts *shall* be ---                     
    ## [ 98]                  --- *will* think, not of the      body     that is beneath, but of ---                      
    ## [ 99]                           --- _b_ It is in my     hands    . Look ! I *wo* n't trust ---                     
    ## [100]                 --- *future* time with my own      lips    . " I have three objects in ---                   
    ## [101]                      --- a pistol in my right      hand    , ' I said, 'and he *shall* ---                   
    ## [102]                  --- *will* only read in your    hearing   . What remains to be written, ---                 
    ## [103]                    --- locked the door in his      face    . The *next* *minute*, I was ---                  
    ## [104]          --- favorite amusement with his last     breath   . *One* *day* (when I had ---                     
    ## [105]               --- suffered to pass through my     hands    . He *soon* found out enough ---                  
    ## [106]                   --- course; so we *'ll* say     Heads    , the major; Tails, the lawyer. ---               
    ## [107]                        --- _b_ _b_ I *wo* n't       go      to sleep again _b_ _b_ ---                       
    ## [108]                         --- _b_ I *wo* n't go       to      sleep again _b_ _b_ _b_ ---                      
    ## [109]                          --- I *wo* n't go to     sleep     again _b_ _b_ _b_ _b_ ---                        
    ## [110]                       --- I *'ll* show you my     tongue    with pleasure _b_ _b_ _b_ ---                    
    ## [111]                            --- If he is not a      born     idiot he *will* decline to ---                   
    ## [112]                  --- of them *shall* touch my      skin    , I promise you. If you ---                       
    ## [113]                  --- keep me from grinding my     teeth     in my sleep. I *shall* ---                       
    ## [114]                   --- grinding my teeth in my     sleep    . I *shall* break them one ---                    
    ## [115]                    --- For my part, I *shall*      wake     every morning now with the ---                   
    ## [116]                  --- you *'ll* only hold your     tongue    and take yourself off _b_ ---                    
    ## [117]                     --- _b_ I *'ll* drop your      arm      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [118]                 --- to-day, which can give me     heart     and hope for the *future* ---                    
    ## [119]                --- sounds almost absurd in my      ears     (if you *will* pardon me ---                     
    ## [120]                      --- *'ll* stick it in my      ear     . Neelie, my dear, tell him ---                   
    ## [121]                --- I am absolutely dying with     thirst   , I *shall* touch nothing till ---                
    ## [122]                --- _b_ " You *shall* have the    sleeping   drops *to-morrow*. In the meantime, ---          
    ## [123]            --- *shall* throw something at her      head     if we go on much ---                             
    ## [124]                    --- *'ll* help you with my      eyes     open _b_ _b_ _b_ _b_ ---                         
    ## [125]                       --- pray take it; I can     sleep     anywhere. *Will* you have the ---                
    ## [126]                      --- *will* do; I was n't      born     yesterday _b_ _b_ _b_ _b_ ---                    
    ## [127]                    --- *'ll* leave it in your     hands    , sir, with all the pleasure ---                  
    ## [128]                      --- _b_ I say she *will*      snap     her fingers at your letter (---                  
    ## [129]                   --- say she *will* snap her    fingers    at your letter (which was ---                    
    ## [130]                        --- _b_ _b_ _b_ _b_ My     heart     beats so you *'ll* kill ---                      
    ## [131]                    --- *will* show me what my      head     is too weary to calculate ---                    
    ## [132]                       --- I *'ll* go over the     backs     of ten thousand _b_ _b_ ---                      
    ## [133]                     --- I *shall* sit with my      back     to you for the rest ---                          
    ## [134]                   --- be void. ' I *'ll* take     breath    here if you *'ll* allow ---                      
    ## [135]                        --- me out. I *wo* n't    breathe    your name or your father ---                     
    ## [136]                    --- *will* put you on your      legs     again _b_ _b_ _b_ _b_ ---                        
    ## [137]                       --- _b_ _b_ Even my own     hands     *wo* n't serve me to-day ---                     
    ## [138]                  --- already cast out of your     heart     -- which I *will* once ---                       
    ## [139]              --- and Christian hope; and your     heart     *will* turn again to Allan, ---                  
    ## [140]             --- brazen old wretch, wiping her      eyes    . 'Nothing *will* induce me to ---                
    ## [141]                 --- the cabin hatch with your      back    . The vessel *will* float a ---                   
    ## [142]                    --- *will* kill him, by my     hands     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [143]          --- without his feeling anything but   sleepiness . *Will* kill him, and tell ---                   
    ## [144]             --- propitious hour, after she is     awake     *to-morrow* morning. As there is ---             
    ## [145]                    --- and I *'ll* answer for    sleeping   anywhere till *to-morrow* comes _b_ ---          
    ## [146]              --- Good-night; I hope you *'ll*     sleep     as well as I *shall* ---                         
    ## [147]               --- *shall* not bring an aching     heart     with me to your wedding ---                      
    ## [148]                    --- *to* go to London. His     heart     was, I knew, affected, and ---                   
    ## [149]                   --- _b_ _b_ *Shall* we turn      back     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [150]                  --- *will* see with your own      eyes     and judge for yourself _b_ ---                   
    ## [151]                 --- we put something over his      face     he *will* be safe until ---                      
    ## [152]                   --- He *will* have a better     nerve     for the ordeal which he ---                      
    ## [153]                    --- I hope we *shall*, and      lick     those French: but I must ---                     
    ## [154]             --- never comes. " That 's Martha      back     ? No ! I *'LL* go, my ---                        
    ## [155]                     --- the door *will* do my      head     good, and it 's rather ---                       
    ## [156]                 --- _b_ Signor Brunoni had no     beard     -- but perhaps he *'ll* ---                      
    ## [157]                     --- you; it *will* cut my     heart     cruel; but if this baby ---                      
    ## [158]                --- *next* *morning*, I was so     tired    ; and they wanted me to ---                       
    ## [159]                        --- _b_ _b_ Here is an     organ    . I *will* be Saint Cecilia: ---                  
    ## [160]                      --- _b_ Oh, my dear, any      nose     *will* do to be miserable ---                    
    ## [161]                        --- only a lady at the      head    . All the best people *will* ---                  
    ## [162]               --- -- your landlord, you know,     Fanny    . Lady Brackenshaw *will* call upon ---           
    ## [163]                     --- all one and the same,   shoulders   is. If you *'ll* trusten ---                     
    ## [164]                         --- -- and fall at my      feet    . I *shall* laugh at him ---                      
    ## [165]                      --- and the glass in his      eye      *will* cause him to make ---                     
    ## [166]                    --- I *shall* cast down my      eyes     in consequence, and he *will* ---                
    ## [167]                   --- is not addressed to the      ears     of the *future*, I suppose. ---                  
    ## [168]                          --- _b_ _b_ _b_ I am     tired    . And every one *will* be ---                     
    ## [169]                   --- she *will* have no more      face     and action than a singing- ---                   
    ## [170]             --- might rest through the night.     Sleep     must have *soon* come to ---                     
    ## [171]            --- *shall* be comforted. The dear      face     ! -- it is ten years ---                         
    ## [172]                        --- *wo* n't do at the      head     of estates. He has a ---                         
    ## [173]                        --- me what is in your     heart    . I *will* try for anything ---                   
    ## [174]                   --- you think you *will* be     tired     of my company _b_ _b_ ---                        
    ## [175]                     --- as *soon* hold out my     finger    to be bitten off as ---                          
    ## [176]                   --- the profile to the full      face    . But I *shall* enlarge her ---                   
    ## [177]                    --- _b_ _b_ _b_ Agrippa 's      legs     *will* never do _b_ _b_ ---                      
    ## [178]                       --- put a scroll in her     mouth    , else people *will* not understand ---           
    ## [179]                --- *to* speak to Klesmer. Her      face     may come to be very ---                          
    ## [180]                       --- _b_ _b_ With all my     heart    , if it *will* do you ---                         
    ## [181]                --- into money, and the solemn     faces     they *will* break up into ---                    
    ## [182]              --- *shall* know them, and their     heart     *shall* be the tomb of ---                       
    ## [183]                 --- who *will* live when this     breath    is all breathed out _b_ ---                      
    ## [184]                 --- are Jews, and they *will*    breathe    it back poisonously. Can a ---                   
    ## [185]          --- *will* not cherish the prophetic consciousness of our nationality -- let ---                    
    ## [186]                 --- every great nation in its     bosom    : there *will* be a land ---                      
    ## [187]                  --- is a remnant of national consciousness, I suppose nobody *will* deny ---                
    ## [188]              --- is liberated from this weary      body    , it *will* join yours, and ---                   
    ## [189]                    --- in the withering of my      body    . The work *will* be the ---                      
    ## [190]                   --- _b_ _b_ If some mortal,      born     too *soon*, Were laid away ---                   
    ## [191]                 --- was *going* *to* burn the     chest    . But it was difficult to ---                     
    ## [192]                   --- I *will* deliver up the     chest     to him. ' I bowed in ---                         
    ## [193]                   --- my father 's will, your      face     *will* come instead of his ---                   
    ## [194]                      --- can give my soul and      hand     to I *shall* choose to ---                       
    ## [195]                --- *shall* have a true Jewish     heart    . Every Jew should rear his ---                   
    ## [196]                       --- _b_ _b_ _b_ _b_ His      face     *will* not be seen above ---                     
    ## [197]                           --- by me -- a dead      face     -- I *shall* never get ---                       
    ## [198]                    --- I *will* bring you the     chest     forthwith _b_ _b_ _b_ _b_ ---                    
    ## [199]                       --- with a fine head of      hair    , and glances that *will* melt ---                
    ## [200]                --- me: a *future* which these      eyes     *will* not see, and which ---                    
    ## [201]                     --- man 's getting out at     elbows    nobody *will* believe in him. ---                
    ## [202]                 --- pass away as this fleshly      body     *will* pass; but let the ---                     
    ## [203]                         --- is a brand on our     flesh     which *will* not cease smarting. ---             
    ## [204]             --- late Greek sculpture, and the      face     of Dorian Gray *will* some ---                   
    ## [205]              --- soul to their shallow prying      eyes    . My heart *shall* never be ---                   
    ## [206]             --- their shallow prying eyes. My     heart     *shall* never be put under ---                   
    ## [207]                --- _b_ _b_ Perhaps you *will*      tire     *sooner* than he *will*. It ---                  
    ## [208]                 --- value. I think you *will*      tire     first, all the same. Some ---                    
    ## [209]                --- he *will* fall into proper     hands     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [210]                     --- what art should be --  unconscious , ideal, and remote. *One* *day*, ---             
    ## [211]              --- eyelids, the moulding of his     hands     even. Somebody -- I *wo* ---                     
    ## [212]           --- soul, Basil ? Draw that curtain      back    , and you *will* see mine ---                     
    ## [213]              --- How horribly late ! You must      wake     me at nine *to-morrow*. I ---                    
    ## [214]                   --- be lost. How heavy this     chest     is ! I *'ll* take it ---                         
    ## [215]      --- Elizabeth, and consequently they all      fall     asleep after dinner. You *sha* ---               
    ## [216]            --- and consequently they all fall     asleep    after dinner. You *sha* n't ---                  
    ## [217]                          --- _b_ _b_ But I am     tired     to-night, Harry. I *sha* n't ---                 
    ## [218]             --- I am anxiously expecting you.     Sleep     well tonight. At three *tomorrow* ---            
    ## [219]         --- ready, and *tomorrow* you *shall*     sleep     as late as you *will*. ---                       
    ## [220]                  --- *will* not by any chance       go      to sleep in any other ---                        
    ## [221]                     --- to me, but you *will*     sleep    , I pray _b_ _b_ _b_ ---                          
    ## [222]                     --- a lass sittin' on his      lap     . That *wo* n't hurt ye. ---                      
    ## [223]               --- as *soon* after as Jonathan     awakes    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [224]                      --- am full of life, and     sleep     well. You *will* be glad ---                     
    ## [225]                    --- night. Later on we can     sleep    , you and I. I *shall* ---                        
    ## [226]              --- harm befall, you *shall* not     sleep     easy *hereafter* _b_ _b_ _b_ ---                 
    ## [227]                    --- of bad dreams I *will*      wake     you at once _b_ _b_ ---                          
    ## [228]                      --- to me. Then I *will*     sleep     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [229]                 --- not snub that so charming      nose    , or I *shall* point out ---                      
    ## [230]                      --- in a coal cellar. My      eye     , *wo* n't some cook get ---                      
    ## [231]          --- must have another transfusion of     blood    , and that *soon*, or that ---                    
    ## [232]                   --- one who *will* open his     veins     for her _b_ _b_ _b_ ---                          
    ## [233]                    --- _b_ not yet ! Hold her      hand    , it *will* comfort her more ---                  
    ## [234]                   --- I *shall* come when all     sleep    . We *shall* unscrew the coffin ---               
    ## [235]                    --- _b_ A shock, and after     brain     fever so *soon* ! That is ---                    
    ## [236]                   --- You *will* give me your      hand    , *will* you not ? And let ---                    
    ## [237]                      --- 's blood in her poor     veins    , could not live even *one* ---                   
    ## [238]                     --- I *shall* cut off her      head     and fill her mouth with ---                      
    ## [239]                     --- her head and fill her     mouth     with garlic, and I *shall* ---                   
    ## [240]                 --- that *will* make the very      face     of heaven grow black to ---                      
    ## [241]                  --- of America that gave his     blood    . Later we *shall* all have ---                   
    ## [242]                    --- it *will* be a blessed      hand     for her that *shall* strike ---                  
    ## [243]                   --- kiss her. Kiss her dead      lips     if you *will*, as she ---                        
    ## [244]                   --- all who suffer from the     heart    . *Will* you let me be ---                        
    ## [245]            --- affected. The suffusion of the     brain     *will* increase quickly, so we ---               
    ## [246]            --- *shall* operate just above the      ear      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [247]                    --- Give me some water, my      lips     are dry, and I *shall* ---                       
    ## [248]          --- he banqueted heavily, and *will*     sleep     late _b_ _b_ _b_ _b_ ---                         
    ## [249]                 --- had better be quick, with     blood    , for that his ship *will* ---                    
    ## [250]                --- *will* leave the place, of     blood    , before the turn of the ---                      
    ## [251]                    --- to think of, well with     blood     again. For it *soon* became ---                  
    ## [252]                 --- it *shall* be. Quincey 's      head     is level at times, but ---                       
    ## [253]                       --- am thus dead in the     flesh    , then you *will*, without a ---                  
    ## [254]               --- him, then his selfish child     brain     *will* whisper him to sleep. ---                 
    ## [255]               --- brain *will* whisper him to     sleep    . He think, too, that as ---                      
    ## [256]                         --- if it be that she     sleep     all the day, it *shall* ---                      
    ## [257]                      --- and I *will* keep my     spleen    to myself till Christmas brings ---              
    ## [258]                      --- is with; but in good     hands     she *will* turn out a ---                        
    ## [259]                       --- but it is not every      body     who *will* bestow praise where ---               
    ## [260]                --- be committed. -- Your soft      eyes     *shall* chuse their own time ---                 
    ## [261]             --- Woman 's usual occupations of      hand     and mind *will* be as ---                        
    ## [262]                --- be snow very *soon*. Every      body     must have seen the snow ---                      
    ## [263]           --- kind. Yes, *next* *week*. Every      body     is so surprized; and every ---                   
    ## [264]                   --- it. There *will* be the      leg      to be salted, you know, ---                      
    ## [265]                  --- _b_ He *will* have every      body     's wishes for his happiness ---                  
    ## [266]                        --- am sure if Jane is     tired    , you *will* be so kind ---                       
    ## [267]                 --- late. You *will* get very     tired     when tea is over _b_ ---                         
    ## [268]                  --- but you *will* *soon* be     tired    . There *will* be a great ---                     
    ## [269]               --- You *will* not regard being     tired    . You *will* be perfectly safe, ---               
    ## [270]                   --- to look taller than any      body     else. Now I *shall* really ---                   
    ## [271]                     --- I *will* keep as much     awake     as I can; but I ---                              
    ## [272]               --- *will*. It is tenderness of     heart     which makes my dear father ---                   
    ## [273]                       --- walk as if you were     tired    . You *will* not be sorry ---                     
    ## [274]                     --- What *shall* we do to     rouse     them ? Any nonsense *will* serve. ---            
    ## [275]                         --- as ever I open my     mouth    , *sha* n't I ? (looking round ---                
    ## [276]                     --- *will* try to hold my     tongue   . I must make myself very ---                     
    ## [277]                      --- I marry, I hope some      body     *will* chuse my wife for ---                     
    ## [278]          --- you *will* blind yourself'-- for     tears     were in her eyes perpetually. ---                
    ## [279]                   --- Emma -- what *will* any      body     say, when it is known ---                        
    ## [280]          --- thousand for the attentions your     heart     *will* dictate towards her. -- ---               
    ## [281]                      --- Is Mr. Elton gone on      foot     to Donwell ? -- He *will* ---                    
    ## [282]                    --- in an ornament for the      head    . *Will* not it be beautiful ---                  
    ## [283]                   --- I *will* melt the stony     hearts    of your enemies by my ---                        
    ## [284]                     --- of your enemies by my     tears     and prayers. You *shall* not ---                 
    ## [285]                  --- is superior to thine, my     joints    more supple. But I *will* ---                    
    ## [286]                     --- by the promise of her      hand     in marriage so *soon* as ---                     
    ## [287]               --- deep lashes, and her lovely      lips    ; but *presently* my rage returned; ---           
    ## [288]                         --- me base in my own      eyes    . *Shall* I create another like ---               
    ## [289]                      --- the work of your own     hands    . *Shall* I respect man when ---                  
    ## [290]              --- finish until I desolate your     heart    , so that you *shall* curse ---                   
    ## [291]               --- I *shall* deliver into your     hands     a female who *will* accompany ---                
    ## [292]                  --- *will* be with a lighter     heart    , more congenial to your own ---                  
    ## [293]                  --- vice. *Shall* I, in cool     blood    , set loose upon the earth ---                    
    ## [294]                 --- objects of care *will* be      born     to replace those of whom ---                     
    ## [295]               --- the winds. My spirit *will*     sleep     in peace, or if it ---                           
    ## [296]                    --- Then I think I *shall*       go      to bed, for it is ---                            
    ## [297]                      --- I think I *shall* go       to      bed, for it is past ---                          
    ## [298]                     --- think I *shall* go to      bed     , for it is past twelve ---                       
    ## [299]             --- suppose, in the red-room with     crying   ; you *'ll* be better *soon*, ---                 
    ## [300]                     --- _b_ She had better be      put      to bed *soon*; she looks ---                     
    ## [301]                     --- She had better be put       to      bed *soon*; she looks tired: ---                 
    ## [302]                      --- had better be put to      bed      *soon*; she looks tired: are ---                 
    ## [303]                    --- put to bed *soon*; she     looks     tired: are you tired _b_ ---                     
    ## [304]                  --- to bed *soon*; she looks     tired    : are you tired _b_ _b_ ---                       
    ## [305]        --- in *putting* *off* our corruptible     bodies   ; when debasement and sin *will* ---              
    ## [306]                        --- come and sit on my      knee    , *will* you _b_ _b_ _b_ ---                      
    ## [307]                      --- If you have got your      feet     well warmed, I *'ll* show ---                    
    ## [308]                 --- to be given which *shall*     waken     it. You think all existence ---                  
    ## [309]                  --- I *will* fetch Leah, and      wake     John and his wife _b_ ---                        
    ## [310]                 --- *will* not take cold with    sleeping   on the library sofa _b_ ---                      
    ## [311]                          --- _b_ No: I am too    thirsty    to eat. *Will* you let ---                       
    ## [312]                --- your lungs and other vocal     organs   , as they *will* be wanted ---                    
    ## [313]                  --- _b_ _b_ _b_ " Well said,    forehead  ; your declaration *shall* be respected. ---      
    ## [314]                     --- *'ll* seek it at your     hands    ; I promise you that _b_ ---                      
    ## [315]              --- hours: you *will* sponge the     blood     as I do when it ---                              
    ## [316]                     --- and your salts to his      nose    . You *will* not speak to ---                     
    ## [317]               --- *sooner*: he would not have      bled     so much -- but how ---                           
    ## [318]                    --- it *will* give you the     heart     you lack, for an hour ---                        
    ## [319]                    --- *shall* not be able to     sleep    . *Will* you promise to sit ---                   
    ## [320]              --- all the afternoon, and wakes       up      about six or seven. *Will* ---                   
    ## [321]                       --- *will* fit you to a      hair     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [322]                   --- and the circlet on your    forehead  , -- which it *will* become: ---                  
    ## [323]                --- patent of nobility on this      brow    , Jane; and I *will* clasp ---                    
    ## [324]                 --- *shall* have roses in her      hair    ; and I *will* cover the ---                      
    ## [325]                    --- and I *will* cover the      head     I love best with a ---                           
    ## [326]                    --- my hoof, your sylph 's      foot     *shall* step also. Ten years ---                 
    ## [327]                     --- it stood *soon* at my      knee    . I never spoke to it, ---                        
    ## [328]        --- find yourself fettered amongst our     hands    : nor *will* I, for one, ---                      
    ## [329]                      --- *'ll* wear you in my     bosom    , lest my jewel I should ---                      
    ## [330]                   --- my limbs than strain my     heart    ; I *will* go forward and ---                     
    ## [331]           --- eyebrows widely raised over the   bloodshot   eyes. *Shall* I tell you ---                     
    ## [332]          --- widely raised over the bloodshot      eyes    . *Shall* I tell you of ---                       
    ## [333]                   --- when the secrets of all     hearts    *shall* be disclosed), that if ---               
    ## [334]               --- yourself cut off your right      hand    : your heart *shall* be the ---                   
    ## [335]                 --- off your right hand: your     heart     *shall* be the victim, and ---                   
    ## [336]     --- kindness stirred emotion *soon*: your      face     became soft in expression, your ---              
    ## [337]                         --- you tell me to my      face     I *shall* change *soon*. And ---                 
    ## [338]                   --- you *will* vanish ere I     inhale    your fragrance. Oh ! come, Jane, ---             
    ## [339]                    --- _b_ _b_ without it, my     heart     is broken. But Jane *will* ---                   
    ## [340]                    --- *shall* be laid on his   shoulders  , and when the Head of ---                        
    ## [341]                --- *will* be effaced from her     heart    . She *will* forget me; and ---                   
    ## [342]                 --- take the road towards the      head     of Marsh Glen: I *will* ---                      
    ## [343]                --- task, *will* not their own     hearts    be the first to inform ---                       
    ## [344]                     --- Oh ! I *will* give my     heart     to God _b_ _b_ _b_ ---                           
    ## [345]                 --- say you *will* serve your     heart     to God: it is all ---                            
    ## [346]        --- bold battlements *will* strike the      eye      nobly at once, and where ---                     
    ## [347]                        --- I must feel, or my     heart     *will* stop and my brain ---                     
    ## [348]                  --- heart *will* stop and my     brain     burst. Whatever -- whoever you ---               
    ## [349]                --- soft dream, nestling in my      arms     now, you *will* fly, too, ---                    
    ## [350]                   --- *will* make me pull the      hair     out of your head; and ---                        
    ## [351]                     --- just to put your good     heart     at rest, I *will* tell ---                       
    ## [352]                    --- God I *will* never set      eyes     on him again. I bind ---                         
    ## [353]                   --- *Shall* I keep this and     sleep     upon it _b_ _b_ _b_ ---                          
    ## [354]                 --- we *'ll* get this through     hands     at once _b_ _b_ _b_ ---                          
    ## [355]                       --- and to place in his     hands     the drawer that you *will* ---                   
    ## [356]                 --- letter not come into your     hands     until *to-morrow* morning. In that ---           
    ## [357]                     --- now they *wo* n't. My      face     was fatter then _b_ _b_ ---                      
    ## [358]                    --- There 's sommat in our     blood     that *wo* n't take kindly ---                    
    ## [359]                    --- _b_ Now we *'ll* strut      arm      and arm _b_ _b_ _b_ ---                          
    ## [360]                    --- we *'ll* strut arm and      arm      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [361]                --- -- you *'ll* come straight      back    , after a few minutes, *wo* ---                   
    ## [362]                   --- and the folks *will* be      gone     to bed _b_ _b_ _b_ ---                           
    ## [363]                  --- the folks *will* be gone       to      bed _b_ _b_ _b_ _b_ ---                          
    ## [364]                   --- folks *will* be gone to      bed      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [365]                       --- I do. But my wicked     heart     *will* ramble off in spite ---                   
    ## [366]              --- it. Perhaps it *will* *soon*      wake     up, and be generous. I ---                       
    ## [367]             --- Perhaps it *will* *soon* wake       up     , and be generous. I pray ---                     
    ## [368]              --- children 's meal before they      wake    . In fact, I *'ll* go ---                         
    ## [369]                 --- thought you 'd *soon* get     tired     of giving yourself airs and ---                  
    ## [370]                      --- _b_ _b_ Give me your      hand    , and I *'ll* lead you. ---                       
    ## [371]                     --- the muddle out of our     heads    , and we *shall* be as ---                        
    ## [372]                         --- _b_ _b_ Oh yes --    sleeping   quite sound. He *wo* n't ---                     
    ## [373]                  --- quite sound. He *wo* n't      wake     yet _b_ _b_ _b_ _b_ ---                          
    ## [374]                  --- peace since she left his      arms    , and never *will* again till ---                 
    ## [375]                     --- _b_ it *will* do your      head     good _b_ _b_ _b_ _b_ ---                         
    ## [376]                   --- _b_ You are very *soon*     tired     of Audley, Robert _b_ _b_ ---                    
    ## [377]              --- grow old, Phoebe ? *Will* my      hair     ever drop off as the ---                         
    ## [378]                  --- safely in Lady Audley 's     hands    , I *'ll* give you a ---                          
    ## [379]                --- The poor child *shall* not     sleep     another night in this wretched ---               
    ## [380]        --- advantage, sir, while his precious      face     is dirty. I *wo* n't ---                         
    ## [381]                   --- take him out. I *shall*     sleep     here to-night. Good-by, Georgey; take ---        
    ## [382]                  --- *wo* n't go with pitiful     faces     to the stern father, and ---                     
    ## [383]             --- *wo* n't, bless her impulsive     heart     and active mind ! She knows ---                  
    ## [384]             --- dying perhaps, dying upon her     breast    ! What *shall* I do _b_ ---                      
    ## [385]                    --- _b_ _b_ _b_ you *will*      wake     papa. How good of you ---                        
    ## [386]                   --- *will* make her meet my      eyes    , and I *will* read her ---                       
    ## [387]         --- lurking beneath my questions. She     sniffs    the *coming* trouble to her ---                  
    ## [388]       --- you good-evening, ladies. I *shall*     sleep     to-night at Mount Stanning, as ---               
    ## [389]                --- nurse you, dear. You *'ll*       go      to bed very early, *wo* ---                      
    ## [390]                   --- you, dear. You *'ll* go       to      bed very early, *wo* n't ---                     
    ## [391]                     --- dear. You *'ll* go to      bed      very early, *wo* n't you, ---                    
    ## [392]                  --- _b_ Very good. I *shall*       go      to bed at once. Bring ---                        
    ## [393]                   --- Very good. I *shall* go       to      bed at once. Bring me ---                        
    ## [394]                     --- good. I *shall* go to      bed      at once. Bring me a ---                          
    ## [395]                   --- surgeon as *'ll* set my      arm     , I *'ll* give you a ---                          
    ## [396]                    --- _b_ _b_ Now, hold your     tongue   , missis, *will* you _b_ _b_ ---                  
    ## [397]             --- settles his spectacles on his      nose    , and *in* *a* *minute* he ---                    
    ## [398]                        --- *'ll* get a bit of     sleep     lying there, if he 's ---                        
    ## [399]                          --- and get a bit o'     sleep    . John and I *will* watch ---                     
    ## [400]                 --- put the *future* into His     hands    . Afore Christmas time I was ---                  
    ## [401]                   --- *'ll* never hold up his      head     again if he loses Jane. ---                      
    ## [402]                    --- day *will* abide in my     heart    ; and as long as I ---                            
    ## [403]                     --- asleep -- in her last     sleep    . Well, God 's *will* be ---                      
    ## [404]                   --- would never bend at th'     knees    . *In* *a* *minute* she fell ---                  
    ## [405]                     --- _b_ Ay, and a notable      body    , too. I *'ll* just step ---                      
    ## [406]          --- to satisfy your little ambitious     heart    ; so now, *wo* n't you ---                        
    ## [407]            --- mistaken. *Next* *time* came a     sneeze    and cough, and then I ---                        
    ## [408]                  --- _b_ Well, now, you *'ll*    swallow    that, old gentleman. You *'ll* ---               
    ## [409]                   --- Blessed are the pure in     heart    , for they *shall* see God ---                    
    ## [410]                      --- the man who wrongs a      hair     of her head. He *shall* ---                      
    ## [411]                      --- wrongs a hair of her      head    . He *shall* rue it to ---                        
    ## [412]                  --- have, afore we *'ll* set    shoulder   to their work; and they ---                      
    ## [413]                  --- comes sorely back on the     heart     when one thinks one *shall* ---                  
    ## [414]                      --- heard a drag wi' her      leg     , and *presently* a fall, and ---                 
    ## [415]                      --- now for they say her      face     is sadly drawn. He *'ll* ---                     
    ## [416]                --- Harry come in ? Tea *will*     rouse     one up a little. Are ---                         
    ## [417]                       --- I ca n't, nurse. My      head     throbs so, I *shall* be ---                      
    ## [418]                    --- it. Look at her bright      eyes    , she *wo* n't stir. Ay ! ---                     
    ## [419]                    --- th' sound o' his voice     roused    her *in* *a* *minute* _b_ ---                    
    ## [420]                 --- God *shall* wipe away all     tears     from their eyes _b_ _b_ ---                      
    ## [421]                   --- good, for when they set      eyes     on thee, they *'ll* see ---                      
    ## [422]                       --- and one look at thy      face     *will* let 'em into th' ---                      
    ## [423]       --- dear, from your pretty kind-hearted      face    , -- I *'ll* send a ---                           
    ## [424]                         --- and a bit worn at     elbows   , but folk *wo* n't notice ---                    
    ## [425]               --- favour. She *'ll* draw many      feet     of water _b_ _b_ _b_ ---                         
    ## [426]                   --- Come, come, hold up thy      head    . It *will* all end right ---                     
    ## [427]                        --- of. So there 's no    hearing    of her till *to-morrow* morning ---              
    ## [428]                  --- It would happen give her     sleep    , and she *wo* n't have ---                       
    ## [429]                     --- and she *wo* n't have     sleep     for many and many a ---                          
    ## [430]                      --- a night (not to call     sleep    ), if things goes wrong *to-morrow*. ---          
    ## [431]                   --- *will*; so keep up your     heart    . Do n't fret about it. ---                       
    ## [432]                           --- she 's all in a     shiver    with the sea-air. I *'ll* ---                    
    ## [433]                         --- _b_ _b_ I can not     sleep    , thank you. I *will* sit ---                     
    ## [434]                     --- a truer or a tenderer     heart     than yours is, *in* *the* ---                    
    ## [435]                         --- of it as the babe     unborn   . I *'ll* not bless thee ---                      
    ## [436]                --- woe; and repented him with     tears     of blood, and *will* go ---                      
    ## [437]                --- repented him with tears of     blood    , and *will* go through his ---                   
    ## [438]               --- enough for anybody to sleep       in     , be he who he *will*; ---                        
    ## [439]                       --- _b_ _b_ _b_ But her      hair     *wo* n't curl all I ---                          
    ## [440]                      --- my coat off before I       go      to bed. I *shall* give ---                       
    ## [441]                      --- coat off before I go       to      bed. I *shall* give Tom ---                      
    ## [442]                        --- off before I go to      bed     . I *shall* give Tom an ---                       
    ## [443]                      --- *'ll* make him a bit     nimble    with his tongue and his ---                      
    ## [444]                --- please forgive me, Tom; my     heart     *will* break _b_ _b_ _b_ ---                     
    ## [445]              --- biting things, -- they *'ll*      bite     a fellow without being set ---                   
    ## [446]                 --- *'ll* break her mother 's     heart     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [447]             --- horses, and those things, the     heads     and the legs *wo* n't ---                        
    ## [448]                 --- things, the heads and the      legs     *wo* n't come right; though ---                  
    ## [449]              --- yourself; you *'ll* cut your      head     off _b_ _b_ _b_ _b_ ---                          
    ## [450]                       --- the words out o' my     mouth    , -- I was *going* *to* ---                       
    ## [451]                   --- sure you *'ll* have the     blood     in your head, and have ---                       
    ## [452]                   --- you do, *going* *to* my     chest     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [453]                    --- But, you see, the best      hand     in the world *'ll* not ---                       
    ## [454]                        --- _b_ I write a good      hand     enough, and I *'ll* match ---                    
    ## [455]               --- two-and-twenty I 've got my      eye      on now. I *shall* do ---                         
    ## [456]                   --- *'ll* niver lift up his      head     no more, -- I should ---                         
    ## [457]                        --- in. I *'ll* put my      neck     in harness, -- for you ---                       
    ## [458]                   --- I *shall* never hold my      head     up no more. I 'm ---                             
    ## [459]             --- Heigh ! heigh ! keep that dog      back    , *will* you _b_ _b_ _b_ ---                      
    ## [460]                       --- to me with all your     heart    , every obstacle *will* be overcome ---           
    ## [461]                      --- say. I *will* put my      hand     on the Bible if you ---                          
    ## [462]     --- *to-morrow*, then; hold your insolent     tongue    and let me pass _b_ ---                          
    ## [463]               --- blond girl, with round blue      eyes    , who *will* stare at us ---                      
    ## [464]              --- black lace for trimming. Her      arms     *will* look beautiful _b_ _b_ ---                
    ## [465]                 --- I *shall* puzzle my small     brain     to contrive some plot that ---                   
    ## [466]                 --- say; he *'ll* break every      bone     in your body, for your ---                       
    ## [467]                      --- what is wise; but my     heart     *will* not let me do ---                         
    ## [468]                    --- *'ll* let you stay and     sleep     in my bed. He *wo* ---                           
    ## [469]                  --- unproved evil of you; my      lips     *shall* not utter it; my ---                     
    ## [470]                  --- *shall* not utter it; my      ears     *shall* be closed against it; ---                
    ## [471]                 --- have received it from Thy      hand    ; I *will* bear it, and ---                       
    ## [472]                       --- I hope she *wo* n't      wake     till she 's home _b_ ---                         
    ## [473]                   --- look her friends in the      face     *tomorrow* ? It is a very ---                    
    ## [474]                --- _b_ No *sooner* was Andrey     asleep    and the first whiff of ---                       
    ## [475]              --- _b_ _b_ _b_ Grandfather, you       go      in to bed. I *shall* ---                         
    ## [476]                        --- is grow 'd into my      skin     and *wo* n't wash out. ---                       
    ## [477]                       --- A mere look at your      face     *will* show him that something ---               
    ## [478]                 --- with courage bold: If his     blood     's hot I *'ll* make ---                          
    ## [479]                      --- I should n't like to     sleep     where they *will* bide. Dead ---                 
    ## [480]                        --- got one pot of the     bones    , and was *going* *to* bring ---                  
    ## [481]                    --- You *will* go home and     sleep     well; I keep sighing in ---                      
    ## [482]                 --- I *shall* always swear my     flesh     do n't crawl when I ---                          
    ## [483]                      --- _b_ And were you not     tired     the *next* *day* ? I feared ---                  
    ## [484]                          --- _b_ Yes -- he is     awake     -- he *will* go to ---                           
    ## [485]                    --- _b_ _b_ _b_ You *will*       go      to sleep there, I suppose, ---                   
    ## [486]                     --- _b_ _b_ You *will* go       to      sleep there, I suppose, *wo* ---                 
    ## [487]                      --- _b_ You *will* go to     sleep     there, I suppose, *wo* n't ---                   
    ## [488]                     --- _b_ No. I *shall* not     sleep     much till -- another day, ---                    
    ## [489]                   --- Never ! I *'ll* hold my     tongue    like the very death that ---                     
    ## [490]                      --- to be afraid that my      legs     *will* hardly carry me there ---                 
    ## [491]          --- naughty little girl ! you *will*     waken     your mistress. It was only ---                   
    ## [492]                     --- *sha* n't for one. My      eyes     are not so good as ---                           
    ## [493]                  --- which must occupy one 's      head     and heart. I *shall* be ---                      
    ## [494]                    --- occupy one 's head and     heart    . I *shall* be glad to ---                        
    ## [495]                     --- _b_ _b_ _b_ I *shall*      arm      myself with a knife _b_ ---                      
    ## [496]                        --- had it once -- the      back     sitting-room. I think she *will* ---             
    ## [497]           --- *shall* hunger no more, neither     thirst    any more; neither *shall* the ---                
    ## [498]            --- father ! you *shall* ! Oh ! my     heart     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [499]                       --- _b_ _b_ _b_ I *'ll*       go      to bed, -- it 's ---                             
    ## [500]                        --- _b_ _b_ I *'ll* go       to      bed, -- it 's best ---                           
    ## [501]                         --- _b_ I *'ll* go to      bed     , -- it 's best place; ---                        
    ## [502]                   --- I *shall* never see his      face     again -- for if he ---                           
    ## [503]                     --- thing or two in their     heads     which *will* teach the men ---                   
    ## [504]                   --- would be. Now you *'ll*     waken     your mamma, just after she ---                   
    ## [505]                         --- wi' th' tip of my     finger   , I *'ll* come across the ---                     
    ## [506]                  --- *'ll* be pottered in his     brains    how to get 'em done ---                          
    ## [507]                          --- _b_ I lay yo' my     heart     and soul we *'ll* win ---                        
    ## [508]                        --- and I *'ll* may be     sleep    , if th' cough *will* let ---                     
    ## [509]                   --- *will* have a good long     sleep    ; and *to-morrow*, that look which ---            
    ## [510]                   --- on bathing Miss Hale 's    forehead  , *shall* you ? I *shall* not ---                 
    ## [511]                --- ascendency of blood to the      head     as she *'ll* never get ---                       
    ## [512]                 --- *shall* put myself at her      feet     -- I must. If it ---                             
    ## [513]              --- afraid, for missus is nearly     asleep   : but it *will* do nicely ---                     
    ## [514]                    --- *'ll* seem close in my      ear     , and going through me as ---                     
    ## [515]                    --- she said with her last     breath   . You *will* not go _b_ ---                       
    ## [516]                     --- care. I *will* put my      arm      in the bolt *sooner* than ---                    
    ## [517]                    --- this face all wet with     tears     ? I *will* hope. I *will*, ---                   
    ## [518]                  --- Night -- thou *wilt* not      wake     Till I thy fate *shall* ---                      
    ## [519]                    --- _b_ _b_ _b_ You *will*       go      to bed *soon*, papa, *wo* ---                    
    ## [520]                     --- _b_ _b_ You *will* go       to      bed *soon*, papa, *wo* n't ---                   
    ## [521]                      --- _b_ You *will* go to      bed      *soon*, papa, *wo* n't you ? ---                 
    ## [522]                    --- mind, to making men 's     hearts    so hard that they *'ll* ---                      
    ## [523]                  --- it goes again the strong      hand    . But I *'ll* ne'er forswear ---                  
    ## [524]                        --- would. I 'd set my     teeth     into my tongue *sooner* nor ---                  
    ## [525]                      --- set my teeth into my     tongue    *sooner* nor speak i' haste. ---                 
    ## [526]                  --- say, *will* ensure you a    hearing    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [527]               --- to him, with this miserable consciousness upon me; but I *will* ---                        
    ## [528]                    --- *shall* need a deal o'     brains    to settle where my business ---                  
    ## [529]                       --- he took it into his      head     that you -- how *shall* ---                      
    ## [530]         --- have missed ! But courage, little     heart    . We *will* turn back, and ---                    
    ## [531]                   --- my wisdom or my willing     heart     can give, *shall* be hers. ---                   
    ## [532]            --- oven and cooking-places at the      back     of the mill: and *will* ---                      
    ## [533]               --- *will* put matters into the     hands     of my Milton attorney if ---                     
    ## [534]        --- man of business. Nevertheless, his  moustachios  are splendid. There *will* have ---              
    ## [535]                    --- sure you *will* not be     tired     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [536]                      --- it *will* send me to     sleep    , and help my digestion _b_ ---                   
    ## [537]                 --- it as most people. What !     crying   , child ? Nay, now we *'ll* ---                   
    ## [538]                        --- it *will*. I am so     tired     -- so tired of being ---                         
    ## [539]                    --- the fire, and the baby     crying   , you *'ll* begin to wish ---                     
    ## [540]                    --- _b_ _b_ Bear up, brave     heart     ! we *will* be calm and ---                      
    ## [541]               --- really have such a terrible      head     for law business. Henry *will* ---               
    ## [542]          --- whenever Winthrop comes into his     hands    , he *will* make a different ---                  
    ## [543]                        --- Sophy to lend me a      hand    , and we *soon* shifted their ---                 
    ## [544]                     --- I *will*, with all my     heart    , and farther, too. Yes, yes ---                  
    ## [545]              --- very sincere: quite from the     heart    . I *will* give you my ---                        
    ## [546]                        --- _b_ Only give me a    hearing   . You *will* *soon* be able ---                   
    ## [547]                     --- lay no embargo on any      body     's words. If you *will* ---                      
    ## [548]                     --- pen has been in their     hands    . I *will* not allow books ---                    
    ## [549]                   --- *shall* be woven by any     hands     but those of the pretty ---                      
    ## [550]        --- *soon* withers, the perfume *soon*    exhales   . And we, O Glaucus ! strangers ---               
    ## [551]              --- from what regions *shall* my      eyes     open to the true Olympus, ---                    
    ## [552]        --- darkness *shall* vanish, the storm     sleep    , and God Himself, as He ---                      
    ## [553]                  --- art, thou feelest in thy     veins    : that which thou *shalt* be, ---                 
    ## [554]                     --- *will* I, by my right      hand     ! I, too, have taken that ---                    
    ## [555]                     --- _b_ show me then your      face     -- for there I *shall* ---                       
    ## [556]                  --- *about* *to* pray at thy     hands     a boon _b_ _b_ _b_ ---                           
    ## [557]                --- and distressed ! But if my     heart     whispers truly, I *shall* claim ---              
    ## [558]                    --- those words rush to my     heart     -- they *will* have way. ---                     
    ## [559]         --- hand; these characters meet thine      eyes     -- *shall* they be more ---                      
    ## [560]              --- tremble ! I *will* tear thee      limb     from limb _b_ _b_ _b_ ---                        
    ## [561]                --- *will* tear thee limb from      limb     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [562]                      --- _b_ _b_ _b_ If death     frowns    so near, I *will* say ---                        
    ## [563]                   --- tomb rather than to his      arms     ! What ! thinkest thou Arbaces *will* ---        
    ## [564]              --- _b_ _b_ _b_ Thy affectionate     heart     *will* be thy best guide, ---                    
    ## [565]                   --- I declare I *shall* not     sleep     a wink till I see ---                            
    ## [566]             --- thou *shalt* puzzle this dull     brain     all day long, ay, and ---                        
    ## [567]                 --- hear shrill voices at thy      knee    , that *shall* call thee " Lydon ---              
    ## [568]           --- *about* *to* drink his accursed     blood     -- *shall* not a second ---                      
    ## [569]             --- that which *shall* arrest the     heart    , I give that which *shall* ---                   
    ## [570]                --- *shall* sear and blast the     brain     -- which *shall* make him ---                    
    ## [571]                --- which *shall* make him who     quaffs    it unfit for the uses ---                        
    ## [572]                  --- thou *wilt* permit me to     sleep     beneath thy roof, I *will* ---                   
    ## [573]               --- The gods bless thy grateful     heart     ! I *will* answer for Ione ---                   
    ## [574]                    --- After all, the lamp of     Hymen     *will* be gilt, and the ---                      
    ## [575]                       --- Gospel -- and to my     tongue    *shall* descend the rushing Spirit ---           
    ## [576]       --- miraculously vanished, or thy whole      back     *shall* be one pain. And ---                     
    ## [577]         --- Atheist ! away ! the earth *will*    swallow    us, if we suffer these ---                       
    ## [578]                --- hands yet reeking with his     blood    , that they *will* give the ---                   
    ## [579]                    --- *will* dare to touch a      hair     of his head _b_ _b_ ---                          
    ## [580]                    --- they can look upon his      face     -- who *will* be cruel ---                       
    ## [581]                    --- now, I *will* read thy     heart    , and explain its motives) -- ---                 
    ## [582]              --- to, thou *shalt* feast thine      eyes     with the blaze of uncounted ---                  
    ## [583]                  --- place the bowl under thy      feet     -- so. Now thou *wilt* ---                       
    ## [584]             --- thy dying groans *will* never      wake     even the echo of these ---                       
    ## [585]              --- life. Fetter them, and these      lips     *shall* firmly refuse the air. ---               
    ## [586]          --- *will* alarm the house ! Arbaces     sleeps    full lightly. Gag her _b_ ---                    
    ## [587]                   --- must gag thee again. My   shoulders   *will* smart for it, if ---                      
    ## [588]     --- and *to-morrow* without troubling his      head     about a blind girl _b_ ---                       
    ## [589]              --- snatched from us ! our right      arm      is lopped away ! When *will* ---                 
    ## [590]                 --- away, pity ! Reflect O my     heart     -- reflect, for the *future*, ---                
    ## [591]         --- fight, the other *will* gradually     bleed     himself away _b_ _b_ _b_ ---                     
    ## [592]           --- be thus contemned ? *Shall* the     blood     of Apaecides yet cry for ---                     
    ## [593]                     --- -- I *will* tear thee      limb     from limb _b_ _b_ _b_ ---                        
    ## [594]                --- *will* tear thee limb from      limb     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [595]               --- Arise ! follow me ! Take my      hand     ! Glaucus, thou *shalt* be saved ---             
    ## [596]                       --- _b_ _b_ With all my     heart    ; I *will* buy Pemberley itself ---               
    ## [597]           --- reading ! How much *sooner* one     tires     of anything than of a ---                        
    ## [598]                    --- you *will* not mind my     waking    Mr. Hurst _b_ _b_ _b_ ---                        
    ## [599]              --- some filial scruples on that      head    , as you *will* hear _b_ ---                      
    ## [600]                   --- be entitled to. On that      head    , therefore, I *shall* be uniformly ---           
    ## [601]             --- reproach *shall* ever pass my      lips     when we are married _b_ ---                      
    ## [602]                  --- over him much longer, my     heart     *will* be as light as ---                        
    ## [603]           --- have obtained my affections and      hand    , I *shall* *soon* cease to ---                   
    ## [604]                --- those who *will* run their      neck     into a noose without seeing ---                  
    ## [605]                       --- _b_ _b_ _b_ _b_ the     eyelid    *will* flicker, the light-coloured lashes ---    
    ## [606] --- eyelid *will* flicker, the light-coloured     lashes    be lifted a second, and ---                      
    ## [607]                       --- *'ll* go to her bed     tired     and unsuccessful. And the directress ---         
    ## [608]              --- *'ll* see which is *soonest*     tired     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [609]                   --- a treasure after my own     heart    , I *'ll* bring a bull ---                        
    ## [610]              --- sullen, and you would *soon*      tire     of me _b_ _b_ _b_ ---                            
    ## [611]                    --- letting us hold up our     heads     again. I *shall* write to ---                    
    ## [612]                   --- to bed, and they *will*      wake     *soon* _b_ _b_ _b_ _b_ ---                       
    ## [613]                --- piece of calico: he *will*      suck     it; it *will* keep him ---                       
    ## [614]                      --- I *'ll* stand by the      body     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [615]               --- *will* not don a Drury-Lane    cuirass   , so I got this up ---                            
    ## [616]                      --- *to* put one on your      head    , which *will* give you precedence ---            
    ## [617]                --- _b_ _b_ this bargaining of     blood    , and *shall* I call it ---                       
    ## [618]                --- you *will* never give your     heart     or hand to Egremont; -- ---                      
    ## [619]                    --- I *will* never give my      hand     to _b_ _b_ _b_ _b_ ---                           
    ## [620]             --- *shall* shoot you through the      head     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [621]             --- *will* strike terror into the     hearts    of the Capitalists. This is ---                  
    ## [622]                     --- is safe. I *will* not    breathe    it to Gerard. I *will* ---                       
    ## [623]                           --- my soul I am so    thirsty   , that I *'ll* take Chaffing ---                  
    ## [624]                 --- it has been suffering and     tears    . They *will* return, these visions ---           
    ## [625]                   --- have old blood in their     veins    . Before sunset their settlement *will* ---       
    ## [626]                     --- *wo* n't sell his old      body    . When we d'Urbervilles was knights ---           
    ## [627]                   --- he *'ll* never have the     heart     not to love her. But ---                         
    ## [628]                       --- _b_ Do n't touch my      arm      ! We *shall* be thrown out ---                   
    ## [629]                    --- or even on that warmed     cheek    , and I *'ll* stop -- ---                         
    ## [630]                    --- I *'ll* break both our     necks     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [631]                    --- stole over the bull 's      face    . But no *sooner* did William ---                 
    ## [632]                    --- she. 'I *'ll* claw his      face     for'n, let me only catch ---                     
    ## [633]                  --- says he, popping out his      head    . 'I *shall* be churned into ---                  
    ## [634]                   --- hear from your own warm      lips     -- that you *will* some ---                      
    ## [635]                   --- _b_ _b_ Well, the silly      body     should have told en *sooner* ---                 
    ## [636]                     --- or I *'ll* twist your      neck     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [637]                    --- _b_ _b_ You *shall* be      born     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [638]              --- *will* be wrong-doing in the      eyes     of civilization -- Western civilization, ---     
    ## [639]                 --- your hand upon that stone      hand    , and swear that you *will* ---                   
    ## [640]                         --- A devil of a poor      hand     I *shall* make at the ---                        
    ## [641]                        --- I *wo* n't lose my      head    ; I dare not. I own ---                           
    ## [642]                --- last night that we *shall*     sleep     here, dears, in the house ---                    
    ## [643]                       --- *'ll* see if she is     awake     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [644]                  --- the injured boots in one      hand    ; by the other he *shall* ---                     
    ## [645]                 --- near him, with her little     hands     up; and the picture *shall* ---                  
    ## [646]                        --- _b_ _b_ _b_ What a    licking    I *shall* get when it ---                        
    ## [647]                  --- black eye, and a tied-up      head    , vowing he *'ll* have the ---                    
    ## [648]                       --- Do you write a good      hand     ? I *'ll* make you useful ---                    
    ## [649]                         --- -- she must go --     flesh     and blood *wo* n't bear ---                      
    ## [650]                      --- must go -- flesh and     blood     *wo* n't bear it ! and ---                       
    ## [651]                    --- to receive any one. My     nerves    really *wo* n't bear my ---                      
    ## [652]                   --- it *will* break Emmy 's     heart     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [653]                    --- hour. You *'ll* find a      neck     of venison, and no questions ---                 
    ## [654]                    --- you *'ll* see her safe      back     to England; and you *will* ---                   
    ## [655]               --- counsel, and shave off them   mustachios , or they *'ll* bring you ---                     
    ## [656]                 --- offence upon the child 's      head     ? or *will* you forgive the ---                  
    ## [657]              --- dinner, and horses there and      back     *will* cost us twenty pound ---                  
    ## [658]                        --- may tap you on the      head     *to-morrow*, and away go pleasure ---            
    ## [659]                    --- put the affair into my     hands    , and you *shall* act as ---                      
    ## [660]                   --- would box the wretch 's      ears     the *next* *time* you see ---                    
    ## [661]                --- yourself. We must have the     bones     in, or, dammy, I *'ll* ---                       
    ## [662]                      --- love him with all my     heart     now. Oh, I *will*, I ---                         
    ## [663]                        --- I *wo* n't have my      hair     curl, mamma; the boys *will* ---                 
    ## [664]          --- together ? *Shall* I, because my     birth     baulks my fancy, *shall* I ---                   
    ## [665]                   --- me with such a laughing      face    , or else your moral *will* ---                   
    ## [666]                  --- knew him well. Be always     slept     at dinner. *One* *day*, as ---                   
    ## [667]             --- and certainly has much better     lungs     than I have. I *will* ---                        
    ## [668]                      --- you need not hold my     hands    ; I *will* not harm you. ---                      
    ## [669]                 --- and they *will* kiss your      feet    . There is no act of ---                          
    ## [670]               --- their mouths and shut their      eyes    , and see what God *will* ---                     
    ## [671]                   --- but a light and callous     heart     ? *Will* you never be convinced ---              
    ## [672]            --- Within five minutes you *will*    breathe    a beggar and an outcast. ---                     
    ## [673]              --- the Braunfels *will* get his     skull     cracked. Every truth is not ---                  
    ## [674]               --- you *will* perhaps crack my     skull    . Is this a reward for ---                        
    ## [675]                 --- *will* not help you here.     Blood     out of a wall and ---                            
    ## [676]                        --- own box and my own      body    , and I *shall* be at ---                         
    ## [677]                   --- to be indulgent to bold     hearts   , verily, we *will* wink at ---                   
    ## [678]                       --- aid of his own good     palate   , *will*, it is hoped, add ---                    
    ## [679]                   --- *shall* rue it all your      born     days; and as for you, ---                        
    ## [680]                  --- you *shall* taste of its  breast-bone  this morning _b_ _b_ _b_ ---                     
    ## [681]               --- *will* be broken about your      back     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [682]                      --- and I have shed more     blood     for my country in *one* ---                      
    ## [683]               --- name *shall* not profane my      lips    , already tremble. Part of the ---                
    ## [684]          --- name. They were *soon*, however,     roused    from their sorrow and their ---                  
    ## [685]         --- companions in misfortune. But the     thirst    of revenge *will* inscribe the ---               
    ## [686]                  --- fact they *will* make no     bodily    exertion to acquire a constitutional ---         
    ## [687]             --- is my observatory. You *will*     sleep     in that pavilion to-night, so ---                
    ## [688]                     --- how long *will* he be     asleep    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [689]             --- Mr. Beckendorff has been long     awake    , sir ! and dinner *will* be ---                  
    ## [690]           --- then I suppose, stretching your      legs     in your easy-chair, you *will* ---               
    ## [691]                --- my wife would not *sooner*     sleep     in the chimney-corner than thou ---              
    ## [692]                --- got beds now ? You *shall*     sleep     to-night, sir, like an Aulic ---                 
    ## [693]                 --- every day. Though both my      legs     are off, I *'ll* have ---                        
    ## [694]                     --- *shall* not rest if I       go      to bed; so be good ---                           
    ## [695]                  --- I *shall* walk there and      back    : sixty miles each way, that ---                  
    ## [696]                    --- he *'ll* kick out your     brains    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [697]                 --- the race, because she was    barefoot  . You *'ll* have to seek ---                      
    ## [698]                  --- your face and brush your      hair    , it *will* be all right: ---                     
    ## [699]                        --- _b_ _b_ _b_ A good     heart     *will* help you to a ---                         
    ## [700]                  --- He *'ll* be cramming his    fingers    in the tarts and stealing ---                    
    ## [701]                     --- the law into your own     fists     - it *will* give you an ---                      
    ## [702]                 --- how I *shall* pay Hindley      back    . I do n't care how ---                           
    ## [703]                 --- Satan, I *shall* make you    swallow    the carving-knife, Nelly ! You need ---          
    ## [704]                   --- *'ll* break the brat 's      neck     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [705]          --- dreams, Miss Catherine ! I *'ll*       go      to bed _b_ _b_ _b_ ---                           
    ## [706]               --- Miss Catherine ! I *'ll* go       to      bed _b_ _b_ _b_ _b_ ---                          
    ## [707]                 --- Catherine ! I *'ll* go to      bed      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [708]             --- of Wuthering Heights; where I      woke     sobbing for joy. That *will* ---                 
    ## [709]         --- conscience tender of breaking his      neck    . To prevent it, I *shall* ---                    
    ## [710]                    --- _b_ _b_ _b_ his strong      head     *will* keep him from danger; ---                 
    ## [711]                 --- wonder *will* he have the     heart     to find a plausible excuse ---                   
    ## [712]                --- you *will*, unless you are     tired     of being received here, and ---                  
    ## [713]                  --- you possess. No, I *'ll*    swallow    the key before you *shall* ---                   
    ## [714]                    --- no ! I *'ll* crush his      ribs     in like a rotten hazel-nut ---                   
    ## [715]            --- where I grovelled ! Shake your      head     as you *will*, Nelly, you ---                    
    ## [716]                    --- soul *will* be on that    hill-top   before you lay hands on ---                      
    ## [717]                    --- gold too; and then his     blood    ; and hell *shall* have his ---                   
    ## [718]                   --- wring out my kisses and     tears    : they *'ll* blight you - they ---                
    ## [719]                  --- you again before you are     asleep   . I *wo* n't stray five ---                       
    ## [720]                       --- I *'ll* not hold my     tongue    ! " I said; " you must n't ---                   
    ## [721]    --- master *presently* regained motion and consciousness. Heathcliff, aware that his opponent ---         
    ## [722]                      --- wrong ! It 's no use    pouting    and crying: that *wo* n't ---                    
    ## [723]                     --- 's no use pouting and     crying   : that *wo* n't repay the ---                     
    ## [724]                --- do. Come, Nelly, hold your     tongue    - it *will* he a treat ---                       
    ## [725]                     --- they are always in my      ear     . How life *will* be changed, ---                 
    ## [726]                     --- so that I *shall* lie     awake     all night choking with this ---                  
    ## [727]              --- but YOU *'LL* be comfortably     asleep    while I 'm in agony, ---                         
    ## [728]                   --- *'ll* turn our horses '     heads     round when we reach him ---                      
    ## [729]                     --- we should stay. He 's     asleep   , and papa *will* be wanting ---                  
    ## [730]                    --- she *'ll* lend you her      arm     : that 's right, look at ---                      
    ## [731]                       --- or I *'ll* box your      ears    , as he has done your ---                         
    ## [732]                         --- me some tea, I 'm    thirsty   , and then I *'ll* tell ---                       
    ## [733]               --- be miserable: I *shall* not     sleep     for satisfaction. You could have ---             
    ## [734]                    --- He *'ll* think you are     tired     of waiting on him, and ---                       
    ## [735]                   --- live ? I 've given over     crying   : but I 'm *going* *to* ---                       
    ## [736]                  --- *to* kneel here, at your      knee    ; and I *'ll* not get ---                         
    ## [737]                       --- I *'ll* not take my      eyes     from your face till you ---                      
    ## [738]                      --- *'ll* have her in my      arms     again ! If she be cold, ---                      
    ## [739]               --- journeys you take, your own      feet     *will* serve you. Come along ---                 
    ## [740]            --- _b_ you *'ll* leave sufficient     behind    to cover your debts, if ---                      
    ## [741]                      --- or I *'ll* pull your      hair     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [742]                       --- I *'ll* go to hell,      body     and soul, before I look ---                      
    ## [743]                     --- _b_ _b_ *will* be the      back     of the best arm-chair _b_ ---                    
    ## [744]                      --- _b_ I *shall* dry my     tears     in your absence _b_ _b_ ---                      
    ## [745]                    --- and you *will* win his     heart    . Upon my word, if you ---                        
    ## [746]          --- house; but the servants (persons      born     without nerves) *will* encourage the ---         
    ## [747]        --- the servants (persons born without     nerves   ) *will* encourage the children from ---          
    ## [748]          --- construction ! I *will* close my      eyes     again, if you *will* allow ---                   
    ## [749]     --- *shall* slip through his professional    fingers    with our pet feathers of ---                     
    ## [750]                     --- _b_ _b_ You *will* be     tired    , my dear Philip, of hearing ---                  
    ## [751]                   --- thing in Mr. Gilmore 's     hands     *to-morrow* _b_ _b_ _b_ _b_ ---                  
    ## [752]                  --- *will* be placed in safe     hands    . My dear sir, make yourself ---                  
    ## [753]                    --- *will* be placed in MY     hands     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [754]                  --- the devotion of my whole     heart     and soul and strength *will* ---                 
    ## [755]                     --- oh, it *will* ease my     heart     so to end this miserable ---                     
    ## [756]                 --- I *will* wash the clotted      hair     from the wound. I am ---                         
    ## [757]                 --- *shall* doubt if your own      eyes     and ears are really of ---                       
    ## [758]            --- pasteboard, and shows the bare     bones     beneath. I *will* get up ---                     
    ## [759]                        --- have it cast in my     teeth    , at some *future* day, that ---                  
    ## [760]                      --- by his look, that my      face     had betrayed me. 'We *will* ---                  
    ## [761]                   --- you. *Will* you take my      arm      ? You look surprised at seeing ---               
    ## [762]                  --- but I *will* keep within    hearing    of your voice, if anything ---                   
    ## [763]                    --- for the *future* in my     hands     only. I am talking to ---                        
    ## [764]                      --- plans here in my big      head    . You *shall* pay those bills ---                 
    ## [765]                     --- tells you. You are to     sleep     at Fosco 's *to-morrow* night, ---               
    ## [766]                  --- am resolved I *will* not     sleep     to- morrow night under Count ---                 
    ## [767]                  --- the devotion of my whole     heart     and soul and strength *will* ---                 
    ## [768]                 --- _b_ early and late, these     hands     of mine *shall* do _b_ ---                       
    ## [769]                --- going away because you are     tired     of me ? I *will* try ---                         
    ## [770]          --- nothing. No new calamity *shall*    lacerate   your sensibilities -- sensibilities precious --- 
    ## [771]             --- the shirt-sleeve on your left      arm     , and you *will* see it ---

``` r
# Z4 ["Discourse bin"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("Z4"), context = 0)
y
```

    ## [  1]                                         --- of a smile on his      face     ; and he said, " *Oh*, it ---                         
    ## [  2]                                 --- *thing*, jumped on to his      knee     , he only stroked her, and ---                        
    ## [  3]                                      --- _b_ _b_ _b_ from the      hands    , or *rather* the gun, of ---                         
    ## [  4]                                        --- with a book in her      hand     . *However*, I do n't want ---                        
    ## [  5]                                       --- so he thought I was      tired     of him, *I* *suppose*) -- " ---                      
    ## [  6]                                   --- myself up whenever I 'm      tired     --. But *never* *mind*. Let ---                      
    ## [  7]                                   --- _b_ *Yes*, it is stupid      going     to bed _b_ _b_ _b_ ---                               
    ## [  8]                                 --- *Yes*, it is stupid going       to       bed _b_ _b_ _b_ _b_ ---                              
    ## [  9]                              --- *know*, we stupid people can       go       to bed. Mamma, I wish ---                            
    ## [ 10]                                      --- not going to lose my      head      because *I* *see* a fine ---                         
    ## [ 11]                                     --- _b_ _b_ _b_ _b_ *Oh*,      heart     ! There 's nothing of that ---                       
    ## [ 12]                                   --- did n't know where your      heart     was. What *right* had you ---                        
    ## [ 13]                                 --- room and just settle her,      hair     , *you* *know* _b_ _b_ _b_ ---                        
    ## [ 14]                                    --- *No*. I shall never be      tired     of you -- never weary ---                            
    ## [ 15]                                     --- and put it within his       arm     . " *No*, Lily; whatever may be ---                   
    ## [ 16]                              --- 'll *tell* *you* *what*, his      nose      will be out of joint ---                             
    ## [ 17]                                    --- he has n't been caught     napping   , *you* *know*. It does n't ---                       
    ## [ 18]                                      --- did n't you get very      tired     of it ? " *Oh* *dear*, *no*. ---                     
    ## [ 19]                                        --- are half out of my      mouth    . *Of* *course* I know that ---                       
    ## [ 20]                               --- tomorrow; then, if I should       go       to sleep, *you* *know*, you ---                      
    ## [ 21]                                      --- then, if I should go       to       sleep, *you* *know*, you 'll ---                     
    ## [ 22]                                         --- if I should go to      sleep    , *you* *know*, you 'll be ---                        
    ## [ 23]                                       --- says about my -- my     snoring   , *you* *know* _b_ _b_ _b_ ---                        
    ## [ 24]                                    --- _b_ _b_ *Yes*; with my      feet      foremost, and four men carrying ---                  
    ## [ 25]                                   --- It 's better than going       to       sleep under the trees. *Ha*, ---                     
    ## [ 26]                            --- *tell* *you* *the* *truth*, my      hands     have been so full here ---                           
    ## [ 27]                                 --- him. *I* *believe*, in my      heart    , that he still loves me. ---                         
    ## [ 28]                                    --- am *sorry* for you. My      heart     bleeds for you _b_ _b_ ---                           
    ## [ 29]                                 --- *sorry* for you. My heart     bleeds     for you _b_ _b_ _b_ ---                              
    ## [ 30]                                  --- attempt is painful in my      ears     . *I* *think* something of my ---                     
    ## [ 31]                                         --- 'll put it in the      hands     of a friend, *of* *course*; ---                      
    ## [ 32]                                         --- it in a friend 's      hands    , *of* *course* _b_ _b_ _b_ ---                       
    ## [ 33]                                 --- *course* I would. If your      heart     be free now, it must ---                             
    ## [ 34]                                  --- _b_ _b_ Why should their     hearts     be cold ? *Oh*, mamma, that ---                      
    ## [ 35]                               --- her. I wonder what coloured      hair      she has. *I* *suppose* she ---                       
    ## [ 36]                                    --- bark is worse than his      bite     , as *you* *know*, and then ---                       
    ## [ 37]                                  --- prevent her, even if her      heart     permitted it. *Oh* ! dear; it ---                    
    ## [ 38]                                  --- *I* *think*. I am almost      tired    , and I had *rather* not ---                          
    ## [ 39]                                     --- _b_ Lady Julia wo n't      bite      her, I know, and *I* ---                             
    ## [ 40]                                     --- and thanked you in my      heart     for your trusting silence. *Of* ---                  
    ## [ 41]                             --- *I* *suspect* your slaves (so   insensible   to hardships are the brutal ---                      
    ## [ 42]                                       --- _b_ and now, when I      awake    , *I* *see* you before me ---                         
    ## [ 43]                                --- *see* it in your sorrowful      eyes      -- she is coming back ---                            
    ## [ 44]                                      --- will kill me at your      feet      ! I shall die *after* *all* ---                      
    ## [ 45]                                     --- crushed it dead at my      feet      ! And *do* *you* *think* that ---                    
    ## [ 46]                                    --- power of the woman who     thirsts    for my blood ! -- *Oh*, ---                          
    ## [ 47]                                  --- woman who thirsts for my      blood     ! -- *Oh*, it is horrible ---                        
    ## [ 48]                           --- like beasts ! *Aha*, their very      lips      were pale with fear in ---                           
    ## [ 49]                                   --- *see* before me in your      face      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 50]                              --- to pronounce those names, my     tongue     hesitates; *if* *you* *ask* *me* ---                 
    ## [ 51]                                        --- hard as iron in my      hands    , but *I* *think*, by the ---                         
    ## [ 52]                             --- You legal gentlemen are great      hands     at argument. What *do* *you* ---                     
    ## [ 53]                                   --- *course*; so we 'll say      Heads    , the major; Tails, the lawyer. ---                   
    ## [ 54]                            --- seven-and-twenty in any man 's      eyes      living -- except, *of* *course*, ---                 
    ## [ 55]                           --- except, *of* *course*, when you      wake      anxious in the small hours ---                       
    ## [ 56]                                       --- 's this door at the      back      ? Billiard-room and smoking-room, *eh* ? Jolly. ---  
    ## [ 57]                         --- *your* *pardon*, Miss Milroy ! my     tongue     ran away with me that ---                            
    ## [ 58]                          --- you like. Eggs, sausages, bacon,     kidneys   , marmalade, water-cresses, coffee, *and* *so* ---    
    ## [ 59]                                   --- and when she exerts her    muscular    system -- *Ha* ! here 's ---                         
    ## [ 60]                                --- sounds almost absurd in my      ears      (if you will *pardon* me ---                         
    ## [ 61]                                     --- _b_ *I* *see* in your      face     , Mr. Armadale _b_ _b_ _b_ ---                        
    ## [ 62]                                --- steward 's books. Come and     breathe    freely in the *blessed* open ---                     
    ## [ 63]                                  --- my dear fellow, with the      tears     in her eyes ! *Of* *course*, ---                     
    ## [ 64]                                      --- *I* *see* it in your      face     . Come ! what is it _b_ ---                           
    ## [ 65]                                   --- 're welcome to put your      arms      round me *if* *you* *like* ---                       
    ## [ 66]                               --- *I* *believe* with my whole      heart     and soul to be a ---                                 
    ## [ 67]                                  --- think of my feeling this   breathless   interest in another man. *Oh*, ---                   
    ## [ 68]                                      --- the first word on my      lips     . *Oh*, dear, how old I ---                           
    ## [ 69]                                --- *They* *say* girls have no      heads     for business. Have n't they ! ---                    
    ## [ 70]                                 --- thing ! I must clear your      head     , *of* *course*, at any sacrifice. ---                
    ## [ 71]                                  --- betwixt us, has his true      heart    . *Please* to *pardon* my not ---                     
    ## [ 72]                             --- me ! ' *Yes* ! the seeing his      eyes      moisten, the hearing his voice ---                   
    ## [ 73]                    --- Pimlico. Upsetting Mother Oldershaw 's     nerves    , *in* *the* *first* *place*, and ---                 
    ## [ 74]                                   --- still. *I* *see* my own      hand      while I write the words ---                          
    ## [ 75]                                    --- *it* *is*, to turn the      head      of any Private in the ---                            
    ## [ 76]                                  --- already cast out of your      heart     -- which I will *once* ---                           
    ## [ 77]                                 --- *case*, while we have our       eye      on her, we have, for ---                             
    ## [ 78]                              --- one fine morning Mr. Waldron      woke      up with a doubt *in* ---                             
    ## [ 79]                             --- fine morning Mr. Waldron woke       up       with a doubt *in* *his* ---                          
    ## [ 80]                                  --- *Oh*, Jemmy, feel how my      heart     beats ! Here is the hotel ---                        
    ## [ 81]                                      --- *I* *see* it in your      face      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 82]                                  --- *see* here open under my      feet      ? How can I tell ? Where ---                         
    ## [ 83]                                 --- *you* for showing me your      hand     . ' _b_ _b_ _b_ _b_ _b_ " ---                         
    ## [ 84]                              --- exhibit him favorably in the      eyes      of the world; *in* *the* ---                         
    ## [ 85]                                    --- out. *I* *see* in your      face      that you bring me news ---                           
    ## [ 86]                              --- *your* *pardon*, with all my      heart     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 87]                             --- apoplexy or congestion of the      lungs     ! What *do* *you* *think* of ---                     
    ## [ 88]                                      --- _b_ _b_ _b_ *Oh*, my     fingers    and thumbs _b_ _b_ _b_ ---                           
    ## [ 89]                                  --- _b_ *Oh*, my fingers and     thumbs     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [ 90]                                      --- found it out in your      face      yesterday. *I* *see* it in ---                       
    ## [ 91]                                      --- *I* *see* it in your      face      now. Why did you sign ---                            
    ## [ 92]                                 --- be delivered into his own      hand     . If absent, *please* return wire ---                 
    ## [ 93]                                      --- _b_ _b_ _b_ You have      arms     , *I* *suppose* _b_ _b_ _b_ ---                       
    ## [ 94]                                 --- the chance of having your     throat     cut. *You* *see*, it is ---                          
    ## [ 95]                                      --- _b_ _b_ Quite in the      back      row, *eh* ? But her brother ---                      
    ## [ 96]                                 --- and *thank* *you* from my      heart     ! It would have killed my ---                        
    ## [ 97]                            --- not making an absolutely clean     breast     of all that *you* *know*. ---                        
    ## [ 98]                                      --- are the marks of its      fangs     ? *Of* *course* we know that ---                     
    ## [ 99]                                 --- was going *right*, by her      face     . And it did go *right* ---                           
    ## [100]                             --- never comes. " That 's Martha      back      ? *No* ! I 'LL go, my ---                            
    ## [101]                                       --- the door will do my      head      good, and it 's *rather* ---                         
    ## [102]                          --- *please*, hush ! Mrs Jamieson is     asleep     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [103]                              --- and, *thank* *God*, when the      neck      of mutton, and Martha 's ---                         
    ## [104]                             --- the contrary, *I* *think* her   complexion   one of her chief charms. ---                         
    ## [105]                                 --- was a prettier mouth, the      lips      curled backward so finely, *eh*, ---                 
    ## [106]                                    --- _b_ *Oh*, my dear, any      nose      will do to be miserable ---                          
    ## [107]                                       --- so slow. She has no       ear      for music, or language, *or* ---                     
    ## [108]                           --- -- your landlord, *you* *know*,      Fanny    . Lady Brackenshaw will call upon ---                 
    ## [109]                                    --- but handy, and set the       arm      for him immediately. So *after* ---                  
    ## [110]                                         --- _b_ _b_ *Oh* I am      tired     of them all in the ---                               
    ## [111]                                   --- is not addressed to the      ears      of the future, *I* *suppose*. ---                    
    ## [112]                                   --- be an Englishman to the    backbone    *after* *all* _b_ _b_ _b_ ---                        
    ## [113]                                    --- can see the soldiers '      faces    : *no*, it is more than ---                           
    ## [114]                                --- *think* my life began with     waking     up and loving my mother ---                          
    ## [115]                                       --- *Ah*, I am sure her      heart     has been heavy for want ---                          
    ## [116]                                   --- It is *right* that your      eyes      should be open to it. ---                            
    ## [117]                                       --- _b_ I am *sorry* to      wake      you, darling, but I thought ---                      
    ## [118]                                --- to know anything about his      birth    ; *you* *see*, he is very ---                         
    ## [119]                                  --- show of passion into his      face      and speech. *I* *'m* *afraid* ---                    
    ## [120]                             --- *I* *think* everybody who has      ears      would benefit by a little ---                        
    ## [121]                         --- intensify. But *never* *mind* the      legs      now: the third sketch in ---                         
    ## [122]                              --- _b_ *By* *the* *by*, Klesmer     frowns     a good deal _b_ _b_ ---                              
    ## [123]                                       --- We are going to the      Hand      and Banner, *I* *suppose*, and ---                   
    ## [124]                                 --- heroes -- *yea*, when the      hand      was hacked off, they clung ---                       
    ## [125]                                  --- is a remnant of national  consciousness, *I* *suppose* nobody will deny ---                  
    ## [126]                              --- has the *sort* *of* handsome    physique    that the Duke ought to ---                           
    ## [127]                                    --- _b_ _b_ *Ah*, the dear      head     , the dear head _b_ _b_ ---                           
    ## [128]                             --- *Please* give my brother your      hand      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [129]                                --- began. *You* *see* my gray      hair     , my worn look: it has ---                            
    ## [130]                                 --- Anna: but *I* *think* his      hair      is dark. ' That was her ---                          
    ## [131]                            --- *suppose* you are beginning to      tire      of it. Women are so ---                              
    ## [132]                                 --- *all* my struggles and my     crying    , the hatred and rage, the ---                        
    ## [133]                                        --- had the rope in my      hand      -- *no*, there he was ---                            
    ## [134]                                       --- Try to rest: try to      sleep    . And may *I* *see* you ---                           
    ## [135]                                  --- deep upright line in his      brow     . *I* *see* none of that ---                          
    ## [136]                                        --- _b_ _b_ *Oh*, I am      tired     of sitting, and I do ---                             
    ## [137]                            --- *yes*, horrid people with dyed      hair      and painted faces _b_ _b_ ---                        
    ## [138]                         --- their dust into consciousness, to      wake      their ashes into pain. *My* ---                      
    ## [139]                                    --- _b_ The same flesh and      blood     as one 's self ! *Oh*, ---                           
    ## [140]                                 --- has always poppies in her      hands    . *Of* *course*, now and then ---                     
    ## [141]                                 --- *like*. Put ashes on your      head      because Cordelia was strangled. Cry ---              
    ## [142]                                    --- *sorry* to have had to      wake      you up, Francis _b_ _b_ ---                          
    ## [143]                             --- feet of clay. White porcelain      feet     , *if* *you* *like*. They have ---                    
    ## [144]                           --- these dreadful things. Hetty 's      heart     is not broken. *Of* *course*, ---                    
    ## [145]                                --- long weeds catching in his      hair     . Do *you* *know*, I do ---                           
    ## [146]                                   --- did *you* *see* with my      eyes      and know with my knowledge, ---                      
    ## [147]                                --- though *I* *suppose* I was     asleep    , passing through the streets and ---                 
    ## [148]                                     --- duty. Then he took my      hand      in his, and *oh*, Lucy, ---                          
    ## [149]                             --- *I* *say* " Pouf ! " ' And he     snapped    his fingers at me and ---                            
    ## [150]                                       --- lift you so that to     swallow    is easy. *Yes* _b_ _b_ ---                           
    ## [151]                                   --- and hang him round your      neck     , so you sleep well. *Oh*, ---                        
    ## [152]                                   --- round your neck, so you      sleep     well. *Oh*, *yes* ! They, like ---                   
    ## [153]                                       --- I tries on with the       ear      scratchin'. *Mind* *you* _b_ _b_ ---                 
    ## [154]                                   --- 'ard, cold look and red      eyes     , and I took a *sort* ---                             
    ## [155]                                --- mouth full of white, sharp      teeth    . 'Oh *no*, they would n't ---                        
    ## [156]                              --- the attendants, Hardy, had a     finger     broken. *However*, I set it ---                      
    ## [157]                                     --- head and take out her      heart    . *Ah* ! You a surgeon, and ---                       
    ## [158]                                     --- me, I work with heavy      heart     and feel *oh* so lonely ---                          
    ## [159]                                    --- Why, Mina, have I been     asleep     ! *Oh*, do forgive me for ---                        
    ## [160]                                     --- and with his hair and      eyes      the same. " There, *you* *know* ---                  
    ## [161]                                      --- carry with him to my      cheek    . *Oh*, friend John, it is ---                        
    ## [162]                              --- the tune he play. *Bleeding*     hearts    , and dry bones of the ---                            
    ## [163]                          --- play. *Bleeding* hearts, and dry      bones     of the churchyard, and tears ---                     
    ## [164]                                --- permanence by a shock. His      brain     and his heart are *all* ---                          
    ## [165]                                  --- shock. His brain and his      heart     are *all* *right*, this I ---                        
    ## [166]                     --- materialization. *No* ? Nor in astral     bodies    . *No* ? Nor in the reading ---                       
    ## [167]                                      --- she was in a trance,  sleep-walking, *oh*, you start. You do ---                         
    ## [168]                                    --- it will be a *blessed*      hand      for her that shall strike ---                        
    ## [169]                                   --- every thought of my own      heart     in this cause. But, *of* ---                         
    ## [170]                                 --- through the medium of his      blood    , relying *of* *course*, upon the ---                 
    ## [171]                                    --- gifted, and a woman 's      heart    . The *good* *God* fashioned her ---                  
    ## [172]                                 --- _b_ *I* *think*, sir, his      back      is broken. See, both his ---                         
    ## [173]                                      --- of an accident. So I      woke      Quincey or *rather* called for ---                   
    ## [174]                                 --- Or before my poor crushed      brain     dies *anyhow*. *Thank* *you* ! It ---                
    ## [175]                                    --- is it ? What does that      blood     mean ? *My* *God*, *my* *God* ! ---                  
    ## [176]                                --- I must either suffocate or     swallow    some to the... *Oh*, *my* ---                        
    ## [177]                                    --- _b_ _b_ Hush ! Go back       to       bed. It is *all* *right*. ---                        
    ## [178]                                     --- _b_ Hush ! Go back to       bed     . It is *all* *right*. One ---                        
    ## [179]                                    --- they have been no more     thirsty   . *They* *say* much of blood ---                      
    ## [180]                             --- thirsty. *They* *say* much of      blood     and bloom, and of others ---                         
    ## [181]                                 --- dear, *I* *see* that your      eyes      are opened, and that to ---                          
    ## [182]                                --- *see* with those so bright      eyes      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [183]                              --- 's illness, *right* into the      jaws      of his deathtrap ? Not for ---                       
    ## [184]                          --- success, *you* *know* ! -- Every      body      said that Mr. Weston would ---                       
    ## [185]                        --- features, open countenance, with a   complexion   ! *oh* ! what a bloom of ---                         
    ## [186]                                     --- *right* in any man 's      eyes      as I am in my ---                                    
    ## [187]                                   --- *Oh* ! my dear sir, her     throat     is so much better that ---                           
    ## [188]                                   --- about her, a quick, low      pulse    , &amp;c. and she was *sorry* ---                     
    ## [189]                           --- _b_ *Oh*, Mrs. Churchill; every      body      knows Mrs. Churchill _b_ _b_ ---                     
    ## [190]                                  --- *and* *so* *on* to every      body     , having that general information on ---              
    ## [191]                             --- kind. *Yes*, next week. Every      body      is so surprized; and every ---                       
    ## [192]                                     --- it. There will be the       leg      to be salted, *you* *know*, ---                      
    ## [193]                                    --- I would not expose any      body      to. *However*, as they are ---                       
    ## [194]                                 --- _b_ _b_ *Thank* *you* for     rousing    me _b_ _b_ _b_ _b_ ---                               
    ## [195]                             --- much *rather* hear you. Every      body      last night said how well ---                         
    ## [196]                                  --- And, by the *bye*, every      body      ought to have two pair ---                           
    ## [197]                        --- workmen, *I* *suppose*, hold their     tongues   ; but we gentlemen labourers if ---                   
    ## [198]                                --- _b_ *Ah* ! -- (shaking his      head     ) -- the uncertainty of when ---                      
    ## [199]                              --- over; for *they* *say* every      body      is in love once in ---                               
    ## [200] --- the clearest-headed, longest-sighted, best-judging female    breathing  . *Oh* ! the coldness of a ---                        
    ## [201]                               --- is which *rather* hurts the       ear     . But I believe I am ---                              
    ## [202]                                       --- _b_ _b_ _b_ _b_ any      body      may know how highly *I* ---                          
    ## [203]                                 --- _b_ *Oh* ! my dear, human      flesh     ! You quite shock me; if ---                         
    ## [204]                                --- *I* *suppose*, that she is      tired     of Enscombe. She has now ---                         
    ## [205]                                       --- walk as if you were      tired    . You will not be *sorry* ---                         
    ## [206]                          --- little baskets *hanging* *on* my       arm     . Here, -- probably this basket ---                   
    ## [207]                                --- very true. What a thinking      brain     you have ! *I* *say*, Jane, ---                      
    ## [208]                                       --- *I* *see* it in her      cheek    , her smile, her vain attempt ---                     
    ## [209]                             --- arm wreaked on your miserable      head      ? Begone, vile insect ! Or *rather*, ---             
    ## [210]                        --- always replenished by an invisible      hand     . In the day, *I* *believe*, ---                      
    ## [211]                            --- She fell, *however*, into good      hands    . The Italian had mentioned the ---                   
    ## [212]                                    --- I even raised my humid      eyes      with thankfulness towards the *blessed* ---          
    ## [213]                           --- *suppose*, in the red-room with     crying    ; you 'll be better soon, ---                         
    ## [214]                                 --- *I* *dare* *say* your own      hands     are almost numbed with cold. ---                     
    ## [215]                                --- a foreigner, and Adela was      born      on the Continent; and, *I* ---                       
    ## [216]                                     --- *I* *see* now on your    shoulders   _b_ _b_ _b_ _b_ _b_ ---                              
    ## [217]                                   --- *suppose* I have all my      limbs     and all my features like ---                         
    ## [218]                                      --- has done me good: my      heart     was a *sort* *of* charnel; ---                       
    ## [219]                           --- was returning: *of* *course* my      heart     thumped with impatience against the ---              
    ## [220]                                  --- _b_ _b_ _b_ The servants      sleep     so far off, *you* *know*, ---                        
    ## [221]                           --- dark and clear; noble features;      eyes      *rather* like Mr. Rochester 's: ---                  
    ## [222]                               --- me *in* *my* *opinion*. The       eye      is favourable. " As to the ---                       
    ## [223]                              --- earn gratitude, not to wring      tears     of blood -- *no*, nor ---                            
    ## [224]                                     --- not to wring tears of      blood     -- *no*, nor of brine: ---                           
    ## [225]                                 --- *Yes*, sir, *yes*; and my       arm      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [226]                               --- *yes* ! do n't trouble your      head      about her -- put the ---                             
    ## [227]                                     --- as you like. You were      born     , *I* *think*, to be my ---                           
    ## [228]                              --- coming from Millcote, and on      foot      ? *Yes* -- just one of ---                           
    ## [229]                                    --- take Miss Ingram to my      bosom    , *in* *short* (she 's an ---                         
    ## [230]                    --- and experienced a strange, *regretful*  consciousness of some barrier dividing us. ---                     
    ## [231]                           --- that sentence has penetrated my     breast     painfully. Why ? *I* *think* because ---             
    ## [232]                                --- waking, a gleam dazzled my      eyes     ; I thought -- *Oh*, it ---                           
    ## [233]                                   --- _b_ Did *you* *see* her      face      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [234]                                --- would *rather* you did not      sleep     alone: promise me to go ---                          
    ## [235]                                --- you to accompany Mr. Mason      back     ; but *as* *it* *is*, I ---                           
    ## [236]                                   --- all ! *I* *see* a white      cheek     and a faded eye, but ---                             
    ## [237]                                      --- eye, but no trace of      tears    . *I* *suppose*, then, your heart ---                 
    ## [238]                          --- tears. *I* *suppose*, then, your      heart     has been weeping blood _b_ ---                       
    ## [239]                                        --- to do to draw your     breath    ; *in* *the* *second* *place*, you ---                
    ## [240]                                   --- Jane, *I* *see* by your      face      you are not forming a ---                            
    ## [241]                                     --- you will vanish ere I     inhale     your fragrance. *Oh* ! come, Jane, ---               
    ## [242]                                    --- _b_ She has a peculiar      face     ; fleshless and haggard *as* *it* ---                 
    ## [243]                                 --- speak truth, St. John, my      heart     *rather* warms to the poor ---                       
    ## [244]                                   --- wark, *I* *see* by your      hands     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [245]                                   --- of a priest: *yes*, the      heart     of a politician, of a ---                            
    ## [246]                                     --- to be counted, -- are      born      into my world full-grown. *I* ---                    
    ## [247]                                     --- *Oh* ! I will give my      heart     to God _b_ _b_ _b_ ---                               
    ## [248]                                --- trust, is willing, but the      flesh    , *I* *see*, is weak. I ---                           
    ## [249]                             --- soft: it *cheers* my withered      heart    ; it puts life into it. ---                           
    ## [250]                                 --- _b_ *Yes*; with the right       eye      *I* *see* a glow -- ---                              
    ## [251]                                    --- ever to the point. His      brain     is first-rate, *I* *should* *think* ---              
    ## [252]                                    --- _b_ _b_ _b_ *Yes*; the      back      parlour was both his study ---                       
    ## [253]                                 --- superstition I have in my      blood    , and always had: *nevertheless*, this ---            
    ## [254]                                       --- *Ay*, I must put my    shoulder    to the wheel if Jekyll ---                           
    ## [255]                                       --- Hyde. I give you my      hand      upon that; and I *thank* ---                         
    ## [256]                                    --- *God* I will never set      eyes      on him again. I bind ---                             
    ## [257]                                  --- cabinet, it went down my      spine     like ice. *Oh*, I know ---                           
    ## [258]                                --- rest ! *Ah*, sir, there 's      blood     foully shed in every step ---                        
    ## [259]                                 --- letter not come into your      hands     until to-morrow morning. *In* *that* ---             
    ## [260]                                   --- me wash the innerds for black-puddings *and* *such* *like* _b_ _b_ ---                      
    ## [261]                                      --- is ours, and send un      back     . *Oh* *dear*, how hot I ---                          
    ## [262]                             --- and *bloody* ! Just touch the      vein     , that 's all. I was ---                              
    ## [263]                              --- parents upon a tombstone, my      heart     melts with compassion; when *I* ---                  
    ## [264]                                       --- to let you try your      hand      in his school ? *If* *you* ---                       
    ## [265]                                 --- _b_ *No*. But putting his       arm      round your waist _b_ _b_ ---                         
    ## [266]                                --- *mean* the synopsis at the      head      of each chapter, explaining away ---                 
    ## [267]                                         --- _b_ _b_ _b_ I was     asleep    , *I* *think* _b_ _b_ _b_ ---                         
    ## [268]                             --- caring whether she breaks her      neck      or *no*, she 's not ---                              
    ## [269]                                        --- *say*, I am only a     feeler    , not a reasoner _b_ _b_ ---                          
    ## [270]                                    --- do her the kindness of     hearing    what 's the matter, *I* ---                          
    ## [271]                                    --- I always had plenty of      flesh     on my bones. *However*, I ---                        
    ## [272]                                     --- plenty of flesh on my      bones    . *However*, I am staying down ---                    
    ## [273]                                   --- _b_ _b_ You are getting      tired    , Sue. *Oh* -- I forgot, ---                          
    ## [274]                              --- *Yes*, poor little fellow --      born      in lawful wedlock, *thank* *God*. ---                
    ## [275]                                     --- set me *right* in the      eyes      of the clergy and orthodox ---                       
    ## [276]                                     --- hour -- here with one      foot      in the grave ! ... Come, *please* ---                
    ## [277]                                         --- _b_ _b_ _b_ He 's    sleeping    nicely, *thank* *you* _b_ _b_ ---                    
    ## [278]                               --- place ... Well, how is he ?    Sleeping    well still ? *Of* *course*, we ---                   
    ## [279]                                     --- _b_ _b_ *Oh* *yes* --    sleeping    quite sound. He wo n't ---                           
    ## [280]                                    --- us beyond our power of    endurance  . *I* *see* all things, perhaps, ---                  
    ## [281]                     --- the prettiest, most coquettish little      hand      I ever saw. Do *you* ---                             
    ## [282]                                 --- this silly freak into her      head     . *I* *dare* *say* she was ---                        
    ## [283]                                   --- stoop down, and pat the      head      of every *good-for-nothing* cur in ---               
    ## [284]                                       --- you an offer of his      hand     , *eh* _b_ _b_ _b_ _b_ ---                            
    ## [285]                                    --- it. *Oh*, you need n't      frown     at me to stop my ---                                 
    ## [286]                               --- an atmosphere of crime, and     breathe    *none* *the* *less* freely. I ---                    
    ## [287]                                 --- _b_ *Ah*, *you* *know* my      hand     , *of* *course* _b_ _b_ _b_ ---                       
    ## [288]                                  --- chile 'way, *er* wash 's      face      ? D'yer want to ruin me ? ---                        
    ## [289]                               --- *sorry*, and beats his poor    forehead    so _b_ _b_ _b_ _b_ ---                               
    ## [290]                                        --- he takes me in his      arms     , and says, 'Oh, my *blessed* ---                     
    ## [291]                              --- not loud, *you* *know*; only      tears     running down his poor cheeks, ---                    
    ## [292]                                     --- take him out. I shall      sleep     here to-night. *Good-by*, Georgey; take ---          
    ## [293]                              --- a delicate impression of his      foot      under my right eye. *Yes*, ---                       
    ## [294]                                   --- his foot under my right       eye     . *Yes*, I 'm getting old ---                         
    ## [295]                              --- *Heaven* *knows* I was never      born      to be the avenger of ---                             
    ## [296]                                --- halo *you* *see* round the      head      of a Madonna in an ---                               
    ## [297]                                  --- *all*. That slow lump of    torpidity   he calls his heart can ---                           
    ## [298]                                 --- of torpidity he calls his      heart     can beat, *I* *suppose*, once ---                    
    ## [299]                                    --- place ? He has gone to      sleep     at Mount Stanning, then, *I* ---                     
    ## [300]                             --- anything to-night, so you may       go       to bed when you *please* ---                         
    ## [301]                                   --- to-night, so you may go       to       bed when you *please* _b_ ---                        
    ## [302]                                          --- so you may go to       bed      when you *please* _b_ _b_ ---                        
    ## [303]                               --- All the other servants have      gone      to bed, then, *I* *suppose* ---                      
    ## [304]                              --- the other servants have gone       to       bed, then, *I* *suppose* _b_ ---                     
    ## [305]                               --- other servants have gone to       bed     , then, *I* *suppose* _b_ _b_ ---                     
    ## [306]                                   --- the fingers of her soft      hand      clinging to mine. *No*, I ---                        
    ## [307]                                  --- the dreadful taint in my      blood    . ' *Good-day* to you, Mr. Audley ---                 
    ## [308]                                     --- gone clean out of his      head      altogether. He was tipsy, *you* ---                  
    ## [309]                                  --- see *by* *the* *way* his      face      was turned toward me in ---                          
    ## [310]                                    --- _b_ _b_ " He shook his      head     . *No*, *no*, *no*, he said, ---                      
    ## [311]                                        --- was no word in her      mouth     that was *too* *bad* for ---                         
    ## [312]                                    --- a cranky *sort* *of* a      body      at the best of times ---                             
    ## [313]                                --- *I* *dare* *say*, too, her      heart     strikes her (it always does ---                      
    ## [314]                        --- *No*; my master is Buckinghamshire      born     ; and he 's feared the ---                            
    ## [315]                                        --- _b_ _b_ _b_ _b_ He     wakened    fra' his sleep, as *yo* ---                          
    ## [316]                                   --- _b_ He wakened fra' his      sleep    , as *yo* left him in, ---                            
    ## [317]                              --- him, Alice; *I* *believe* my      heart     's wishing him a' this ---                           
    ## [318]                                        --- 's night did I lie      awake     and think, that *please* God, ---                    
    ## [319]                                      --- could not find in my      heart     t' say her *nay*, though ---                         
    ## [320]                                  --- *see* 'd th' landlady 's      face     , all swelled wi' crying, when ---                    
    ## [321]                           --- were leaving my *blessed* child     asleep     -- in her last sleep. ---                            
    ## [322]                               --- _b_ " Well ! (there 's Mary     asleep     for a good listener !) *I* ---                       
    ## [323]                                  --- and we were footsore and      tired     enough, and *to* *my* *mind* ---                     
    ## [324]                                 --- were getting the babby to      sleep     wi' a *sort* *of* rocking ---                        
    ## [325]                               --- were listening with all his      ears      *nevertheless*; and when she saw ---                 
    ## [326]                                   --- _b_ *Ay*, and a notable      body     , too. I 'll just step ---                            
    ## [327]                                    --- *say*; but if a loving      heart     and a strong right arm ---                           
    ## [328]                                   --- _b_ _b_ _b_ *Yes* ! his      body      's come, but I think ---                             
    ## [329]                     --- grass-green. *However*, she had green      hair      *sure* *enough*: and were proud ---                  
    ## [330]                                 --- *Blessed* are the pure in      heart    , for they shall see God ---                          
    ## [331]                                      --- it did break Mary 's      heart    , *you* *see*. And now I ---                          
    ## [332]                                    --- have, afore we 'll set    shoulder    to their work; and *they* ---                        
    ## [333]                                  --- now for *they* *say* her      face      is sadly drawn. He 'll ---                           
    ## [334]                                       --- _b_ _b_ *Yes*; I am      tired     enough. One is good for ---                          
    ## [335]                                --- *all*, nurse, he 's really      tired    , and would be glad to ---                            
    ## [336]                                    --- it. Look at her bright      eyes     , she wo n't stir. *Ay* ! ---                         
    ## [337]                                --- _b_ _b_ _b_ *Oh* ! weeping      heart     ! *Oh* ! *bleeding* heart ! What boots ---           
    ## [338]                  --- *Oh* ! weeping heart ! *Oh* ! *bleeding*      heart     ! What boots thy pity now ? ---                      
    ## [339]                                    --- *say*; but keep up thy      heart    . *Yo* can not have much ---                          
    ## [340]                            --- heavy hours Beside the fevered      sleep     of one they love ! *Oh*, ---                         
    ## [341]                                   --- Come, come, hold up thy      head     . It will all end *right* ---                         
    ## [342]                                         --- _b_ _b_ I can not      sleep    , *thank* *you*. I will sit ---                       
    ## [343]                           --- grave ! MARY. *God* *knows* thy      heart    , my father ! and I shudder ---                       
    ## [344]                                  --- last *I* *see* thee, thy      lips      were as white as a ---                               
    ## [345]                                 --- lies *right* under one 's      nose     , till it 's pointed out. ---                         
    ## [346]                                 --- and cared not whether his      heart     was *sorry* or glad; whether ---                     
    ## [347]                                 --- _b_ _b_ *Ay* ! nought but      skin      and bone, with a cough ---                           
    ## [348]                                --- *Ay* ! nought but skin and      bone     , with a cough to tear ---                            
    ## [349]                         --- this dreadful blacksmith with his      arms      akimbo, laughing, -- *oh*, is ---                    
    ## [350]                                    --- pictures out of my own      head     , *you* *know*. But I 've ---                         
    ## [351]                                --- home last holidays, -- the      body      all black, *you* *know*, and ---                     
    ## [352]                              --- black, *you* *know*, and the      eyes      red, like fire, because he ---                       
    ## [353]                                       --- he 's slow with his     tongue    , *you* *see*, and he reads ---                       
    ## [354]                              --- *please* forgive me, Tom; my      heart     will break _b_ _b_ _b_ ---                           
    ## [355]                                 --- *it*, and you pushed your      head      through my kite, all for ---                         
    ## [356]                                   --- after his mother in the      face     ; *I* *think* there is n't ---                        
    ## [357]                                      --- _b_ Go and hide your      face     , and *mind* *you* do n't ---                         
    ## [358]                                   --- and *I* *dare* *say* my      foot      was as bad as his. ---                               
    ## [359]                                      --- 's got his father 's      blood     in him too. *Ay*, *ay*, ---                          
    ## [360]                                       --- see what was in the      chest    . You 've been ill, *you* ---                         
    ## [361]                                     --- *Oh* ! to turn up his      nose      at his father 's customers, ---                      
    ## [362]                                --- But, *you* *see*, the best      hand      in the world 'll not ---                             
    ## [363]                                         --- 's got used to my      hand     , *like*. An' there was niver ---                     
    ## [364]                                     --- the mill in their own      hands    , *I* *suppose*, and pay your ---                     
    ## [365]                                     --- *you* *see*, so a big      thumb     tells. I clap my thumb ---                           
    ## [366]                    --- cause thereof .... *Blessed* are those      ears      that receive the whispers of ---                     
    ## [367]                            --- the world. *Blessed* are those      ears      which hearken not unto the ---                       
    ## [368]                                    --- _b_ _b_ *I* *think* my      head      's all alive inside like ---                         
    ## [369]                                --- damaged bit 's turned your     stomach    now; *I* *see* it has ---                            
    ## [370]                              --- it again. *Please* turn your      head      this way _b_ _b_ _b_ ---                             
    ## [371]                                 --- his eye, making a hideous      face     , as young Torry does. *I* ---                        
    ## [372]                                   --- *thing* -- I doubt this      liver     complaint 'ull carry her off. ---                    
    ## [373]                                        --- say. I will put my      hand      on the Bible *if* *you* ---                          
    ## [374]                                     --- of the anxiety off my    shoulders   *by* *and* *by*. I 'm ---                            
    ## [375]                            --- Tulliver. *If* *you* *like* to     swallow    him for his sister 's ---                            
    ## [376]                                   --- *No*, not with my whole      heart     and soul, Stephen _b_ _b_ ---                        
    ## [377]                                     --- _b_ _b_ *Oh*, she has     fallen     asleep, and not being used ---                       
    ## [378]                                  --- _b_ *Oh*, she has fallen     asleep    , and not being used to ---                           
    ## [379]                           --- gossip about. *However*, she 's      tired     to death now, and not ---                            
    ## [380]                              --- allow you. *Thank* *God* she     sleeps     so well: I hope she ---                              
    ## [381]                                       --- you or I. *Ah*, her      face      was pale ! Maybe you can ---                         
    ## [382]                                   --- not to ! 'Twill make my      skin      crawl when *I* *think* of ---                        
    ## [383]                                    --- feel like that. It was      born      in my blood, *I* *suppose* ---                       
    ## [384]                                         --- It was born in my      blood    , *I* *suppose* _b_ _b_ _b_ ---                       
    ## [385]                                  --- Why, *yes*, you be: your      hand      is bleeding. Come under my ---                       
    ## [386]                                        --- _b_ _b_ _b_ _b_ My      eyes      have got foggy-like -- *please* ---                  
    ## [387]                                           --- I am not red by      birth    , *you* *know*; I only took ---                       
    ## [388]                                 --- _b_ *Yes*. Poor maid, her      heart     has ached enough about it. ---                       
    ## [389]                            --- look *right* into your moonlit      face      and dwell on every line ---                          
    ## [390]                                         --- to be of the same      vein     , to make you happy, *I* ---                          
    ## [391]                                    --- _b_ _b_ *I* *see* your      face      in every scene of my ---                             
    ## [392]                               --- number. *I* *think*, by the      faces     of those gentlemen who have ---                      
    ## [393]                                   --- I shall always swear my      flesh     do n't crawl when *I* ---                            
    ## [394]                                  --- *of* golden halo to your      eyes      -- a man who knew ---                                
    ## [395]                                    --- whim ? You have all my      heart     yet, *I* *believe*; and because ---                  
    ## [396]                                        --- _b_ *Yes* -- he is      awake     -- he will go to ---                                 
    ## [397]                                      --- _b_ _b_ _b_ You will       go       to sleep there, *I* *suppose*, ---                   
    ## [398]                                       --- _b_ _b_ You will go       to       sleep there, *I* *suppose*, wo ---                   
    ## [399]                                        --- _b_ You will go to      sleep     there, *I* *suppose*, wo n't ---                     
    ## [400]                                     --- _b_ *No*. I shall not      sleep     much till -- another day, ---                        
    ## [401]                                      --- *I* *see* it in your      face      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [402]                                   --- tears and offer me your      hand      ? *Good* *God* ! can you ? *No*, ---                 
    ## [403]                                      --- *Yes*, I am given up      body      and soul to the making ---                           
    ## [404]                                 --- made a covenant with mine      eyes     ; why then should *I* *think* ---                     
    ## [405]                            --- butchers or bakers. *Oh* ! how      tired     I used to be of ---                                  
    ## [406]                                      --- despise me; I have a      heart    , notwithstanding all this *good-for-nothing* way --- 
    ## [407]                                   --- flowers out of yo'r own      hand     ; -- *yo* may come if ---                             
    ## [408]                                  --- *they* *say*, in all our      blood    , And a grain or two ---                              
    ## [409]                                  --- in disorder close at its      hand      -- why, *I* *say*, leave ---                         
    ## [410]                            --- father ! you shall ! *Oh* ! my      heart     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [411]                                  --- *say* it winds round the      lungs    , and tightens them up. *Anyhow*, ---                 
    ## [412]                            --- *suppose* because, on the very      face      of it, *I* *see* two ---                             
    ## [413]                                 --- your mother is tired, and      gone      to bed early ! *I* *'m* ---                          
    ## [414]                                 --- mother is tired, and gone       to       bed early ! *I* *'m* *afraid*, ---                   
    ## [415]                                     --- is tired, and gone to       bed      early ! *I* *'m* *afraid*, such ---                  
    ## [416]                                        --- if *yo* 'd had one      body      after another coming in to ---                       
    ## [417]                            --- *know* my brother has imported      hands     from Ireland, and it has ---                         
    ## [418]                                       --- lost a good deal of      blood    , *I* *'m* *afraid* _b_ _b_ ---                       
    ## [419]                                       --- _b_ _b_ _b_ _b_ _b_      Bleed     ! *oh*, how horrid ! How has ---                     
    ## [420]                                    --- *say*, she 'd give her      eyes      if he 'd marry her, ---                              
    ## [421]                                  --- *think*. It is under the      hair     , is it not _b_ _b_ ---                               
    ## [422]                            --- *afraid*, for missus is nearly     asleep    : but it will do nicely ---                           
    ## [423]                                      --- 'll seem close in my       ear     , and going through me *as* ---                       
    ## [424]                                        --- proof he had a bad      heart    . *Ah* ! Your poor father, Margaret. ---              
    ## [425]                                     --- in here. Give me your      hand     . What is this ? *Oh* ! your ---                      
    ## [426]                                  --- *mind*, to making men 's     hearts     so hard that they 'll ---                            
    ## [427]                                     --- go away ? She can not     breathe   , *poor* *thing*, with this crowd ---                 
    ## [428]                                         --- of a child at her      heart    . I 'm *sorry* they took ---                          
    ## [429]                                       --- had to keep a tight      hand      over you, to make *you* ---                          
    ## [430]                                    --- *yea* glad with all my      heart    , That thus so clearly I ---                          
    ## [431]                               --- good expecting marcy at the      hands     o' them measters. *Yo* 're ---                       
    ## [432]                                     --- or *right*, I 'm very     sleepy    ; so, having disturbed your night ---                 
    ## [433]                                     --- men *I* *mean* -- the      hands     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [434]                      --- man of business. *Nevertheless*, his   moustachios  are splendid. There will have ---                    
    ## [435]                                    --- *Ah* ! let me close my      eyes      and dream _b_ _b_ _b_ ---                            
    ## [436]                                 --- it as most people. What !     crying    , child ? *Nay*, now we 'll ---                       
    ## [437]                                 --- not deep; not above three      feet     ; but *oh* ! Mr. Bell, somehow ---                    
    ## [438]                               --- *rather* play. She is never      tired     of playing _b_ _b_ _b_ ---                           
    ## [439]                          --- Elliot countenance, I wonder the      arms      did not strike me ! *Oh* ! ---                       
    ## [440]                           --- time for applying. Everybody 's      heart     is open, *you* *know*, when ---                      
    ## [441]                                       --- I will, with all my      heart    , and farther, too. *Yes*, *yes* ---                  
    ## [442]                                      --- *I* *see* it in your       eye     . I perfectly see how the ---                         
    ## [443]                                --- *I* *think* of Benwick, my     tongue     is tied _b_ _b_ _b_ ---                              
    ## [444]                           --- unfortunate slave played on the      tibia    . His nephew (*oh* ! whip me ---                      
    ## [445]                      --- plague, *mind* *you* !) elevated the      heart    . " *Ah* ! " quoth the fat uncle, ---                 
    ## [446]                              --- *Ah* ! there is, indeed, the      hand      of a Zeuxis _b_ _b_ ---                              
    ## [447]                           --- *no* ! Thinkest thou her chaste      eyes      are ripe for such scenes ? ---                       
    ## [448]                                  --- thou laid flowers at the      feet      of the dead ? *Ah* ! thy ---                         
    ## [449]                                  --- of the dead ? *Ah* ! thy      hand      is cold -- hark yet ! ---                            
    ## [450]                               --- reject the atheist from her      bosom     ? -- An atheist, do *I* ---                          
    ## [451]                             --- love-crossed, then -- try thy      hand      at a gayer air. *Nay*, ---                           
    ## [452]                                 --- a new Plataea. *Yes*, the      hand      that now weaves the roses ---                        
    ## [453]                                     --- I declare I shall not      sleep     a wink till *I* *see* ---                            
    ## [454]                                   --- prize of victory is the      blood     of another. *Oh*, that is ---                        
    ## [455]                               --- thou shalt puzzle this dull      brain     all day long, *ay*, and ---                          
    ## [456]                                --- *After* *all*, the lamp of      Hymen     will be gilt, and the ---                            
    ## [457]                                  --- woke and looked upon the      face      of the Lord. *Oh*, that ---                          
    ## [458]                                --- *Oh*, that calm and solemn      brow     , that unutterable smile, that careworn ---           
    ## [459]                                       --- and in my mother 's      arms      -- *yes*, I am the ---                               
    ## [460]                                   --- or in pain ? *Nay*, thy      face      speaks for thee. What ails ---                       
    ## [461]                                 --- *eh* ? -- what long silky      hair      he has ! He is worth ---                             
    ## [462]                                 --- water. *Oh* ! look on yon      face      ! Man never before saw its ---                       
    ## [463]                             --- _b_ _b_ What *ho* ! Endymion,    sleepest    thou so soundly ? What has ---                       
    ## [464]                                       --- _b_ _b_ have you no      eyes      ? or *do* *you* *think* I ---                        
    ## [465]                                --- _b_ *No*, Glaucus thou art      awake    . By this right hand and ---                          
    ## [466]                              --- a Magician; thou readest the      heart     *as* *it* *were* a scroll ---                        
    ## [467]                                      --- _b_ *No*; but I must     breathe    my spell over its ray. ---                           
    ## [468]                           --- *Oh*, *blessed* stranger, in my      heart     is the urn which condemns ---                        
    ## [469]                                    --- *Oh* ! were hell at my      feet      -- *yes* ! Revenge on the ---                        
    ## [470]                               --- strong. *Oh* ! by thy right      hand      and thy father 's ashes, ---                         
    ## [471]                                     --- feel thy touch -- thy     breath     ! *Yes*, *yes*, thou livest ! We ---                 
    ## [472]                                    --- *Ay* ! by my father 's      head      ! Who art thou ? -- thy ---                          
    ## [473]                                  --- _b_ _b_ *Blessed* be thy      head      ! where _b_ _b_ _b_ _b_ ---                          
    ## [474]                                 --- hall *I* *see* the marble      faces     of my ancestors. In the ---                          
    ## [475]                                  --- that he had sprained his      ankle     *in* *the* *first* *place* _b_ ---                   
    ## [476]                        --- *course* familiar with: 'Keep your     breath     to cool your porridge'; and ---                      
    ## [477]                     --- vigour. *Adieu* to disappointment and     spleen    . What are young men to ---                           
    ## [478]                                --- *suppose*, and that in the       eye      of a servant comprehends every ---                   
    ## [479]                              --- *Never* *mind* Miss Lizzy 's      hair      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [480]                                      --- *think* I do with my      eyes      and ears ? I 've been ---                            
    ## [481]                                --- wade knee-deep in churls '      blood    ; *as* *it* *is*, you 've ---                         
    ## [482]                                 --- _b_ _b_ *Bravo* ! and her      face      ? her features ? How do you ---                      
    ## [483]                                 --- _b_ _b_ *Ah*, *yes* ! her      mouth     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [484]                            --- steps ? Confound it, *no* ! My      heart     is not a plank to ---                                
    ## [485]                        --- damask cheek, and roguish laughing       eye     . And Caroline de Blemont ! *Ah*, ---                 
    ## [486]                                       --- *I* *see* it in his      face     : he blushes whenever your name ---                   
    ## [487]                            --- standest before me resting thy      hand      on thy blunted blade. *Ay*; ---                      
    ## [488]                              --- blade. *Ay*; *I* *see* thine       eye      confront mine and demand why ---                     
    ## [489]                                        --- _b_ _b_ *Yes* -- a      mole     , which lives underground would seem ---              
    ## [490]                                        --- _b_ _b_ _b_ Of his      eyes      ? *No*. What did *they* *say* ---                    
    ## [491]                                   --- _b_ Mother, we *ay* n't     asleep     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [492]                                     --- _b_ _b_ *No*, we aynt     asleep    , mother _b_ _b_ _b_ _b_ ---                          
    ## [493]                                     --- *Oh* ! why was I ever      born      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [494]                                         --- to work; I had no      head      *I* *believe* for the law; ---                       
    ## [495]                              --- my Maker had fashioned these      limbs     *rather* to hold a lance ---                         
    ## [496]                                --- what passes under my daily      eyes      when *I* *say*. that those ---                       
    ## [497]                                --- *Ay*, we have some English      blood     in our veins, though peasants ---                    
    ## [498]                                     --- _b_ *Ah* ! you win my      heart     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [499]                                    --- *as* *it* *is*, for my      brain     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [500]                               --- and my inspector has gentle      blood    , *they* *say*, in his veins ---                      
    ## [501]                               --- blood, *they* *say*, in his      veins     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [502]                                       --- _b_ _b_ _b_ Lots of     kidneys    *I* *dare* *say* _b_ _b_ ---                         
    ## [503]                                        --- visit a day or two      back      ? At Mowbray Castle. *I* *see* ---                   
    ## [504]                          --- *this* *respect*; besides as the      head      of our most influential organ ---                    
    ## [505]                                      --- that I may catch the     profile    of your face better. *Yes*, ---                      
    ## [506]                                 --- catch the profile of your      face      better. *Yes*, that 's the ---                       
    ## [507]                           --- *Yes*, that 's the d'Urberville      nose      and chin -- a little ---                             
    ## [508]                                --- was there --'twas a little    one-eyed   , *blinking* sort o' place _b_ ---                    
    ## [509]                                --- every bit o' thy *blessed*      body      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [510]                                 --- _b_ _b_ *No*, stupid; her      face      -- as 't was mine ---                                
    ## [511]                                 --- do ! *Hold* *on* round my      waist     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [512]                                --- _b_ *Now* *then*, put your      arms      round my waist again, as ---                         
    ## [513]                                 --- *thank* *God*, and we can      sleep     it off in church-time. Now, ---                      
    ## [514]                                  --- *damn* bad fellow. I was      born      bad, and I have lived ---                            
    ## [515]                             --- *however*, though she made my     fingers    ache _b_ _b_ _b_ _b_ ---                             
    ## [516]                                        --- O *no* ! he ca n't     stomach    old families _b_ _b_ _b_ ---                         
    ## [517]                                    --- put your arms round my    shoulders  , so. Now ! *Hold* *on*. That ---                     
    ## [518]                            --- me already, *you* *know*; your      heart    , *I* *mean*. Does it not ---                         
    ## [519]                                --- history then. *Yes*, I was      born      at so and so, Anno ---                               
    ## [520]                                   --- as I should secure pink     cheeks    ; but -- *However*, I am ---                          
    ## [521]                              --- obey the truth, before whose      eyes      *Jesus* *Christ* hath been evidently ---             
    ## [522]                             --- post and afterwards hung. The      bones     lie underneath. *They* *say* he ---                  
    ## [523]                                --- old ruins, and finding the      bones     o' things, *and* *such* *like*; ---                  
    ## [524]                                    --- *Jove*, sir, it did my      heart     good to see you. I ---                               
    ## [525]                                       --- _b_ _b_ _b_ _b_ _b_      Blood     is everything, *after* *all* _b_ ---                 
    ## [526]                                   --- _b_ You want your money      back     , *I* *suppose* _b_ _b_ _b_ ---                       
    ## [527]                                      --- me to hold my stupid     tongue    . *Oh*, Miss B., I never ---                          
    ## [528]                                       --- _b_ _b_ _b_ You 're      wide      awake, *I* *see* _b_ _b_ ---                         
    ## [529]                                      --- _b_ _b_ You 're wide      awake    , *I* *see* _b_ _b_ _b_ ---                           
    ## [530]                                   --- *see*. You 've got more     brains     in your little vinger than ---                       
    ## [531]                                   --- *dare* *say* she wore a      nose      ring when she went to ---                            
    ## [532]                                 --- the white feathers in her      hair      -- *I* *mean* in her ---                             
    ## [533]                                       --- to grin and wag its      head     . *By* *Jove*, Will, it was ---                       
    ## [534]                                     --- a fine girl ! what an      ankle    , *eh*, Jos ?) Tell us that ---                       
    ## [535]                                     --- *I* *say*, here 's my      hand     . *I* *say*, forget and forgive. ---                  
    ## [536]                                  --- *No*, run me through the      body      if I am _b_ _b_ ---                                  
    ## [537]                                       --- King of Rome at its      head     ; and the Russians, *bah* ! the ---                   
    ## [538]                                  --- avoid you ? Let your own      heart     answer that question. *Do* *you* ---                 
    ## [539]                                 --- there 's nothing like old      blood    ; *no*, dammy, nothing like it. ---                   
    ## [540]                                --- *'s* *sake*, Rawdy, do n't      wake      Mamma _b_ _b_ _b_ _b_ ---                            
    ## [541]                                     --- _b_ _b_ _b_ Hold your     tongue    , if you *please*. I know ---                         
    ## [542]                                   --- property must go to the      head      of the house, *you* *know*. ---                      
    ## [543]                                --- *ha* ? Run him through the      body     . Marry somebody else, hay _b_ ---                    
    ## [544]                         --- you have, Crawley ? Some devilled     kidneys    and a herring -- *let* ---                           
    ## [545]                              --- congratulate you with all my      heart    . I presume *you* *know*, gentlemen, ---              
    ## [546]                                      --- -- do n't shake your      head      and say *no* -- HE ---                               
    ## [547]                                   --- _b_ _b_ _b_ *Yes*; *ay*       nap      after dinner _b_ _b_ _b_ ---                         
    ## [548]                       --- accusation which, *after* *all*, is     unsaid    . What is it ? Is it ---                              
    ## [549]                                      --- love him with all my      heart     now. *Oh*, I will, I ---                             
    ## [550]                          --- alone exist. Power ! *Oh* ! what    sleepless   nights, what days of hot ---                         
    ## [551]                                 --- *you* *think* it a pretty      hand      _b_ _b_ _b_ _b_ _b_ ---                              
    ## [552]                                 --- *say*, when he opened his      eyes      in the illumined saloons, was ---                    
    ## [553]                                     --- place to me; you have      nerve     enough, *you* *know*, for anything, ---              
    ## [554]                                      --- not to dare open his      lips     . *I* *see* that your Lordship ---                    
    ## [555]                              --- *After* *all*, what is noble      blood     ? My eye is now resting ---                          
    ## [556]                               --- *first* *place*, I would be      born      in the middle classes of ---                         
    ## [557]                           --- can believe anything. *Oh* ! my      heart     is very sick ! I once ---                            
    ## [558]                             --- version. *I* *say*, that four      feet      nine is the greatest height ---                      
    ## [559]                             --- dash their glasses over their      heads    , give three *cheers*, and adjourn ---                
    ## [560]                                    --- _b_ _b_ _b_ *Yes*; his      face      was swollen, and he was ---                          
    ## [561]                                 --- error: you have opened my      eyes     , and *blessed* be the hour ---                       
    ## [562]                                --- now enduring upon the base      body      of a woman. *No* ! 't ---                            
    ## [563]                                   --- I knew there was gentle      blood     under that cloak. *If* *you* ---                     
    ## [564]                                --- than one of those medicine     chests    , which *I* *dare* *say* you ---                      
    ## [565]                               --- *thank* *you*, sir, for the       Nap     ; but I hope I have ---                               
    ## [566]                                   --- *No*, *no*, *no* ! I am      tired     of living alone _b_ _b_ ---                          
    ## [567]                               --- Georges have blood in their      veins    ; and would, *I* *suppose*, as ---                    
    ## [568]                               --- *I* *suppose* we should get      tired     of each other. *No* ! that ---                       
    ## [569]                                 --- _b_ _b_ noble and *right*     thirsty    lords, but one of the ---                            
    ## [570]                         --- before ! *Oh* ! bless your bright      eyes      for these eggs, and this ---                         
    ## [571]                                --- *Oh*, shame ! shame on the      blood     of my father 's son ! ---                            
    ## [572]                           --- of an unprincipled Minister. My      eyes     , *however*, are now open. The ---                    
    ## [573]                          --- name. They were soon, *however*,     roused     from their sorrow and their ---                      
    ## [574]                                   --- of the State: the great      body      of the people, *of* *course*, ---                    
    ## [575]                       --- then *I* *suppose*, stretching your      legs      in your easy-chair, you will ---                     
    ## [576]                                       --- an arm ! there 's a       leg      ! Can *you* *see* through a ---                      
    ## [577]                            --- *they* *say* his servants wear      skins    , and he has got a ---                                
    ## [578]                               --- title. *Oh* ! quit, quit my      hand      ! Happiness is not for me ---                        
    ## [579]                                  --- will *thank* *you* for a      doze      in such a den _b_ ---                                
    ## [580]                                --- do - ONCE more ! *Oh* ! my      heart     's darling ! hear me THIS ---                        
    ## [581]                           --- and laughing, and burning their      eyes      out before the fire. *Do* ---                        
    ## [582]                            --- for our excursion, shaking her      head      and expostulating with her, *I* ---                  
    ## [583]                               --- *sake*, and hide your vixen      face      ! How foolish to reveal those ---                    
    ## [584]                                --- in danger of splitting its      skull     against my knuckles. *By* *God* ! ---                
    ## [585]                            --- splitting its skull against my    knuckles   . *By* *God* ! Mr. Linton, I ---                      
    ## [586]                                  --- you possess. *No*, I 'll     swallow    the key before you shall ---                         
    ## [587]                                    --- *no* ! I 'll crush his      ribs      in like a rotten hazel-nut ---                       
    ## [588]                                  --- appear odd - *I* *see* a      face      in it _b_ _b_ _b_ ---                                
    ## [589]                               --- prison, *after* *all*. I 'm      tired     of being enclosed here. I ---                        
    ## [590]                                   --- his dying day, and wept      tears     of blood for Catherine ! *No*, ---                   
    ## [591]                                    --- day, and wept tears of      blood     for Catherine ! *No*, indeed, indeed, ---            
    ## [592]                           --- away, *however*, and seized his       arm     . _b_ _b_ _b_ _b_ _b_ ' " ---                         
    ## [593]                                   --- *Oh* ! it 's killing, a     breath     of night air ! And he ---                            
    ## [594]                                 --- Na - *ay* ! *yah* muh goa      back      whear *yah* coom frough _b_ ---                      
    ## [595]                                      --- kiss me: it takes my     breath    . *Dear* *me* ! Papa said you ---                     
    ## [596]                                      --- *no*, dear, I 'm not      tired     _b_ _b_ _b_ _b_ _b_ ---                              
    ## [597]                                    --- n't pity hers ! I shed      tears    , Master Heathcliff, *you* *see* - an ---             
    ## [598]                                    --- up there ! *Oh* ! I 'm      tired     - I 'm STALLED, Hareton _b_ ---                      
    ## [599]                                 --- _b_ *Oh*, indeed; you 're      tired     of being banished from the ---                       
    ## [600]                      --- flaysome wickednesses that iver were      born      into th' warld ! *Oh* ! ye ---                       
    ## [601]                                 --- *Nay* ! it fair brusts my      heart     ! He 's forgotten all I ---                          
    ## [602]                               --- his character ? ' I wave my      hand      negligently. 'Letters ? ' *I* *say*. 'Ha ! ---       
    ## [603]                                --- have quite cast my insular      skin      *in* *that* *respect*. I wish ---                    
    ## [604]                                     --- me. *I* *see* in your      face      that he WAS particularly nervous; ---                
    ## [605]                                      --- full of tears and my      heart     beating -- for *I* *believe* ---                     
    ## [606]                                     --- of tears and my heart     beating    -- for *I* *believe* in ---                          
    ## [607]                                 --- business being safe in my      hands     ? *Yes*, *yes*, *of* *course*. Bless ---             
    ## [608]                                     --- *oh*, it will ease my      heart     so to end this miserable ---                         
    ## [609]                                      --- it there with my own      hands    . And say -- *oh*, Marian, ---                        
    ## [610]                                       --- of it, and try your      teeth     in my fat neck ? *Bah* ! ---                         
    ## [611]                                      --- your teeth in my fat      neck      ? *Bah* ! not you _b_ _b_ ---                        
    ## [612]                                     --- your lives. Now go to       bed      and dream of him *if* ---                            
    ## [613]                               --- *see* with pleasure in your      face     . Pray present my best respects ---                   
    ## [614]                                   --- _b_ *No*. She shook her      head     , and told me she must ---                            
    ## [615]                     --- medical authorities ever reached your      ears      -- *Yes* or *No* _b_ ---                             
    ## [616]                                    --- _b_ _b_ _b_ _b_ *Yes*,  heart-disease of a most dangerous kind ---                         
    ## [617]                                   --- _b_ my own darling ! my      heart     is heavy for you. *Oh*, ---                          
    ## [618]                           --- necessary authority to have the      body      exhumed. *In* *short*, there is ---                  
    ## [619]                               --- _b_ *Yes*, sir. A gentleman      born      and brought up, who ought ---                        
    ## [620]                                  --- _b_ *Yes*, sir. Anne was      born      in the June month of ---                             
    ## [621]                                 --- _b_ _b_ *Never* *mind* my     crying     if I can be of ---                                   
    ## [622]                                     --- put your arm round my      waist    , and kiss me, *if* *you* ---                         
    ## [623]                                      --- if Laura had seen my      face      at that moment ---- *Thank* ---                      
    ## [624]                         --- *good* *morning*. ' His cold grey      eyes      settled on my face -- ---                            
    ## [625]                                       --- put my life in your      hands    . If what *I* *say* to ---                            
    ## [626]                                      --- *I* *see* it in your      face     . Tell me nothing -- keep ---                         
    ## [627]                                    --- move -- *you* *see* my      hands     are empty. Wait a little. ---                        
    ## [628]                                     --- so ! you can lay your     finger    , *I* *see*, on the weak ---                          
    ## [629]                                 --- in my power of commanding      sleep     at will. *Excuse* *me* one ---                       
    ## [630]                              --- *God* *bless* *her* ! Gi' it     tongue    , lads ! Gi' it tongue _b_ ---

``` r
# Z7 ["If"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("Z7"), context = 0)
y
```

    ## [  1]                  --- is shed abroad in my     heart    ; and *if* I can get ---                    
    ## [  2]           --- would have sent the footman      back     for you, Miss Grey, *if* ---               
    ## [  3]                   --- not have him see my     heart    : yet, *if* he could but ---                
    ## [  4]                     --- *if* I had got no      head     at all. That 's what ---                   
    ## [  5]                    --- that *if* a man 's     heart     is concerned, he is not ---                
    ## [  6]                 --- loins. I would n't go       to      sleep under a tree, *if* ---               
    ## [  7]                     --- I would n't go to     sleep     under a tree, *if* I ---                   
    ## [  8]            --- well, *if* possible, I 'll       go      to bed _b_ _b_ _b_ ---                     
    ## [  9]               --- *if* possible, I 'll go       to      bed _b_ _b_ _b_ _b_ ---                    
    ## [ 10]         --- tomorrow; then, *if* I should       go      to sleep, you know, you ---                
    ## [ 11]                --- then, *if* I should go       to      sleep, you know, you 'll ---               
    ## [ 12]                   --- *if* I should go to     sleep    , you know, you 'll be ---                  
    ## [ 13]               --- *If* you really are not     tired    , I think we will go ---                    
    ## [ 14]                   --- *If* ever a man was     tired     of a woman, Lord Dumbello ---              
    ## [ 15]                  --- that, *if* he do n't      bite    . He used to gnash them ---                 
    ## [ 16]              --- *if* he comes under your      feet    ; but beware, above all things, ---         
    ## [ 17]                 --- you do now. *If* your     heart     was right, Johnny, you would ---           
    ## [ 18]              --- by knocking him over the      head    . And *if* we are to ---                    
    ## [ 19]                 --- I would always keep a      cell     for you, my darling, *if* ---              
    ## [ 20]                 --- not going to break my      legs     *if* I know it _b_ ---                     
    ## [ 21]             --- course I would. *If* your     heart     be free now, it must ---                   
    ## [ 22]        --- *if* necessary -- putting your    shoulder   to the wheel when the ---                  
    ## [ 23]                --- the blame on the wrong   shoulders  . *If* you 'll take my ---                  
    ## [ 24]          --- prevent her, *even* *if* her     heart     permitted it. Oh ! dear; it ---            
    ## [ 25]                --- be disgraced in my own      eyes     *if* I admitted the love ---               
    ## [ 26]                --- be disgraced in my own      eyes     *if* I admitted the love ---               
    ## [ 27]                    --- _b_ _b_ What can a     heart     be worth *if* it can ---                   
    ## [ 28]             --- Lily, stop; and make your     heart     kinder towards him *if* you ---            
    ## [ 29]              --- is afraid, in drying her     tears     *if* she weeps; and finally, ---           
    ## [ 30]               --- killing her with my own      hand     ! *If* you would defend her, ---           
    ## [ 31]               --- their stems with my own     hands     ! *If* a bird, native of ---               
    ## [ 32]           --- sorrow ! *If* there are any     tears     still on my cheeks, they ---               
    ## [ 33]                --- a slave with a hundred     lashes    *if* his warm water was ---                
    ## [ 34]              --- my sympathy. I should be   insensible , indeed, *if* I could know ---             
    ## [ 35]                   --- -- and ask your own     heart     *if* the miserable wretch whom ---         
    ## [ 36]                      --- _b_ _b_ I 'm too     tired     to look. *If* you find ---                 
    ## [ 37]                      --- me *if* I do. My      head     feels wild and giddy, but ---              
    ## [ 38]            --- Mr. Armadale; we want your     waking    impression of a sunset, *if* ---           
    ## [ 39]           --- Armadale *if* you hold your     tongue    about Madeira and all that ---             
    ## [ 40]                      --- *If* he is not a      born     idiot he will decline to ---               
    ## [ 41]                --- of them shall touch my      skin    , I promise you. *If* you ---               
    ## [ 42]            --- lips and instantly held my     breath   . She was asking papa *if* ---              
    ## [ 43]                --- cats, my dear, nose to      nose     on the tiles ? *If* you ---                
    ## [ 44]            --- sounds almost absurd in my      ears     (*if* you will pardon me ---               
    ## [ 45]             --- and ask yourself *if* her      face     does or does not answer ---                
    ## [ 46]        --- the neighborhood, and *if* her      face     answers my seven questions, you ---        
    ## [ 47]          --- shall throw something at her      head     *if* we go on much ---                     
    ## [ 48]                  --- _b_ *If* you had had      eyes     in your head, you would ---                
    ## [ 49]             --- have screamed. I took his      hand    , to try *if* that would ---                
    ## [ 50]                      --- he had me in his      arms    . 'Ask me *if* I love ---                   
    ## [ 51]            --- astonishment as *if* I had      woke     him from a dream, and ---                  
    ## [ 52]              --- *if* it would clear your      head    , that 's quite another thing ! ---         
    ## [ 53]                 --- be void. ' I 'll take     breath    here *if* you 'll allow ---                
    ## [ 54]                 --- the man who opens his      eyes     to the truth ? *If* that ---               
    ## [ 55]              --- off on another person 's   shoulders  . *If* your good lady had ---               
    ## [ 56]               --- to reach Miss Milroy 's      ears    . With her temper (*if* she ---             
    ## [ 57]                   --- would tell me to my      face    , *if* I went to her, ---                   
    ## [ 58]             --- be delivered into his own      hand    . *If* absent, please return wire ---       
    ## [ 59]                 --- *if* we could lay our     hands     upon that lady we should ---               
    ## [ 60]         --- very powerful weapon into our     hands    . *If* I could only use ---                 
    ## [ 61]                   --- you; it will cut my     heart     cruel; but *if* this baby ---              
    ## [ 62]                   --- is in making one 's     blood     creep. And *if* there is ---               
    ## [ 63]                 --- all one and the same,   shoulders   is. *If* you 'll trusten ---               
    ## [ 64]                  --- It would be a mercy,     Fanny    , *if* that girl were well ---              
    ## [ 65]                  --- that *if* I broke my     bones     I should not feel it. ---                  
    ## [ 66]                    --- I ask *if* you are     tired     of dancing, Miss Harleth _b_ ---           
    ## [ 67]               --- clear and sharp. *If* I     slept    , it was only to see ---                    
    ## [ 68]                    --- *if* I put a false     visage    on things -- made them ---                 
    ## [ 69]                --- have over her *if* she    swallows   her reasons and accepts you. ---           
    ## [ 70]                     --- *if* a man is not      born     into public life by his ---                
    ## [ 71]            --- some would never get their      eyes     opened *if* it were not ---                
    ## [ 72]                --- thing you have on your     wrist    . *If* you have anything to ---             
    ## [ 73]                   --- _b_ _b_ With all my     heart    , *if* it will do you ---                   
    ## [ 74]              --- said, that Israel is the     heart     of mankind, *if* we mean ---               
    ## [ 75]             --- _b_ _b_ *If* some mortal,      born     too soon, Were laid away ---               
    ## [ 76]          --- and *if* another grandson is      born     to him who is departed, ---                
    ## [ 77]                  --- easily be led arm in      arm      with a lunatic, especially *if* ---        
    ## [ 78]      --- with bowed head and outstretched      arms    . Alan ! Alan ! *If* you do ---             
    ## [ 79]                --- you men love with your      eyes    , *if* you ever love at ---                 
    ## [ 80]                 --- it might tax his poor     brain     *if* he were to try ---                    
    ## [ 81]                --- you were like me, *if*     sleep     was to you a presage ---                   
    ## [ 82]              --- cart, began to knock his      head     against the ground. *If* I ---             
    ## [ 83]             --- speak, and *even* *if* we     sleep     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 84]           --- dead. Why mutilate her poor      body     without need ? And *if* there ---          
    ## [ 85]             --- little mite, when he woke       up      today, asked the nurse *if* ---            
    ## [ 86]             --- blood with that so wicked     mouth    . But *if* she die in ---                   
    ## [ 87]               --- kiss her. Kiss her dead      lips     *if* you will, as she ---                  
    ## [ 88]            --- friend John, where are the    skeleton   keys ? *If* so that we ---                 
    ## [ 89]         --- two things occurred. *If* his      back     was broke, he could n't ---                
    ## [ 90]                 --- he could n't beat his      head    , and *if* his face was ---                 
    ## [ 91]                --- his head, and *if* his      face     was like that before the ---               
    ## [ 92]                  --- swear at him in many    tongues   , and tell him that *if* ---                
    ## [ 93]                  --- be seen *if* we have      eyes     to notice without prejudge. Her ---        
    ## [ 94]                   --- *if* it be that she     sleep     all the day, it shall ---                  
    ## [ 95]              --- a common way, like every      body     else, and *if* there is ---                
    ## [ 96]                   --- to what is near the     heart    . *If* I could but have ---                 
    ## [ 97]             --- in existence. -- *If* any      body     can deserve him, it must ---               
    ## [ 98]                --- *if* she fall into bad     hands    , may be teazed, and kept ---               
    ## [ 99]              --- conduct is felt by every      body    . *If* he would act in ---                  
    ## [100]           --- They must not over-salt the      leg     ; and then, *if* it is ---                  
    ## [101]                  --- am sure *if* Jane is     tired    , you will be so kind ---                   
    ## [102]        --- workmen, I suppose, hold their    tongues   ; but we gentlemen labourers *if* ---       
    ## [103]                --- in action, *if* not in consciousness _b_ _b_ _b_ _b_ _b_ ---                    
    ## [104]           --- some quickness of sight and      hand    , and exercise improves them. *If* ---      
    ## [105]               --- _b_ Oh ! my dear, human     flesh     ! You quite shock me; *if* ---             
    ## [106]             --- from the comforts she was      born     to; and, *if* she live ---                 
    ## [107]                --- now set himself at the      head     of the university; and *if* ---            
    ## [108]                  --- _b_ _b_ _b_ dry your     tears    . *If* she is, as you ---                   
    ## [109]       --- assuredly act *if* her darkened      eyes     opened and she beheld me. ---              
    ## [110]                 --- of love that burns my     heart    , that *if* you grant my ---                
    ## [111]             --- the winds. My spirit will     sleep     in peace, or *if* it ---                   
    ## [112]              --- *If* ye suffer hunger or     thirst    for My sake, happy are ---                 
    ## [113]    --- scrutinise her actions, punish her      body     to save her soul: *if*, ---                
    ## [114]       --- feelings are concealed in their     hearts   ; and *if* you persevere in ---             
    ## [115]                     --- *if* I had only a     brain     active enough to ferret out ---            
    ## [116]                --- all day: you must feel     tired    . *If* you have got your ---                
    ## [117]                --- *If* you have got your      feet     well warmed, I 'll show ---                
    ## [118]                   --- -- and full as much     heart     ! And *if* God had gifted ---              
    ## [119]            --- a covering for my low-born      head    , and ask *if* that was ---                 
    ## [120]               --- when the secrets of all     hearts    shall be disclosed), that *if* ---         
    ## [121]             --- still: *if* you raved, my      arms     should confine you, and not ---            
    ## [122]          --- flight and nestle against my     heart    , *if* you would: seized against ---        
    ## [123]               --- dumb. *If* I offered my     heart    , I believe you would accept ---            
    ## [124]             --- _b_ _b_ her small, slight    fingers    ! *If* so there must be ---                
    ## [125]                     --- Ay, I must put my    shoulder   to the wheel *if* Jekyll ---               
    ## [126]                --- the hair stood upon my      head     like quills. Sir, *if* that ---            
    ## [127]                    --- he a mask upon his      face     ? *If* it was my master, ---               
    ## [128]                  --- *If* all is well, my   shoulders   are broad enough to bear ---               
    ## [129]                 --- _b_ You can keep your      arm      there, *if* you would like ---             
    ## [130]               --- let him slip through my    fingers    *if* I do n't mind, ---                    
    ## [131]                 --- suffer for what I was      born     to be, *if* it does ---                    
    ## [132]           --- it out. Certainly, *if* his     birth     was exactly when she says, ---             
    ## [133]                  --- *if* he is dead, his      body     is hidden in some corner ---               
    ## [134]              --- great head with her soft      hand    ; but *if* I had not ---                    
    ## [135]         --- blind submission to the awful      hand     of fatality. *If* that girl, ---           
    ## [136]                  --- _b_ _b_ *If* you can     sleep    , so much the better. *If* ---              
    ## [137]               --- more ! *If* a girl with    freckles   and white eylashes adored me, ---          
    ## [138]              --- baby, for *if* Wilson 's      arms     be like mine they are ---                  
    ## [139]                   --- *if* it rises in my     heart    ; perhaps never. It 's a ---                
    ## [140]             --- looking, and then shut my      eyes     to see *if* I can ---                      
    ## [141]                      --- 'll get a bit of     sleep     lying there, *if* he 's ---                
    ## [142]                 --- 'll never hold up his      head     again *if* he loses Jane. ---              
    ## [143]                  --- day will abide in my     heart    ; and *as* *long* *as* I ---                
    ## [144]               --- kiss, and looking in my      face     to see *if* I could ---                    
    ## [145]                --- look at her husband 's      back    , as looked all ear, *if* ---               
    ## [146]                --- 's back, as looked all      ear     , *if* ever a back did, ---                 
    ## [147]                  --- all ear, *if* ever a      back     did, 'Oh, we could take ---                
    ## [148]                --- enough to send thee to     sleep    . Try *if* thou canst keep ---              
    ## [149]            --- *if* thou canst keep thine      eyes     open while I read thy ---                  
    ## [150]                  --- scold a bit. *If* my      eyes     are left I can do ---                      
    ## [151]                --- say; but *if* a loving     heart     and a strong right arm ---                 
    ## [152]                  --- met wi' many o' your     kidney   ; and *if* I 'd ha' ---                     
    ## [153]              --- It would break mother 's     heart     *if* she knew what I ---                   
    ## [154]                 --- bed, and I feel their      eyes     on me everywhere. *If* I ---               
    ## [155]             --- moans, but could n't, his      face     hurt him so *if* he ---                    
    ## [156]            --- very cottage where she was      born    , *if* we could get it. ---                 
    ## [157]             --- remember her with her own      face     better, *if* he does not ---               
    ## [158]              --- his glass, and using his      arms     as steady as *if* he ---                   
    ## [159]                  --- a night (not to call     sleep    ), *if* things goes wrong to-morrow. ---    
    ## [160]              --- _b_ Asleep ! How could I     sleep     till I know 'd *if* ---                    
    ## [161]                   --- _b_ _b_ _b_ _b_ His    forehead   is not so low *if* ---                     
    ## [162]                     --- *if* I can lay my      hand     on the letter, which I ---                 
    ## [163]             --- eyes shut, he changes his     hands    . But *if* I go halves, ---                 
    ## [164]                  --- *if* he 'd had three     heads     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [165]  --- acquaintances, whether they 'd short     breath    or long. *If* we are ---                   
    ## [166]                 --- that trick wi' my big     thumb    , *if* you do n't think ---                 
    ## [167]                   --- got the luck in his     hands    ; and *if* I lose one ---                   
    ## [168]                     --- I can only say my      nose     is my own, for *if* ---                    
    ## [169]                --- gown was darned at the     elbows   . Now, *if* I were to ---                   
    ## [170]                   --- the end of my brown      skin    , *if* it is always to ---                  
    ## [171]                   --- sir, opens a man 's      eyes    ; and *if* the population is ---            
    ## [172]                    --- it out of Wakem 's     hands    . And *if* he knew that ---                 
    ## [173]              --- break every bone in your      body    , for your greater happiness, *if* ---      
    ## [174]          --- godmother, *if* you set your      face     against all the wonders I ---              
    ## [175]              --- whole soul. *If* I could      wake     back again into the time ---               
    ## [176]                   --- and take it in your      arms    , *if* you 'd be so ---                     
    ## [177]           --- with courage bold: *If* his     blood     's hot I 'll make ---                      
    ## [178]                  --- now I look into your      face    , *even* *if* I ca n't ---                  
    ## [179]             --- though she is not without     heart    , and *if* I felt 'worse ---                
    ## [180]                      --- _b_ I am in your     hands    . *If* you think she had ---                
    ## [181]                --- night, for she was too   insensible  to understand me. *If* she ---             
    ## [182]                   --- put her hand to his      head     to feel *if* there 's ---                  
    ## [183]                --- bonnet on; it makes my      head     so hot. I wonder *if* ---                  
    ## [184]               --- flowers out of yo'r own      hand    ; -- yo may come *if* ---                   
    ## [185]                   --- *if* all I 've been      born     for is just to work ---                    
    ## [186]                  --- *even* *if* I do n't     waken     all at once, I dream ---                   
    ## [187]                 --- I shall never see his      face     again -- for *if* he ---                   
    ## [188]                  --- ready to drop on the     heads     of the crowd, *if* they ---                
    ## [189]                    --- *if* yo 'd had one      body     after another coming in to ---             
    ## [190]                      --- and I 'll may be     sleep    , *if* th' cough will let ---               
    ## [191]                  --- say, she 'd give her      eyes     *if* he 'd marry her, ---                  
    ## [192]               --- shall put myself at her      feet     -- I must. *If* it ---                     
    ## [193]                --- 'd ha' given his right      hand     *if* it had never come ---                 
    ## [194]                        --- it is. I 'm so     sleepy    at night, that *if* I ---                  
    ## [195]              --- _b_ _b_ *If* your mother      goes     to sleep, be sure you ---                  
    ## [196]             --- _b_ *If* your mother goes       to      sleep, be sure you come ---                
    ## [197]              --- *If* your mother goes to     sleep    , be sure you come directly ---             
    ## [198]                --- myself, he ought to be     roused   ; and *if* it gives him ---                 
    ## [199]                     --- I am sure you are     tired    , *if* you 've been out ---                 
    ## [200]                      --- as I would do to     Fanny    , *if* she had gone gallivanting ---        
    ## [201]                   --- I told my son, *if*     Fanny     had done so we should ---                  
    ## [202]                  --- *If* you would; I 'd    swallow    my shadows of doubts, and ---              
    ## [203]             --- will put matters into the     hands     of my Milton attorney *if* ---             
    ## [204]             --- person " fat and scant o'     breath    " *if* I were Hamlet, Prince ---           
    ## [205]              --- ha' fretted his woman 's     heart     out, *if* he 'd seen ---                   
    ## [206]             --- has too much hardened our     hearts   . *If* you would say the ---                
    ## [207]                 --- mind, *if* not of the      body    , which seldom leaves a man ---             
    ## [208]                 --- *if* I dared, I would    breathe    my wishes that the name ---                
    ## [209]                 --- lay no embargo on any      body     's words. *If* you will ---                
    ## [210]                  --- *if* I press down my     thumb     to save you, may the ---                   
    ## [211]                   --- as *if* she had the      eyes     of Argus; and when one ---                 
    ## [212]          --- and distressed ! But *if* my     heart     whispers truly, I shall claim ---          
    ## [213]                --- _b_ _b_ _b_ *If* death     frowns    so near, I will say ---                    
    ## [214]                  --- see -- I release thy      hand    . Take it from me *if* ---                  
    ## [215]        --- have remembered. But thou hast      ears    , *if* not eyes. Do thy ---                 
    ## [216]              --- thou hast ears, *if* not      eyes    . Do thy fellow-slaves tell thee ---        
    ## [217]                 --- see at least *if* the      face     correspond in loveliness with the ---      
    ## [218]          --- be overheard, and *if* other      ears     than mine had drunk those ---              
    ## [219]       --- Atheist ! away ! the earth will    swallow    us, *if* we suffer these ---               
    ## [220]            --- and stand blackened in the      eyes     of love ? *If* to earn ---                 
    ## [221]                  --- god. By my father 's      head     ! *if* his deityship were never ---        
    ## [222]           --- and bubble before the demon    breathes   upon it; *if* in the ---                   
    ## [223]               --- must gag thee again. My   shoulders   will smart for it, *if* ---                
    ## [224]                --- the soul asleep in the      arms     of love. And *if* this, ---                
    ## [225]              --- Jane success with all my     heart    ; and *if* she were married ---             
    ## [226]               --- He has a very satirical      eye     , and *if* I do not ---                     
    ## [227]                      --- I do still at my     heart    ; and *if* a smart young ---                
    ## [228]          --- the advantage of holding her     tongue   ; and *if* you can compass ---              
    ## [229]                    --- _b_ _b_ _b_ he may       go      to bed, *if* he chooses, ---               
    ## [230]                     --- _b_ _b_ he may go       to      bed, *if* he chooses, before ---           
    ## [231]                      --- _b_ he may go to      bed     , *if* he chooses, before it ---            
    ## [232]             --- herself well in a foreign     tongue   , but still, *if* she has ---               
    ## [233]                --- cards were in your own     hands     *if* you chose to play ---                 
    ## [234]               --- this here cut; that was     serous   ; and *if* I had n't ---                    
    ## [235]            --- mine. Deign to retain this      hand     ! *If* I be a noble ---                    
    ## [236]             --- for the fatal accident of     birth    , *if* it deprives me of ---                
    ## [237]           --- too singing something in my      ear      these two days past. *If* ---              
    ## [238]                --- should feel for one 's     flesh     and blood, and *if* I ---                  
    ## [239]                  --- for one 's flesh and     blood    , and *if* I find him ---                   
    ## [240]               --- _b_ _b_ Then, *if* your     heart     does, why not your hand ---                
    ## [241]              --- *if* it should reach the      ears     of your friends at Emminster ---           
    ## [242]                  --- *if* he had held his     tongue   . I can not help associating ---            
    ## [243]                   --- 'll see *if* she is     awake     _b_ _b_ _b_ _b_ _b_ ---                    
    ## [244]                 --- the roses too to your     cheeks   , *if* I may so speak ---                   
    ## [245]                --- No, run me through the      body     *if* I am _b_ _b_ ---                      
    ## [246]               --- but you tried. Ask your     heart     *if* you did not _b_ ---                   
    ## [247]                  --- and I think I should     sleep     better *if* I had my ---                   
    ## [248]                 --- _b_ _b_ _b_ Hold your     tongue   , *if* you please. I know ---               
    ## [249]                --- all. I could read your     heart    , Sir Pitt. *If* I had ---                  
    ## [250]             --- strike a light, *if* your     tears     drop so fast into the ---                  
    ## [251]              --- be my pleasure, *if* her     breath    were sweet. I ask thee ---                 
    ## [252]                  --- In the warmth of his     heart     he asked *if* there was ---                
    ## [253]                  --- clear, *if* I have a      head     for anything, it is for ---                
    ## [254]                     --- _b_ *If* I have a      head     for everything, I have a ---               
    ## [255]               --- *if* you did, sir, your     cheek     would be paler, and your ---               
    ## [256]                   --- at our bars (here a     hiccup   ). *If* you be poachers, our ---            
    ## [257]           --- game in the forest (another     hiccup   ); but *if* ye be good ---                  
    ## [258]                    --- that *if* a man 's     mouth     be open, it should be ---                  
    ## [259]            --- be delivered into your own     hands    . *If* Mr. von Philipson determine ---      
    ## [260]                   --- as safe *if* I were    sleeping   in a burning house as ---                  
    ## [261]              --- picking, once a day, the     breast    of a pheasant; why, *if* ---               
    ## [262]                   --- _b_ _b_ I could not      wake     Mr. Beckendorff, sir, *if* the ---         
    ## [263]                  --- hare, or dine on the     haunch    of a bounding stag ? *If* ---              
    ## [264]         --- bounding stag ? *If* so, your     teeth     are sharper than mine. Can ---             
    ## [265]                --- 's day ? *If* so, your      ears     are finer than mine. Can ---               
    ## [266]                 --- shall not rest *if* I       go      to bed; so be good ---                     
    ## [267]                    --- not rest *if* I go       to      bed; so be good enough ---                 
    ## [268]                     --- rest *if* I go to      bed     ; so be good enough to ---                  
    ## [269]               --- odd. *If* you wash your      face     and brush your hair, it ---                
    ## [270]                  --- have his share of my      hand    , *if* I catch him downstairs ---           
    ## [271]                --- 'd wrench them off her    fingers   , *if* they ever menaced me ---             
    ## [272]          --- the curate should have his -     teeth     dashed down his - throat, *if* ---         
    ## [273]         --- his - teeth dashed down his -     throat   , *if* he stepped over the ---              
    ## [274]              --- heart out, and drunk his     blood     ! But, till then - *if* you ---            
    ## [275]                     --- *If* I can get my      arm      out I can hit him ! " ---                  
    ## [276] --- him ? " exclaimed Joseph, lifting his     hands     and eyes in horror. " *If* ---             
    ## [277]         --- Joseph, lifting his hands and      eyes     in horror. " *If* iver I ---               
    ## [278]      --- Hindley: Hindley has exactly her      eyes    , *if* you had not tried ---                
    ## [279]               --- you. Nelly, *if* you be     tired     you may sit down; *if* ---                 
    ## [280]          --- expectations. *If* he were a      born     fool I should not enjoy ---                
    ## [281]            --- number of cats, *if* their     teeth     be drawn and their claws ---               
    ## [282]                    --- 'll have her in my      arms     again ! *If* she be cold, ---              
    ## [283]          --- _b_ you 'll leave sufficient     behind    to cover your debts, *if* ---              
    ## [284]               --- a fine explosion on the      head     of it: see *if* we ---                     
    ## [285]         --- confine your insolence to her      ears    . As to Hareton Earnshaw, *if* ---          
    ## [286]                  --- and you will win his     heart    . Upon my word, *if* you ---                
    ## [287]           --- who would have opened their      eyes     in astonishment, *if* they had ---         
    ## [288]        --- construction ! I will close my      eyes     again, *if* you will allow ---             
    ## [289]               --- *as* *long* *as* I draw     breath   . Your mother 's daughter has ---           
    ## [290]                 --- has been put into his      head     by others. *If* there are ---              
    ## [291]                    --- *if* I know my own     heart    , never _b_ _b_ _b_ _b_ ---                 
    ## [292]          --- were changed, and *if* those     tears     were mine. All your love ---               
    ## [293]              --- *If* you can moisten its      lips     with the milk, Miss Halcombe, ---          
    ## [294]                   --- both of them in the      face     boldly. *If* through any extraordinary --- 
    ## [295]             --- shall doubt *if* your own      eyes     and ears are really of ---                 
    ## [296]                --- *if* your own eyes and      ears     are really of any use ---                  
    ## [297]                    --- *if* I had gone on     crying   , but his contempt dried up ---             
    ## [298]            --- mother ! *If* I could only      wake     at her side, when the ---                  
    ## [299]              --- outrage. *If* you hurt a      hair     of Laura 's head, *if* ---                 
    ## [300]                    --- a hair of Laura 's      head    , *if* you dare to interfere ---            
    ## [301]                    --- would n't go to my     heart     so to lose her *if* ---                    
    ## [302]                 --- _b_ _b_ Never mind my     crying    *if* I can be of ---                       
    ## [303]                  --- _b_ Try *if* you can     rouse     her _b_ _b_ _b_ _b_ ---                    
    ## [304]                     --- I 'm strong on my      legs     still ! *As* *long* *as* a ---             
    ## [305]           --- and the most particular man   breathing  . *As* *long* *as* he lived ---             
    ## [306]                --- *if* Laura had seen my      face     at that moment ---- Thank ---              
    ## [307]            --- mother ! *If* I could only      wake     at her side when the ---                   
    ## [308]                   --- put my life in your     hands    . *If* what I say to ---

``` r
# N3.4 ["Measurement: Volume"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("N3.4"), context = 0)
y
```

    ## [1] --- severely simple cap on her head, and a *volume* of sermons --- 
    ## [2] --- *volume* of sermons on her  lap. She turned up the whites ---

``` r
# I1.3+ ["Money: Price"]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("I1.3+"), context = 0)
y
```

    ## [1] --- put that *mark* *upon* your throat _b_ _b_ _b_ _b_ _b_ ---                   
    ## [2]         --- the roll of the red  eyes  and the fearful blackened *inflation* --- 
    ## [3]        --- a new asylum in your  heart. *Priceless* asylum ! -- I envy ---

``` r
# S7.4+ ["Permission" +]
y <- corp_concordance(quotes_surface, nodes = nodes, collocates= c("S7.4+"), context = 0)
y
```

    ## [  1]                      --- _b_ _b_ _b_ Hold your      tongue     , ca n't ye ? and *let* ---                       
    ## [  2]                   --- _b_ Lily, you *let* your      tongue      run too fast _b_ _b_ ---                         
    ## [  3]                  --- *right* to dispose of our      hearts      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [  4]                     --- the boy *let* the lamp       blow       out as she was going ---                         
    ## [  5]                    --- boy *let* the lamp blow        out       as she was going home, ---                       
    ## [  6]                --- *right* to dispose of their       hands      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [  7]                     --- n't *let* you touch my       hand       except to shake hands with ---                   
    ## [  8]                    --- you must n't *let* your       foot       go astray in that way; ---                       
    ## [  9]                   --- prevent her, even if her       heart      *permitted* it. Oh ! dear; it ---                
    ## [ 10]                 --- punishment of death at our       hands     . I beseech you, Vetranio, *let* ---              
    ## [ 11]                     --- forced on me from your       lips      ; *let* us remember only that ---                 
    ## [ 12]               --- that is *provided* *for* the      palates     of my guests ! We sit ---                        
    ## [ 13]                    --- damnation be on his own       head       ! Anathema ! Maranatha ! *Let* him die ---       
    ## [ 14]                      --- *let* me look at your       foot       _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 15]                         --- when I lay on your       bosom     , than have *let* me live ---                     
    ## [ 16]                        --- it, and *let* me go       back       _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 17]                   --- and some other person 's       hand       may *let* the broad daylight ---                 
    ## [ 18]                        --- I *let* him kiss my       hand       before he went. He promised ---                  
    ## [ 19]           --- never *letting* Mr. Armadale set       eyes       on me, or hear of ---                            
    ## [ 20]                       --- _b_ _b_ " I *let* my       cheek      touch his again. _b_ _b_ ---                     
    ## [ 21]                      --- be void. ' I 'll take      breath      here if you 'll *allow* ---                      
    ## [ 22]                   --- believed) cut her to the       heart     . She burst out crying (*let* ---                 
    ## [ 23]                   --- the heart. She burst out      crying      (*let* her alone for crying ---                  
    ## [ 24]         --- name is unpronounceable by English       lips      . *Let* us give her her ---                       
    ## [ 25]                        --- I *let* him kiss my       hand      , and sent him off to ---                         
    ## [ 26]                 --- sealed. A woman of Spanish       blood      does not *condone* such an ---                   
    ## [ 27]               --- *let* us hope, to refreshing     slumbers    , at the Angel Hotel; but ---                     
    ## [ 28]                    --- *let* me fasten up your       hair      , mamma _b_ _b_ _b_ _b_ ---                       
    ## [ 29]                  --- _b_ *Let* us be thankful,       Fanny     . She is in a position ---                        
    ## [ 30]                  --- _b_ They were all getting       tired      of me; *let* us hear ---                         
    ## [ 31]                 --- departed. I said, *let* my       body       dwell in poverty, and my ---                     
    ## [ 32]                         --- my hands be as the       hands      of the toiler: but *let* ---                     
    ## [ 33]             --- will not cherish the prophetic   consciousness  of our nationality -- *let* ---                  
    ## [ 34]                      --- *Let* me look at your       hand       again: the hand with the ---                     
    ## [ 35]                       --- There is joy in your       face       -- *let* the joy be ---                          
    ## [ 36]                  --- pass away as this fleshly       body       will pass; but *let* the ---                     
    ## [ 37]                     --- *Let* me give you your sleeping-draught, Gwendolen _b_ _b_ _b_ _b_ ---                   
    ## [ 38]                          --- I am to *let* you       stay       up so long. You must ---                         
    ## [ 39]                       --- am to *let* you stay        up        so long. You must make ---                       
    ## [ 40]              --- _b_ " P.S.-- My patient being      asleep     , I open this to *let* ---                        
    ## [ 41]                     --- he *let* me stroke his       ears       same as ever. That there ---                     
    ## [ 42]                 --- open, there was n't enough       blood      in her to *let* her ---                          
    ## [ 43]                 --- conscious or in her sleep.       Wake       that poor boy, and *let* ---                     
    ## [ 44]                      --- my time, my skill, my       sleep     . I *let* my other sufferers ---                  
    ## [ 45]                      --- You will give me your       hand      , will you not ? And *let* ---                    
    ## [ 46]                      --- You do not *let* your       eyes       see nor your ears hear, ---                      
    ## [ 47]                    --- _b_ _b_ She is possibly       tired     . *Let* dinner wait an hour ---                   
    ## [ 48]                    --- all who suffer from the       heart     . Will you *let* me be ---                        
    ## [ 49]                     --- you look, sir, into my       heart     , you would *approve* to the ---                  
    ## [ 50]                --- God, *let* these poor white       hairs      go in evidence of what ---                       
    ## [ 51]                     --- must meet death at any       hand      , *let* it be at the ---                          
    ## [ 52]                         --- *let* it be at the       hand       of him that loves me ---                         
    ## [ 53]                --- Madam Mina *right* into the       heart      of the enemy 's country. ---                     
    ## [ 54]                  --- *right* of judging of any       body       's performance. -- I have ---                    
    ## [ 55]                    --- *let* us stand a little       back      , Mrs. Elton is going; dear ---                   
    ## [ 56]             --- first in February. *Let* every       body       on the Hill hear me ---                          
    ## [ 57]     --- most good-humoured dependence on every       body       's *assent*) -- Do not ---                       
    ## [ 58]                    --- is found out that every       body       knows them. Only *let* me ---                    
    ## [ 59]                        --- but the fever of my       blood      did not *allow* me to ---                        
    ## [ 60]                  --- were the worst: they shed       blood      they had no *right* to ---                       
    ## [ 61]                    --- of the condition of the     entrails    : *let* your operation be conducted ---           
    ## [ 62]                     --- can she do ? *Let* her       sleep      unmolested _b_ _b_ _b_ _b_ ---                   
    ## [ 63]                           --- _b_ No: I am too      thirsty     to eat. Will you *let* ---                       
    ## [ 64]     --- yet harmonious lineaments, the Grecian       neck       and bust; *let* the round ---                    
    ## [ 65]               --- *let* the round and dazzling        arm       be visible, and the delicate ---                 
    ## [ 66]                   --- *right* to expect at his       hands     . Be sure that is the ---                         
    ## [ 67]                --- *consented* to gift with my       hand       _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 68]                  --- Jane, you offered me your     shoulder     once before; *let* me have ---                   
    ## [ 69]                       --- had no *right* to be       born      , for you make no use ---                         
    ## [ 70]                      --- *let* me look at your       face      : turn to the moonlight _b_ ---                   
    ## [ 71]                --- well as penetrating in your        eye      ; but *allow* me to assure ---                    
    ## [ 72]                      --- am ashamed of my long      tongue     . *Let* us make a bargain ---                     
    ## [ 73]                      --- you *let* me see your       face       _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 74]                         --- of you to *let* it       sleep      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 75]                      --- *let* us make a clean      breast     . This masked figure that you ---                 
    ## [ 76]                     --- _b_ *Let* me take your       hand      , darling _b_ _b_ _b_ _b_ ---                     
    ## [ 77]                      --- to *let* you try your       hand       in his school ? If you ---                       
    ## [ 78]                   --- *let* Mr. Fawley hold my       hand       a long while. I do ---                           
    ## [ 79]                     --- at her, and *lets* his       eyes       rest on her. I am ---                            
    ## [ 80]                 --- a choking sensation, in my      throat      that would n't *let* me ---                      
    ## [ 81]                      --- and *let* mine be the       hand       to avenge his untimely death ---                 
    ## [ 82]                      --- _b_ _b_ _b_ Hold your      tongue     , girl, and *let* me think ---                    
    ## [ 83]                       --- _b_ _b_ and *let* me       sleep      ! *Let* me sleep, for my ---                     
    ## [ 84]                  --- *let* me sleep ! *Let* me       sleep     , for my brain is on ---                          
    ## [ 85]                     --- *Let* me sleep, for my       brain      is on fire _b_ _b_ ---                           
    ## [ 86]              --- *right* because of his broken        arm       _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 87]                        --- it, but it made its       mouth      like a square, and *let* ---                     
    ## [ 88]                          --- with it, ' but my       heart      would na *let* me say ---                        
    ## [ 89]                        --- coals of fire on my       head       ! O Mary, do n't *let* ---                       
    ## [ 90]                   --- *let* it clem before his       eyes      ; and he were a tender-hearted ---                
    ## [ 91]                       --- and would be glad to       sleep     . Do n't *let* him get ---                        
    ## [ 92]                      --- in that silly way. My       heart      has a better *right* to ---                      
    ## [ 93]               --- *let* grass grow under their       feet      , in hunting out the man ---                      
    ## [ 94]                        --- and one look at thy       face       will *let* 'em into th' ---                      
    ## [ 95]                       --- _b_ _b_ _b_ *Let* me       stay       up a little _b_ _b_ ---                          
    ## [ 96]                      --- _b_ _b_ *Let* me stay        up        a little _b_ _b_ _b_ ---                         
    ## [ 97]                  --- good gell, an' *let* your       hair       be brushed, an' put your ---                     
    ## [ 98]                         --- a man that 's wide       awake     , *let* me tell you. Drop ---                     
    ## [ 99]                   --- must *let* me study your       face       a little, while you stay, ---                    
    ## [100]        --- to-morrow, then; hold your insolent      tongue      and *let* me pass _b_ ---                        
    ## [101]                   --- other way. Now, *let* me        go        off to sleep _b_ _b_ ---                         
    ## [102]                     --- -- *let* me make haste       back       _b_ _b_ _b_ _b_ _b_ ---                          
    ## [103]                       --- what is wise; but my       heart      will not *let* me do ---                         
    ## [104]                     --- 'll *let* you stay and       sleep      in my bed. He wo ---                             
    ## [105]                 --- *allow* you. Thank God she      sleeps      so well: I hope she ---                          
    ## [106]                        --- to *let* a few grey       hairs      show themselves in the hussy ---                 
    ## [107]                    --- be *allowed* to have my       hand       as soon as you bring ---                         
    ## [108]                  --- thought I would *let* you       sleep      on till she returned _b_ ---                     
    ## [109]                     --- You *let* me hold your       hand       when you were a maiden ---                       
    ## [110]                           --- and I 'll may be       sleep     , if th' cough will *let* ---                     
    ## [111]                     --- it; *Let* 'em have ten       tire       of teeth a-piece, I care ---                     
    ## [112]                     --- olive: *let* me make a       face       while I swallow it. I ---                        
    ## [113]                     --- _b_ _b_ *Let* not your       heart      be troubled _b_ _b_ _b_ ---                      
    ## [114]               --- would not have *approved* of       Fanny      's being seen out, after ---                     
    ## [115]                --- no loss of strength, either      bodily      or mental. Do n't *let* ---                      
    ## [116]                     --- Ah ! *let* me close my       eyes       and dream _b_ _b_ _b_ ---                        
    ## [117]                     --- we can master eyes, or       cheek     , or tongue, Nor *let* the ---                    
    ## [118]                  --- master eyes, or cheek, or      tongue     , Nor *let* the smallest tell-tale ---            
    ## [119]                       --- to *let* us have the       back       drawing-room undisturbed, as it was ---          
    ## [120]                    --- they must wait till her       brain      was set to *right*. But ---                      
    ## [121]                      --- pen has been in their       hands     . I will not *allow* books ---                    
    ## [122]                  --- matters not: *let* me not       rouse      your indignation against one who ---             
    ## [123]                  --- of my thoughts. *Let* thy        ear       catch every accent, every modulation ---         
    ## [124]                   --- own brother; give me thy       hand      , *let* me wipe the dew ---                       
    ## [125]          --- powerful poisons. *Let* the lover      breathe     his vows to the Shades ---                       
    ## [126]                   --- thou wilt *permit* me to       sleep      beneath thy roof, I will ---                     
    ## [127]                     --- _b_ _b_ _b_ place your       hand       upon my brow; *let* me ---                       
    ## [128]                    --- place your hand upon my       brow      ; *let* me feel your cool ---                     
    ## [129]                    --- injured one hair of the       head       of him she loved ! *Let* ---                     
    ## [130]                       --- *let* me fold up thy       face       and eyes _b_ _b_ _b_ ---                         
    ## [131]                   --- *let* thy voice reach my        ear       through this narrow passage, and ---             
    ## [132]                          --- -- take me to thy       arms       ! One embrace ! *let* me feel ---                
    ## [133]                --- embrace ! *let* me feel thy       arms       around me -- and in ---                          
    ## [134] --- scrolls of Epicurus, Pythagoras, Diogenes;        arm       yourself for defeat; and *let* ---               
    ## [135]                  --- be *entitled* to. On that       head      , therefore, I shall be uniformly ---             
    ## [136]                      --- all of you, hold your      tongues    , and *let* me and Mr. ---                        
    ## [137]                     --- my glove, and *let* my       hand       just rest upon the window ---                    
    ## [138]            --- for your *approbation* alone. I      roused     , and interested you, because I ---               
    ## [139]          --- presumes to smile *approval*, nor       frown      disapprobation; her little hands assiduously --- 
    ## [140]                   --- *letting* us hold up our       heads      again. I shall write to ---                      
    ## [141]                  --- *let* it escape from your       hands      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [142]                       --- she. 'I 'll claw his       face       for'n, *let* me only catch ---                   
    ## [143]                     --- _b_ _b_ *Let* not your       heart      be troubled, neither *let* it ---                
    ## [144]                   --- _b_ *Let* her finish her       sleep      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [145]                       --- *let* me say, for my       heart      warms to you, it does ---                        
    ## [146]                      --- to *let* me press the       hand       from which I have received ---                   
    ## [147]                 --- avoid you ? *Let* your own       heart      answer that question. Do you ---                 
    ## [148]                   --- him shrieking out of her       arms      , and have never *allowed* him ---                
    ## [149]                --- Felix Lorraine. There is my       hand      ; and now *let* the Elfin ---                     
    ## [150]                  --- to be *indulgent* to bold      hearts     , verily, we will wink at ---                     
    ## [151]              --- really have no inclination to       sleep     , *let* us sit down and ---                       
    ## [152]             --- these lamps and dresses ! your        arm       ! *Let* us walk for a ---                        
    ## [153]                   --- must *let* the teller 's      breath      come out of his own ---                          
    ## [154]                     --- to *let* me stretch my       legs       on after four-and-twenty hours ' ---             
    ## [155]              --- should, perhaps, have held my      tongue     , and *let* you fall into ---                     
    ## [156]                       --- do *let* me have one      breath      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [157]                      --- n't *let* me see your       eyes       ! I forgive what you have ---                    
    ## [158]                   --- and suckless as you your      cheeks      are bloodless; *let* us take ---                 
    ## [159]                      --- *let* us take hold of       hands      and run. You 're so ---                          
    ## [160]                      --- *let* me lean on your       knee      . That 's as mamma used ---                       
    ## [161]          --- Catherine, you are *letting* your       tears      fall into my cup. I ---                          
    ## [162]             --- construction ! I will close my       eyes       again, if you will *allow* ---                   
    ## [163]                    --- beard was shaven on his       chin      , but was *let* to grow, ---                      
    ## [164]                       --- be my only chance of      hearing     what your wishes are. *Let* ---                  
    ## [165]                     --- *let* him see that the       tears      were in my eyes. I ---                           
    ## [166]                        --- Is the mark on your        arm       still ? *Let* me see it ---                      
    ## [167]                      --- in, and *let* her own       eyes       satisfy her that there is ---                    
    ## [168]                 --- that letter unopened in my       hands     , and you then *allow* me ---

### Concordances of “semantic tag collocates”: Non-quotes

``` r
# N3.4- ["Measurement: Volume" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.4-"), context = 0)
y
```

    ## [ 1]             --- some means of *compressing* his   waist  into a remarkably small compass; ---                
    ## [ 2]  --- paleness that discoloured her *compressed*   lips  , the spasms that shook her ---                      
    ## [ 3]               --- supported upon his staff, his   lips   firmly *compressed*, his brow slightly ---          
    ## [ 4]           --- his lips firmly *compressed*, his   brow   slightly frowning, and his attitude ---             
    ## [ 5]      --- firmly *compressed*, his brow slightly frowning, and his attitude firm and ---                      
    ## [ 6]             --- old *compressed* state, and her   eyes   dwelt on all things with ---                        
    ## [ 7]    --- amber-colored garment, her little Jewish   nose   lengthened by *compression* of the ---              
    ## [ 8]          --- lengthened by *compression* of the    lip   in the effort to make ---                           
    ## [ 9]               --- a bitter *compression* of her    lip  , then let her voice fall ---                        
    ## [10] --- -- *compressed*, condensed, controlled. The   heart  was thrilled, the mind astonished, ---              
    ## [11]      --- me fixedly, *compressing* his well-cut   lips   while he did so. Whether ---                        
    ## [12]                      --- He came down then, his   face   *compressed* like that of one ---                   
    ## [13]                     --- face and the light gray   eyes  , the small features and *compressed* ---            
    ## [14]         --- the small features and *compressed*   lips  , there was something which hinted ---               
    ## [15]                    --- to a dead whiteness; the   lips   *compressed* as if to keep ---                      
    ## [16]                 --- face, strung and rigid; her   lips   *compressed* tight, to keep down ---                
    ## [17]             --- this with the same *compressed*   lips  , and the same stony look ---                        
    ## [18]             --- the bar stood with *compressed*   lips  , looking at the judge with ---                      
    ## [19]      --- something hard *compressed* within her   hand   would help her to listen, ---                       
    ## [20]                      --- and the corners of his   mouth  rebel against the *compression* which ---           
    ## [21]               --- and lay principally about the   lips  , which were slightly *compressed* over ---          
    ## [22]                  --- *compressed* over a set of   teeth  so faultless and beautiful as ---                   
    ## [23]            --- very white, and *compressed* her   lips   a little more. Otherwise not ---                    
    ## [24]                   --- clasped on her knees, her   lips   *compressed*, her eyes fixed as ---                 
    ## [25]           --- knees, her lips *compressed*, her   eyes   fixed as one who sees ---                           
    ## [26]                     --- half over her eyes; her   teeth  were shut, not *compressed*; her ---                
    ## [27]            --- were shut, not *compressed*; her   lips   were just parted over them, ---                     
    ## [28]           --- _b_ _b_ Margaret *compressed* her   lips  . She would not speak in ---                         
    ## [29]                  --- married. Then she knit her   brows , and pinched and *compressed* her ---               
    ## [30]            --- and pinched and *compressed* her   lips   tight, and carefully unpicked the ---               
    ## [31]            --- a stern thought *compressed* her   brows , and caused her to set ---                          
    ## [32]                    --- his mind; and though his   mouth  was as much *compressed* as ---                     
    ## [33]            --- much *compressed* as before, his   eyes   smiled out benignly on his ---                      
    ## [34]                    --- did not tremble -- their   lips   were *compressed* and rigid. The ---                
    ## [35]                  --- sat a moment thinking, his   lips   *compressed*, his brow knit. I ---                  
    ## [36]        --- thinking, his lips *compressed*, his   brow   knit. I had nothing to ---                          
    ## [37]        --- developed but not compactly moulded,   waist  disproportionately *compressed* by an inhumanly --- 
    ## [38]                        --- a hard look, for the   brow   to *compress* its expense into ---                  
    ## [39]                      --- that cloud on his bony   brow   -- for that *compression* of ---                    
    ## [40]        --- that *compression* of his statuesque   lips  , the lad will some day ---                          
    ## [41]                 --- fixed and eager glance, the   mouth  *compressed* with fierce resolution or ---          
    ## [42]            --- and cold, his small *compressed*   mouth  indexing his powers of self-control; ---            
    ## [43]      --- Mrs. Felix Lorraine, with *compressed*   lips   and looks of horrible earnestness, ---              
    ## [44]                   --- His cheek was sallow, his   nose   aquiline, his mouth *compressed*. His ---           
    ## [45]              --- sallow, his nose aquiline, his   mouth  *compressed*. His ears, which were ---              
    ## [46]       --- aquiline, his mouth *compressed*. His   ears  , which were uncovered, were so ---                  
    ## [47]            --- manage it; and *compressing* his   mouth  he held a silent combat ---

``` r
# H4- ["Residence" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("H4-"), context = 0)
y
```

    ## [ 1]                 --- of this young man. His   eyes   were heavy and *vacant*, his ---            
    ## [ 2]           --- were heavy and *vacant*, his forehead low and retiring, his cheeks ---            
    ## [ 3]             --- in that *vacant* and heavy    eye   a ray of its native ---                     
    ## [ 4] --- with affrighted looks and undissembled   tears . Carrio stared in *vacant* astonishment --- 
    ## [ 5]            --- on him with fixed, *vacant*   eyes  . At length a deep sigh ---                  
    ## [ 6]   --- glaring with *vacant* and affrighted   eyes   upon the open dwelling before ---           
    ## [ 7]                 --- one moment the girl 's    eye   met the sentinel 's *vacant* ---            
    ## [ 8]             --- dead silence of night. His   eyes   lost their *vacant* expression; he ---      
    ## [ 9]                     --- by her side to her sleeping father, as her one *vacant* ---             
    ## [10]              --- the suburbs. She kept her   head   turned towards the *vacant* entrance, ---   
    ## [11]       --- the *vacant* entrance, fixed her   eyes   on it in the unintermitting ---             
    ## [12]       --- of the terrible catastrophe: his   eyes   were glassy and *vacant*, his ---           
    ## [13]          --- were glassy and *vacant*, his   lips   parted and rigid; even the ---              
    ## [14]               --- passed his hand over his   head   in a *vacant*, bewildered way. ---          
    ## [15]            --- a plaited coronet above her forehead, and escaped in one *vagrant* ---           
    ## [16]             --- at the woman with *vacant*   eyes  , and without attempting to answer ---       
    ## [17]                      --- of it, and had no   eyes   for the spirits that *walk* ---             
    ## [18]         --- *vacant* stare from his target   eyes   _b_ _b_ _b_ _b_ _b_ ---                     
    ## [19]                --- young man lifted up his   head  , and gazed with a *vacant* ---              
    ## [20]                 --- lips were apart -- the    eye   *vacant* and unheeding -- and ---           
    ## [21]        --- usual toil. Her long melancholy  visage  and *vacant* stare at Morley ---            
    ## [22]             --- the girl with the *vacant*   face   and the back like a ---                     
    ## [23]              --- the *vacant* face and the   back   like a grasshopper _b_ _b_ ---              
    ## [24]        --- full uniform, with his *vacant*   eyes   fixed on no object. The ---                 
    ## [25]                    --- With a sweep of his   hand   he cleared a *vacant* space ---             
    ## [26]            --- to an *unoccupied* desk. My   hands  were trembling -- my head ---

``` r
# A1.3- ["Caution" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("A1.3-"), context = 0)
y
```

    ## [ 1]             --- it passed *unheeded* before the      eyes     of the scarce conscious father. ---               
    ## [ 2]            --- *carelessly* in his great, horny     hands     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 3]            --- her figure *carelessly* with his      foot     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [ 4]                  --- more rose painfully to his      feet    . *Heedless* of Antonina 's entreaties, ---        
    ## [ 5]            --- have charmed the most *careless*      eye      and exalted the most frivolous ---                
    ## [ 6]                  --- of the apartment, when the   hunchback  , who had followed him *unheeded*, ---             
    ## [ 7]                  --- the torch dropped from his      hand    , and smouldered *unheeded* on the ---             
    ## [ 8]          --- which they would have *carelessly*    quaffed    at one draught, were viewed ---                   
    ## [ 9]             --- crumpled up *carelessly* in the breast-pocket of the coat. It was ---                           
    ## [10]       --- take leave, *impulsively* offered his      hand    , and then, with a sudden ---                      
    ## [11]           --- seized Allan *impulsively* by the      hand    . At the same moment the ---                       
    ## [12]            --- Allan turned *carelessly* on his      heel     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [13]                   --- _b_ Miss Gwilt seized his      hand     *impulsively* _b_ _b_ _b_ _b_ ---                 
    ## [14]                --- a *careless* movement of the      head     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [15]             --- part of rescued *prodigal*, and    rousing    a feeling quite distinct from ---                 
    ## [16]               --- _b_ flew *impetuously* to her      lips     -- but did not pass ---                           
    ## [17]             --- himself, fell *unheeded* on his      ear     . He collected together from all ---               
    ## [18]                 --- by *careless* locks of fair      hair    . _b_ _b_ _b_ _b_ _b_ ---                          
    ## [19]            --- _b_ She *impulsively* seized his      hand    , and leaving a reproachful look ---               
    ## [20]        --- eaten, Jude *impulsively* placed his      hand     upon hers; she looked up ---                      
    ## [21]          --- thrown *carelessly* upon his black      hair    . His name was George Talboys, ---                 
    ## [22]        --- his delighted canaries, a *slipshod*      foot     upon the staircase without bespoke ---            
    ## [23]             --- cards in Robert 's *incautious*      hand    . But among all the mass ---                       
    ## [24]          --- brushed *carelessly* away from her      face     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [25]                --- had fallen on an *unheeding*      ear     , there were always young men ---                  
    ## [26]                    --- the storm that round his      head     *Impetuous* sweeps. God help thee, ---            
    ## [27]                --- He *carelessly* gave her his      hand     _b_ _b_ _b_ _b_ _b_ ---                           
    ## [28]                     --- _b_ _b_ _b_ reached his      ears     in the rich, *impetuous* accents ---              
    ## [29]                      --- -- had passed into his     hands    . Wildeve was *reckless*, frantic, exasperated --- 
    ## [30]              --- before rolling slowly down her     cheeks   , and dropping, *unheeded*, on her ---             
    ## [31]             --- but never *unheeded* again. His     heart     throbbed loud and quick Strong ---                
    ## [32]          --- muscles, whose short and Herculean     necks    , whose hardy and *reckless* countenances, ---     
    ## [33]                  --- more resumed the lyre, and      woke     its strings with a *careless* ---                 
    ## [34]               --- its strings with a *careless*      hand     to a strain, so wildly ---                        
    ## [35]         --- the Egyptian, *impetuously*, as the     blood     rushed to his cheek _b_ ---                       
    ## [36]                 --- Ione, and raising her right      arm     , when Glaucus burst *impetuously* on ---          
    ## [37]                       --- tone, and a few large     tears     rolled *unheeded* down her cheeks ---             
    ## [38]            --- tears rolled *unheeded* down her     cheeks    _b_ _b_ _b_ _b_ _b_ ---                           
    ## [39]             --- his gorgeous hues, charming the      ear      with his *blithesome* song -- ---                 
    ## [40] --- rolled, indestructive, *unheeded*, over its      head    ; and now the last ray ---                         
    ## [41]                --- Mr. Darcy appeared. Her pale      face     and *impetuous* manner made him ---               
    ## [42]    --- clean but *careless* dress, ill-arranged      hair     (compared with the tight and ---                  
    ## [43]                   --- in ruling their books, my      eye     , ranging *carelessly* over the benches, ---       
    ## [44]          --- was twisted *carelessly* round his      neck    , and fastened with a very ---                     
    ## [45]                 --- played in a very *careless*      hand    . He had taken it, though ---                      
    ## [46]                   --- very white frock upon her      back     which she had so *carelessly* ---                 
    ## [47]            --- _b_ said Tess *impetuously*, the     tears     welling to her eyes _b_ ---                       
    ## [48]         --- turning *impetuously* upon him, her      eyes     flashing as the latent spirit (---                
    ## [49]        --- prettily tucked-up milking gown, her      hair     *carelessly* heaped upon her head ---             
    ## [50]           --- hair *carelessly* heaped upon her      head     till there should be leisure ---                  
    ## [51]        --- she said, *impetuously* clasping her     hands    . _b_ _b_ _b_ _b_ _b_ ---                          
    ## [52]               --- *blithely* and so archly, her      foot     on the cradle, which she ---                      
    ## [53]            --- Instead of answering, Tess, with     tears     in her eyes, *impulsively* faced ---              
    ## [54]               --- The bold and *reckless* young     blood     of ten-years back was subjugated ---              
    ## [55]         --- *reckless* young blood of ten-years      back     was subjugated and was turned ---                 
    ## [56]             --- the pleasant holidays, the kind     faces    , the *careless*, joyful past times, ---           
    ## [57]                  --- fair. Bowing, he threw his      hand     *carelessly* over his mandolin, and ---           
    ## [58]                --- he tossed, with a *careless*      hand    , the great horn upside downwards, ---             
    ## [59]                --- this day of seeing different     faces    , and of improvising his *unpremeditated* ---      
    ## [60]         --- some *carelessly* twisted round her      head    . Probably she had not touched ---                 
    ## [61]                      --- at the table, with his     hands     *carelessly* thrust into the scarlet ---          
    ## [62]            --- and *carelessly* waved his right      hand     _b_ _b_ _b_ _b_ _b_ ---

``` r
# I3.2 ["Work and employment: Professionalism"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("I3.2"), context = 0)
y
```

    ## [ 1]            --- into the *secretary* 's damaged   face   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [ 2]                    --- Kissing and Love by the   ears   together. When the Assistant *Secretary* --- 
    ## [ 3] --- an old-fashioned *writing-table*, with his   back   turned to his visitor _b_ ---                
    ## [ 4]         --- Sir Hugo Mallinger 's *secretary*,  roused  rather unwillingly from his political ---    
    ## [ 5]         --- and he had thoughtful, treacherous   eyes  . Sitting down at the *writing-table* ---     
    ## [ 6]            --- his pale and seemingly lifeless   face   -- the stranger, *Mason*: I ---              
    ## [ 7]                  --- water to *Mason* 's white   lips  ; again and again offered him ---             
    ## [ 8]               --- looked over the solicitor 's shoulder -- yes, it was *Mason* ---                   
    ## [ 9]                   --- blow the breath from his   body   -- but *Mason* shrank away, ---              
    ## [10]             --- reply escaped *Mason* 's white   lips   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [11]      --- registered envelope, addressed in the   hand   of my *colleague* and old ---                
    ## [12]        --- *stone-mason* 's children " met his    eye  . _b_ _b_ _b_ _b_ _b_ ---                     
    ## [13]         --- with clever *secretaries* at their   elbow , and had once governed Ireland ---           
    ## [14]              --- very mean character: the long   back   premises of a *carpenter*, the ---           
    ## [15]            --- Mr. Under- *Secretary* over the   heads  of all the people present: ---               
    ## [16]       --- an unfortunate *reputation*. The old   hands  warned the less experienced of ---           
    ## [17]               --- for powdering the footmen 's   heads ; or a poor *carpenter* who ---               
    ## [18]              --- as that should possess either  brains  or *reputation*. But he heard ---            
    ## [19]                   --- my friend with the grave   face   and spotless *reputation* -- but ---

``` r
# N3.1 ["Measurement: General"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.1"), context = 0)
y
```

    ## [ 1] --- elegant little *timepiece*, and several   busts  , small graceful figures, and vases, ---     
    ## [ 2]              --- that had never touched his   heart  . He could *measure* the whole ---           
    ## [ 3]     --- he had foreseen, Antonina instantly   awoke  , but, to his *unmeasured* astonishment, --- 
    ## [ 4]            --- *gradations* of color on the  forehead and the neck. Her chin, ---                 
    ## [ 5]                   --- _b_ _b_ Miss Gwilt 's    eyes   *measured* him contemptuously from head --- 
    ## [ 6] --- eyes *measured* him contemptuously from    head   to foot. He was a ---                       
    ## [ 7]  --- and *measured* him contemptuously from    head   to foot for the second ---                  
    ## [ 8]           --- *measuring* the doses with my    eye   , and calculating how many of ---            
    ## [ 9]           --- After *measuring* it with his    eye   , he took from the specimens ---             
    ## [10]          --- *measuring* gaze she was still  wincing . At last her opportunity came ---           
    ## [11]        --- of *measurement* and lifting his    eyes   to answer our question about ---            
    ## [12]    --- side-glances that *measured* me from    head   to foot -- now traversing ---               
    ## [13]              --- *measured* me from head to    foot   -- now traversing the folds ---             
    ## [14]       --- *measured* by my weary, trembling   limbs   before I could reach human ---              
    ## [15]        --- railings, he *measured* with his    eye    the height of a college ---                 
    ## [16] --- *timepiece*, rose impatiently. Still he   slept  , and coming to a resolution ---             
    ## [17]      --- seemed long, *measured* by beating   hearts , though scarce two minutes had ---          
    ## [18]           --- as they looked with straining    eyes  , as if to *measure* the ---                 
    ## [19]       --- truly ridiculous to an instructed    eye    if she did not *measure* ---                
    ## [20]      --- the pile, occasionally lifting his    eyes   to *measure* the height of ---              
    ## [21]           --- every taint, conducted to her    lips   a full *measure* of the ---                 
    ## [22]             --- repose in. The distant sea,  lapping  the sandy shore with *measured* ---         
    ## [23]              --- the air, and reached their    ears  ; the *measured* laboured walk of ---        
    ## [24]             --- veil seemed lifted from his    eyes  ; he saw that *immeasurable* distance ---    
    ## [25]        --- airy *measures* right over their   heads  . _b_ _b_ _b_ _b_ _b_ ---                    
    ## [26]                     --- on the red fire; my   heart   was *measuring* its own content; ---        
    ## [27]              --- _b_ _b_ The household went     to    bed, and, distressed beyond *measure*, ---  
    ## [28]               --- _b_ The household went to    bed   , and, distressed beyond *measure*, Tess --- 
    ## [29]        --- of her apartment. Her *measured* breathing told that she was sleeping ---              
    ## [30]          --- melodious music, or her lively   blood   danced a more healthful *measure*. ---

``` r
# X5.1+ ["Attention" +]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("X5.1+"), context = 0)
y
```

    ## [  1]                  --- ' *attention*, and open their     eyes   , as personal visits would have ---             
    ## [  2]                       --- a tree, *mindful* of her  complexion; whereupon Mr Crosbie, finding the ---         
    ## [  3]               --- looking very *intently* into her     face    _b_ _b_ _b_ _b_ _b_ ---                        
    ## [  4]                           --- _b_ _b_ _b_ Eames 's     ears    were instantly on the *alert*, ---             
    ## [  5]                  --- grew more penetrating and the     ear     more *attentive*, a cavern became ---          
    ## [  6]               --- solemn gloom, and listening with  breathless *attention* for the voices of ---              
    ## [  7]                --- girl, fixing her dark, eloquent     eyes    *intently* upon the Goth 's ---                
    ## [  8]                     --- hand upon her companion 's     arm     to awaken his *attention*, and ---             
    ## [  9]          --- caught his suspicious and *attentive*     ear    . They still moved onward a ---                 
    ## [ 10]                           --- with her head on his   shoulder , Antonina listened *attentively* to the ---    
    ## [ 11]                    --- on him, with the *vigilant*     eye     of affection, the girl 's ---                  
    ## [ 12]                  --- incessantly from the Pagan 's     lips   , but he never *addressed* *himself* ---        
    ## [ 13]             --- them with *attentive* and mournful     eyes   . Wherever he went, whatever he ---             
    ## [ 14]                     --- coarse food stood near his     hand   , but he had no *vigilance* ---                 
    ## [ 15]                      --- and bent wistfully on her     face    his *attentive* and pitying eyes ---           
    ## [ 16]               --- face his *attentive* and pitying     eyes    _b_ _b_ _b_ _b_ _b_ ---                        
    ## [ 17]           --- other with *vigilant* and suspicious     eyes   ; each in turn, as he ---                       
    ## [ 18]              --- its wonted *acuteness*, under the    bodily   reaction now produced in him ---               
    ## [ 19]           --- -- calm, *vigilant*, determined, her     hand    on the knife beneath her ---                   
    ## [ 20]             --- them, and thousands of *attentive*     ears    drank in their joyful news ---                 
    ## [ 21]                          --- drew back with her --  breathless, *vigilant*, desperate -- to the ---           
    ## [ 22]              --- which it was descended, listened,  breathless and *attentive*, to the sounds ---             
    ## [ 23]                          --- on the girl 's wasted     face   ; the rapt *attention* of Numerian, ---         
    ## [ 24]                         --- am here. The doctor 's     eye    , rising *attentively* by way of ---            
    ## [ 25]                    --- *attentively* by way of his    hands    and arms, questioned upward and ---            
    ## [ 26]                       --- anxiety in the doctor 's     eye    , a latent *preoccupation* in the ---           
    ## [ 27]                   --- *heeded*, or even heard. His     eyes    wandered from the child, rested ---            
    ## [ 28]                      --- to hear the question; his     eyes    remained fixed *intently* on the ---           
    ## [ 29]        --- was *attentively* contemplating her own     face    in the glass over the ---                      
    ## [ 30]               --- looking him *attentively* in the     face   , said, in a quiet, absent ---                  
    ## [ 31]                  --- He was *intently* studying my     face   , with the inquiring expression of ---          
    ## [ 32]                          --- _b_ _b_ With a steady     hand   , with a calm, *attentive* face, ---            
    ## [ 33]                 --- hand, with a calm, *attentive*     face   , she fed the funnel for ---                    
    ## [ 34]                            --- and put it into his     hand   , to attract his *attention* in ---             
    ## [ 35]                       --- hour I waited with every    nerve    on the *alert*, but there ---                  
    ## [ 36]                          --- her eyes were full of    tears    -- gazing *intently* on some ---               
    ## [ 37]                      --- all save one having their    faces    and *attention* bent on the ---                
    ## [ 38]                      --- the piano, and folded his     arms    as if to *concentrate* himself ---             
    ## [ 39]                --- from *taking* *notice* that her     hand    was being held _b_ _b_ ---                     
    ## [ 40]                       --- on the *alert*, with two     eyes    wide open, a glass in ---                      
    ## [ 41]                      --- a little aloft with large     eyes    on the *alert*, regarding the ---              
    ## [ 42]                    --- it before. Suppose Mirah 's    heart    were entirely *preoccupied* with Deronda ---   
    ## [ 43]                    --- turned, after looking at my     face    *attentively*, and said in a ---               
    ## [ 44]                           --- was too cold and too    sleepy   to be keenly *observant*, and ---              
    ## [ 45]                 --- be keenly *observant*, and not    sleepy   enough to betray my trust, ---                 
    ## [ 46]                  --- was looking *intently* at the     face    of the dead woman, raising ---                 
    ## [ 47]               --- her *intently*, whilst Harker 's     hand    instinctively closed round the hilt ---        
    ## [ 48]                          --- subject cut up -- her     hand    seized -- her *attention* demanded, ---        
    ## [ 49]            --- illuminated her hand stretched out:    roused   now, and on the *alert* ---                    
    ## [ 50]                --- virtue slumbered; my evil, kept    awake    by ambition, was *alert* and ---               
    ## [ 51]             --- reaching the homestead his *alert*     eye     perceived the top of her ---                   
    ## [ 52]                          --- with his cigar in his     hand   , listening to her so *intently* ---            
    ## [ 53]                      --- time Mr. Robert Audley 's     eyes    were fixed *intently* on her ---               
    ## [ 54]                 --- fixed *intently* on her pretty     face    _b_ _b_ _b_ _b_ _b_ ---                        
    ## [ 55]            --- watched her cousin 's *preoccupied*     face   . He talked to her now ---                      
    ## [ 56]            --- *attentive* countenance. He had the     face    of a man who had ---                           
    ## [ 57]             --- him, and addressed his *attentive*     face    to the young barrister. Robert ---             
    ## [ 58]                 --- *attention* in Dr. Mosgrave 's     face    grew into a look of ---                        
    ## [ 59]               --- from Dr. Mosgrave 's *attentive*     face   . He rose, when Robert had ---                  
    ## [ 60]                         --- by him, and kissed his     hand   . He *took* no *notice* at ---                  
    ## [ 61]                       --- But no one *heeded*. All     eyes    were directed upwards. At this ---             
    ## [ 62]               --- his *attention*, and rubbing his     eyes   , he looked at the servant ---                  
    ## [ 63]       --- listened *attentively*, never taking his     eyes    off the dead body. When ---                    
    ## [ 64]               --- *attention*; and throwing up her     arms    with wild energy, she shrieked ---             
    ## [ 65]               --- divided *attention* to his faint  breathings; for in each hasty hurried ---                 
    ## [ 66]                        --- was the very *focus* or    heart    of Bob 's world, even ---                      
    ## [ 67]                    --- the *keenness* of his brown     eyes    was less common than his ---                   
    ## [ 68]                      --- an odd contraction of her     face   . Maggie, looking on *attentively*, felt ---    
    ## [ 69]                    --- 's *attention* to Maggie 's     hair    and other unexpected virtues, but ---          
    ## [ 70]                     --- music, and Maggie bent her     head    *assiduously* over her work. Each ---          
    ## [ 71]                         --- _b_ _b_ _b_ This quiet     eye     had attracted *attention* from time ---        
    ## [ 72]                --- an estranged mien; the solitude   exhaled   from the heath was *concentrated* ---          
    ## [ 73]               --- heath was *concentrated* in this     face    that had risen from it. ---                    
    ## [ 74]             --- *attention* to these things, their     eyes    being *concentrated* upon the little ---       
    ## [ 75]                     --- Her step grew lighter, her     lip     redder. She began to *take* ---                
    ## [ 76]                     --- *focus* of all those human     eyes   , that betrayed intensest interest of ---       
    ## [ 77]              --- sink down into her *pre-occupied*    heart   . She did not know what ---                     
    ## [ 78]                           --- hand on the woman 's     arm     to arrest her *attention*. Their ---           
    ## [ 79]               --- to arrest her *attention*. Their     eyes    met _b_ _b_ _b_ _b_ ---                        
    ## [ 80]                   --- down instantly, and bent her     head    *attentively* over her work. She ---           
    ## [ 81]                   --- who could be *captivated* by    Fanny    's second-rate airs and graces, ---            
    ## [ 82]                  --- his *attention*. He was never    tired    of talking about them; and ---                 
    ## [ 83]                          --- wore easily -- in her    breast   it *concentred* itself in independence. ---    
    ## [ 84]             --- *concentrated* and strong -- every     eye     reads your actions -- your ---                 
    ## [ 85]                          --- in them, and in their    hearts   were *concentrated* the last rays ---          
    ## [ 86]                    --- but a quick and *observant*     eye    . Every now and then he ---                     
    ## [ 87]                  --- skillfully placed by the rosy     lips   , attracted *attention* to their dimples, ---   
    ## [ 88]           --- lips, attracted *attention* to their   dimples  , and to the teeth, to ---                      
    ## [ 89]             --- keeping only its quick, *vigilant*     eye     fixed upon the invaders of ---                 
    ## [ 90]                               --- in love as to be  insensible to his *attentions*. _b_ _b_ ---               
    ## [ 91]                --- glance of his quick, *vigilant*     eye    . Tetraides struck -- it was ---                
    ## [ 92]           --- feverish symptoms increased, and her     head    ached *acutely*. Elizabeth did not ---         
    ## [ 93]                             --- up. He was as much    awake    to the novelty of *attention* ---              
    ## [ 94]                         --- minute or two with his     chin    resting on his hand, *diligently* ---          
    ## [ 95]                        --- his chin resting on his     hand   , *diligently* occupied in the continued ---    
    ## [ 96]       --- anxious and *pre-occupied* expression of     face    seemed the indication of riper ---             
    ## [ 97]                       --- of my quiet touch merely     woke    *attention* as I wished; and, ---              
    ## [ 98]                 --- the *attention* of my strained     ear     -- so low, so self-addressed, ---              
    ## [ 99]                          --- of her own heart. Her     face    was grave, its expression *concentrated*; ---  
    ## [100]    --- English-looking wild-flowers growing at our     feet   , I recalled Frances ' *attention* ---          
    ## [101]                        --- her hands folded on her     knee   , the most fixedly *attentive* of ---           
    ## [102]                  --- looking her *intently* in the     face    _b_ _b_ _b_ _b_ _b_ ---                        
    ## [103]              --- changed air struck the *vigilant*     eye     of his wife _b_ _b_ ---                        
    ## [104]                           --- man, who held up his     hand    to attract her *attention*. _b_ ---            
    ## [105]                 --- neutral shade his companion 's     face   , which was the *focus* of ---                  
    ## [106]                         --- was the *focus* of his     eyes   , rising above the mist stratum, ---            
    ## [107]             --- prettiest guise to *captivate* the    hearts   of her parents-in-law; though she, ---         
    ## [108]                        --- of the trying ascent -- unconscious through *preoccupation* and not through ---    
    ## [109]             --- *captivated* by the sweet blushing     face    of the young lady who ---                      
    ## [110]                      --- to straggle from the main     body   , or to *take* the slightest ---                
    ## [111]                 --- bending over her with starting     eyes   , once more the *attentive* ear ---             
    ## [112]                --- eyes, once more the *attentive*     ear     listening for the soundless breath. ---        
    ## [113]               --- *toes*, lolling out his enormous    tongue  , and stroking his mock paunch. ---             
    ## [114]               --- *intentness*, and then shook his     head   : his private feelings entirely disapproved --- 
    ## [115]                           --- from her head to her     arm    , and gazed *intently* in her ---               
    ## [116]                    --- and gazed *intently* in her     face   . Then he drew his hand ---                     
    ## [117]              --- *alert*, and his mental faculties   wakened   to unwonted activity. I suppose ---            
    ## [118]                        --- at about the cheeks and     chin   ; large, grave, wistfully *attentive* eyes; --- 
    ## [119]      --- chin; large, grave, wistfully *attentive*     eyes   ; nervous, uncertain lips; and light ---        
    ## [120] --- wistfully *attentive* eyes; nervous, uncertain     lips   ; and light hair of a ---                       
    ## [121]          --- in those large, wistfully *attentive*     eyes    of hers, which were still ---                  
    ## [122]                       --- same serene smile on her     lips   , the same vacantly- *attentive* turn ---       
    ## [123]              --- vacantly- *attentive* turn of the     head   , the same snugly-comfortable position of ---   
    ## [124]                           --- in me to observe her     face   , with an *attention* and a ---                 
    ## [125]                      --- sinking to a whisper, her     eyes    looking more and more *intently* ---           
    ## [126]                   --- *intently* at the music, her   fingers   flying over the keys of ---                    
    ## [127]                     --- _b_ Miss Halcombe 's sharp     eyes    studied my face *attentively* _b_ ---          
    ## [128]                       --- 's sharp eyes studied my     face    *attentively* _b_ _b_ _b_ _b_ ---              
    ## [129]                    --- _b_ _b_ _b_ His *attentive*     face    relaxed a little. But I ---                    
    ## [130]                   --- continued, looking me in the     face    very *attentively* _b_ _b_ _b_ ---             
    ## [131]             --- *addressed* *himself* gaily to the   scowling  master of the house _b_ ---                    
    ## [132]                           --- _b_ _b_ _b_ Laura 's     eyes    read mine *attentively* _b_ _b_ ---            
    ## [133]        --- the common coach-manlike *attention* of    crying   _b_ _b_ _b_ _b_ _b_ ---                        
    ## [134]                  --- most *attentive*. I think his    heart    was much softened. If some ---                 
    ## [135]                   --- man, with a very *attentive*     eye    , a very low voice, and ---                     
    ## [136]                --- Mr. Kyrle 's calmly *attentive*     face    relaxed, for the first time, ---               
    ## [137]                 --- looked me *attentively* in the     face    with more appearance of interest ---           
    ## [138]                --- me all over *attentively*, from     head    to foot, as I sat ---                          
    ## [139]               --- over *attentively*, from head to     foot   , as I sat down in ---                          
    ## [140]                          --- my cudgel ready in my     hand   , my ears on the *alert*, ---                   
    ## [141]                           --- ready in my hand, my     ears    on the *alert*, and my ---                     
    ## [142]                         --- on the *alert*, and my     eyes    straining to see through the ---               
    ## [143]                             --- a scar on his left    cheek    -- looked *attentively* at Pesca ---           
    ## [144]                      --- hung loose, his cold grey     eyes    were furtively *vigilant*, his voice, ---

``` r
# F3 ["Cigarettes and drugs"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("F3"), context = 0)
y
```

    ## [ 1]                  --- up the *cigars* in his    hand    _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 2]                   --- with a *cigar* in his    mouth  , fearing that something evil was ---      
    ## [ 3]       --- *cigars*, and porters close their    fists   against sixpences; a great man ---        
    ## [ 4]                  --- the *cigar* out of his    hand   , and, insisting on his treating ---       
    ## [ 5]            --- *smoking* their pipes in the    back    garden. As soon as their ---              
    ## [ 6]             --- my *cigarette*, I closed my    hand    upon the butt of my ---                   
    ## [ 7]                   --- a sharp intake of his   breath   and the *cigar* fell from ---             
    ## [ 8]               --- the *cigar* fell from his   fingers  _b_ _b_ _b_ _b_ _b_ ---                   
    ## [ 9]            --- another chair, and his right    elbow   on the table, was *smoking* ---           
    ## [10]                       --- and when he had a    hand    unused by *cigar* or coffee-cup, ---      
    ## [11]              --- his *cigar* and thrust his    hands   into his side pockets, as ---             
    ## [12]     --- but *smoked* slowly, consulting his    beard   with inspecting eyes and fingers, ---     
    ## [13]            --- fellow was *puffing* out his   cheeks   in trying to blow a ---                   
    ## [14]               --- took his *cigar* from his    mouth  , and rose to the occasion ---             
    ## [15]                  --- his *cigar* out of his    mouth  , and looking steadily at the ---          
    ## [16]    --- well-cut features and exquisite long    hands  . Omitting the *cigar*, you might ---      
    ## [17]              --- with a *cigar* between his   fingers . He threw it away and ---                 
    ## [18]         --- *cigar*, and then stretched his    hand    toward the hat that lay ---               
    ## [19]                --- his silk scarf round his   throat  . As he strolled home, *smoking* ---       
    ## [20]                 --- began to flicker in her   eyelids . At last, however, the *narcotic* ---     
    ## [21]        --- merge subtly into the *narcotic*    sleep  . It was with a feeling ---                
    ## [22]                 --- short black pipe to her    lips   , and renewed her *smoking* with ---       
    ## [23]                 --- with his *cigar* in his    hand   , listening to her so intently ---         
    ## [24]            --- of his *cigar* with cautious   fingers  _b_ _b_ _b_ _b_ _b_ ---                   
    ## [25]    --- Audley watched those poor, withered,  tremulous fingers dropping shreds of *tobacco* ---  
    ## [26] --- watched those poor, withered, tremulous   fingers  dropping shreds of *tobacco* upon ---     
    ## [27]                  --- hour too early. He was    tired   of *smoking*. The soothing *narcotic* --- 
    ## [28]                 --- in a series of sonorous  spittings and *puffs* _b_ _b_ _b_ ---               
    ## [29]               --- over the *puff*, with his    head    on one side in a ---                      
    ## [30]                  --- own share of *puff* is  swallowed. _b_ _b_ _b_ _b_ _b_ ---                  
    ## [31]  --- *tobacco*. Tom 's young pink-and-white    face    had its colors very much ---              
    ## [32]         --- last *cigar*, and thrusting his    hands   into his pockets, stalked along ---       
    ## [33]             --- Lucy, disliking to have her    hair    powdered with *snuff*, usually began ---  
    ## [34]           --- Wildeve was standing with his    back    to the fireplace *smoking* a ---          
    ## [35]                   --- with a *cigar* in his    mouth  , was tempted by the fascination ---       
    ## [36]                --- _b_ At eleven o'clock he    went    to bed himself, *smoked* for ---          
    ## [37]               --- At eleven o'clock he went     to     bed himself, *smoked* for some ---        
    ## [38]               --- eleven o'clock he went to     bed    himself, *smoked* for some time ---       
    ## [39]             --- God ! how he did *snuffle*,    snort  , and wheeze ! All he said ---             
    ## [40]             --- his *cigar* gently from his    lips    and spat on the painted ---               
    ## [41]         --- these holy haunts; breaking the   hearts   of nursery maids, and *smoking* ---       
    ## [42]                     --- his pipe out of his    mouth   and blowing an immense *puff* ---         
    ## [43]              --- with a *cigar* between his    teeth  ; wearing a dandy cap, drab ---            
    ## [44]               --- trail they found her; the   snoring  *puff* from her nostrils, when ---        
    ## [45]             --- the snoring *puff* from her  nostrils , when she recognized them, making ---     
    ## [46]             --- single push from Osborne 's   finger   sent him *puffing* back into ---          
    ## [47]          --- that her brother Southdown had mustachios, and *smoked* *cigars*, and submitted --- 
    ## [48]               --- the Countess 's own Roman    nose    through which she *snuffled* _b_ ---      
    ## [49]       --- to *smoke*. The Turkish dignitary    yawns   and expresses signs of weariness ---      
    ## [50]                   --- with a *cigar* in his    mouth  , but she closed the door ---

``` r
# S1.2.3- ["Egoism" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("S1.2.3-"), context = 0)
y
```

    ## [ 1]               --- were heavy and vacant, his  forehead low and *retiring*, his cheeks ---           
    ## [ 2]         --- forehead low and *retiring*, his   cheeks  sallow, and his form curved ---              
    ## [ 3]        --- dim *retiring* objects, which the    eye    loses in vacancy. _b_ _b_ ---                
    ## [ 4]               --- said Miss Milroy, with her    eyes   *modestly* riveted on the ground ---         
    ## [ 5]                     --- 's arm away with his   fists  . The little girls submitted *bashfully* ---  
    ## [ 6]               --- toward him with her little   hands   crossed before her, *meekly* awaiting ---    
    ## [ 7]      --- *humility*, waving his fat jewelled   hands   and talking at the top ---                   
    ## [ 8]                 --- burn, but she folded her   hands   *meekly* and looked up in ---                
    ## [ 9]           --- even the *unselfish* warmth of   heart  , which she had believed herself ---          
    ## [10]         --- so truly *considerate* for every    body  , would never deserve to be ---               
    ## [11]        --- *meek* sheep and the rough-coated keen-eyed dog, its guardian. _b_ _b_ ---               
    ## [12]                 --- walked with my father 's    hand  , and through the *self-denying* toils ---    
    ## [13]             --- Jude looked anxiously at his    face  . It seemed benign, *considerate*, yet ---    
    ## [14]                --- Mrs. Barton, she took her    hand   almost *humbly*, and said _b_ ---            
    ## [15]                 --- lips, and frozen red her   hands   Her sunken eyes are *modestly* ---           
    ## [16]                 --- red her hands Her sunken    eyes   are *modestly* downcast, Her night-black --- 
    ## [17] --- are *modestly* downcast, Her night-black    hair   streams on the fitful blast; ---             
    ## [18]           --- with eagerness, over his manly    face  , bent *meekly* down in order ---             
    ## [19]                 --- contents into the man 's    hand  ; and then began *meekly* to ---              
    ## [20]    --- awkward and *self-conscious* in every    limb   than he had ever done ---                    
    ## [21]             --- head drooped forwards -- her   hands   *meekly* laid one upon the ---               
    ## [22]                        --- look a man in the    face   with *modesty* and propriety ? An ---        
    ## [23]                 --- She would trample on the    neck   of *humility*, she would kneel ---           
    ## [24]                     --- _b_ and she bent her    head   *meekly* _b_ _b_ _b_ _b_ ---                 
    ## [25]         --- *modesty*, she dodged aside. His    arms   being occupied with the reins ---            
    ## [26]    --- interesting avowal from the *bashful*    lips   of the young man ! _b_ ---                   
    ## [27]               --- Emmy crying over George 's    hand  , and kissing it *humbly*, as ---             
    ## [28]         --- their youth, *meekly* cutting up    legs   of mutton for rancorous old ---              
    ## [29]           --- conquered, and laying down her    arms  , as it were, she *humbly* ---                
    ## [30]        --- *modestly* said, casting down her    eyes   _b_ _b_ _b_ _b_ _b_ ---                      
    ## [31]            --- of *meek* tenderness, and her    head   sank upon his breast _b_ ---                 
    ## [32]               --- all *humbly* placed at her    feet  , and, so far as appearances ---

``` r
# N3.8- ["Measurement: Speed" -]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.8-"), context = 0)
y
```

    ## [  1]               --- with *slow* steps into the      back     parlour. _b_ _b_ _b_ _b_ ---                     
    ## [  2]                --- the fire, and shaking his      head     very *slowly* _b_ _b_ _b_ ---                    
    ## [  3]                --- since gone, could rub his     hands     *slowly*, one on the other, ---                  
    ## [  4]          --- and more martial character, the    sleeping   patrician *slowly* opened his eyes ---           
    ## [  5]   --- sleeping patrician *slowly* opened his      eyes     and stared vacantly around him ---               
    ## [  6]       --- that moment, however, the withered      lips     of the old man *slowly* ---                      
    ## [  7]      --- short interval, her *slow*, regular   breathing   announced to the young warrior, ---              
    ## [  8]                   --- then he could hear the     blood     dripping *slowly* from his shoulder, ---         
    ## [  9]         --- blood dripping *slowly* from his    shoulder  , with dismal regularity, into a ---              
    ## [ 10]           --- raindrops fell *slowly* to the    thirsty    earth. The warriors not actually ---             
    ## [ 11]    --- expression, and, without removing her      eyes     from the Goth, she *slowly* ---                  
    ## [ 12]           --- the house, then paused, rigid,   breathless , silent, and, turning *slowly*, faced ---        
    ## [ 13]            --- voice. He *slowly* turned his      head    , and, looking down, saw on ---                   
    ## [ 14]                    --- to have sunk over his     bodily    perceptions; his eyes rolled *slowly* ---        
    ## [ 15]         --- over his bodily perceptions; his      eyes     rolled *slowly* to and fro ---                   
    ## [ 16]              --- gone he *slowly* turned his      head     in the direction by which ---                    
    ## [ 17]                --- *Slowly* she arose -- her     limbs     trembled with a premature infirmity; ---         
    ## [ 18]             --- save when, at intervals, his      lips     moved *slowly* with a long ---                   
    ## [ 19]      --- wandered passed *slowly* before his      eyes    , now the soft voices murmured ---                
    ## [ 20]                       --- _b_ _b_ _b_ As her      eyes     travelled *slowly* from side to ---              
    ## [ 21]               --- _b_ He *slowly* turned his      head     in the direction of the ---                      
    ## [ 22]              --- purpose; now he dragged one      limb     after the other as *slowly* ---                  
    ## [ 23]                    --- was awful to look on.     Tears     rolled *slowly* from his half-closed ---         
    ## [ 24]     --- rolled *slowly* from his half-closed      eyes     over his seamed and wrinkled ---                 
    ## [ 25]   --- spirit-broken; he *slowly* clasped his     hands     together on the floor, and ---                   
    ## [ 26]               --- He now *slowly* lifted his      foot     from Goisvintha 's breast, and ---               
    ## [ 27]                   --- to its old position; a      tear     rolled *slowly* over her cheek ---               
    ## [ 28]            --- tear rolled *slowly* over her     cheek     as she closed her eyes ---                       
    ## [ 29]                --- The *slow* current of his     blood     seemed to have come to ---                       
    ## [ 30]              --- rose *slowly* on his sallow      face    . Her eyes were looking at ---                    
    ## [ 31]      --- of inquiry. *Slowly* the motionless      lips     struggled into movement. With thick, ---         
    ## [ 32]        --- paleness spread *slowly* over her      face    . She looked at the fatal ---                     
    ## [ 33]             --- time, and brought his hidden      hand     *slowly* into view _b_ _b_ ---                   
    ## [ 34]                 --- light in his clear brown      eyes     dying out *slowly*. What the ---                 
    ## [ 35]           --- the college sat, with swinging      legs     and *slowly* moving jaws, and, ---               
    ## [ 36]        --- swinging legs and *slowly* moving      jaws    , and, hushed in the horrid ---                   
    ## [ 37]         --- faintly, and *slowly* opened his      eyes     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 38]        --- _b_ Midwinter *slowly* raised his      head    . His eyes rested with a ---                      
    ## [ 39]            --- *slowly* raised his head. His      eyes     rested with a mournful interest, ---             
    ## [ 40]             --- His groaning ceased, and his     hands     dropped *slowly*. There was an ---               
    ## [ 41]        --- gliding *slow* and distant behind    fringes    of pollard willows, the sails ---                
    ## [ 42]                   --- kept secret in her own     heart     -- Mrs. Milroy *slowly* raised ---               
    ## [ 43]         --- *slowly* and venomously from her      lips     _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 44]                --- _b_ The reflection of her      face     changed *slowly*. The color returned ---         
    ## [ 45]               --- hospital; and his mind and      body     were now *slowly* recovering together. ---       
    ## [ 46]                    --- _b_ _b_ He closed his      eyes    : the tears trickled *slowly* over ---            
    ## [ 47]                  --- He closed his eyes: the     tears     trickled *slowly* over his wrinkled ---          
    ## [ 48]      --- trickled *slowly* over his wrinkled     cheeks    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 49]                   --- and *slow* in his ashy     cheeks    _b_ _b_ _b_ _b_ _b_ ---                          
    ## [ 50]              --- face. She answered him with      lips     that struggled *slowly* into a ---               
    ## [ 51]               --- as she *slowly* turned her      head     and looked at him _b_ ---                        
    ## [ 52]  --- unutterable expectation throbbed at his     heart    . A terror that was *slow* ---                    
    ## [ 53]        --- and listened. The *slow*, regular   breathing   of a sleeping man was ---                        
    ## [ 54]           --- *slow*, regular breathing of a    sleeping   man was just audible. After ---                  
    ## [ 55]            --- she heard the *slow*, regular   breathing   of the sleeping man. The ---                     
    ## [ 56]         --- *slow*, regular breathing of the    sleeping   man. The first time the ---                      
    ## [ 57]        --- composure settled *slowly* on her      face    . She bore the look of ---                        
    ## [ 58]                 --- have turned his horse 's      head    . Riding *slowly* in this fashion ---             
    ## [ 59]                 --- a little bundle upon his    shoulder  , toiling *slowly* up the hill. ---               
    ## [ 60]        --- widened *slowly* from the crushed     skull     of the victim. And it ---                        
    ## [ 61]            --- Miss Matty *slowly* shook her      head     over each virtue as it ---                       
    ## [ 62]                  --- a *slow* dark thread of     blood     came oozing out. (How Miss ---                   
    ## [ 63]               --- he said gently, taking her      hand     and leading her *slowly* along ---               
    ## [ 64]               --- the first time, turned his      eyes     toward his companion, but *slowly* ---           
    ## [ 65]      --- but smoked *slowly*, consulting his     beard     with inspecting eyes and fingers, ---            
    ## [ 66]          --- _b_ Grandcourt met her laughing      eyes     with a *slow*, steady look ---                   
    ## [ 67]                  --- at length in big *slow*     tears    , which fell without restraint until ---          
    ## [ 68]             --- lap, her ankles crossed, her      eyes     at first traveling *slowly* over ---             
    ## [ 69]                  --- the other, and a *slow*      tear     fell. She thought _b_ _b_ ---                    
    ## [ 70]          --- were being placed by *creeping*     hands     within sight of the expectant ---                
    ## [ 71]               --- _b_ _b_ Mordecai shook his      head     *slowly*, and answered _b_ _b_ ---               
    ## [ 72]                   --- ear, yet she shook her      head     *slowly*. He began again, even ---               
    ## [ 73]                --- _b_ *Slowly*, with a sad,   tremulous   voice, she said _b_ _b_ ---                      
    ## [ 74]                  --- _b_ She turned away her      eyes     again, and sat thinking. *Slowly* ---            
    ## [ 75]        --- dalmatic, *slowly* and with white     hands     moving aside the veil of ---                     
    ## [ 76]               --- black coffee, he wiped his      lips     *slowly* with a napkin, motioned ---             
    ## [ 77]       --- being *slowly* tightened round his    forehead  , as if the disgrace with ---                     
    ## [ 78]          --- drawer passed *slowly* out. His    fingers    moved instinctively towards it, dipped ---       
    ## [ 79]              --- said Dorian, turning on his      heel     and going *slowly* down the ---                  
    ## [ 80]            --- curs quarrelling over a dirty      bone    , and a string of *dawdling* ---                  
    ## [ 81] --- a hard-featured yet good-natured looking      face    . Having considered me *at* *leisure*, ---        
    ## [ 82]                    --- was a man, turned his      head     *slowly* towards where I stood, ---              
    ## [ 83]            --- again: I dragged my exhausted     limbs     *slowly* towards it. It led ---                  
    ## [ 84]            --- seemed *leisurely* to read my      face    , as if its features and ---                      
    ## [ 85]              --- He still *slowly* moved his     finger    over his upper lip, and ---                      
    ## [ 86]                --- *slow* sure step. Shut my      eyes     as I would, these last ---                       
    ## [ 87]               --- faint organ notes. Jude 's      face     changed more: he whispered *slowly*, ---         
    ## [ 88]       --- he whispered *slowly*, his parched      lips     scarcely moving: _b_ _b_ _b_ ---                 
    ## [ 89]               --- by degrees even this vague consciousness of his misfortune faded *slowly* ---             
    ## [ 90]          --- tombstone. A few *slow*, silent     tears     dropped upon his waistcoat as ---                
    ## [ 91]            --- but receiving no answer, grew     tired     of the exertion, and *dawdled* ---               
    ## [ 92]          --- the exertion, and *dawdled* on,    yawning    as he went, and still ---                        
    ## [ 93]          --- *slowly* creeping down her fair      neck    . _b_ _b_ _b_ _b_ _b_ ---                         
    ## [ 94]          --- _b_ The Newfoundland rolled his      eyes     *slowly* round in the direction ---              
    ## [ 95]                      --- _b_ _b_ _b_ _b_ The     tears     oozed *slowly* through the dirty ---             
    ## [ 96]         --- oozed *slowly* through the dirty    fingers    with which he shaded his ---                     
    ## [ 97]               --- The *slow* progress of the     hands     of the old clock in ---                          
    ## [ 98]               --- charge of her accuser. Her      arms     *slowly* dropped, and she stood ---              
    ## [ 99]                      --- _b_ _b_ _b_ _b_ The      hand     *slowly* made its inevitable way ---             
    ## [100]              --- *leisurely* up, and put her      arm      through Mary 's with a ---                       
    ## [101]           --- *slowly* turned round, and her      eyes     gleamed like those of a ---                      
    ## [102]             --- for the expected answer, her    eyelids    *slowly* closed, and she fell ---                
    ## [103]              --- Then she *slowly* shook her      head    , and said, more quietly than ---                 
    ## [104]                   --- with a blessing on her      lips    , as they went *slowly* up ---                    
    ## [105]                   --- open page, and let the     tears     fall *slowly* on the spotless ---                
    ## [106]             --- Mr. Tulliver took a draught,   swallowed   it *slowly*, and shook his ---                   
    ## [107]               --- it *slowly*, and shook his      head     in a melancholy manner, conscious ---            
    ## [108]                       --- _b_ _b_ _b_ Tom 's      arm      *slowly* relaxed, and he said ---                
    ## [109]      --- without speaking, while he *slowly*    unwound    some of the line, saying, ---                    
    ## [110]                   --- a further shake of the      head    , as Mrs. Pullet *slowly* rose ---                
    ## [111]                --- _b_ Mrs. Pullet shook her      head     *slowly* at this last serious ---                
    ## [112]                --- placing the bonnet on her      head    , turned *slowly* round, like a ---               
    ## [113]                --- _b_ Mrs. Pullet shook her      head     *slowly* _b_ _b_ _b_ _b_ ---                     
    ## [114]                       --- with a baby on her      arm     , walked *slowly* to meet her. ---                
    ## [115]         --- move with a *slow*, half-stifled     pulse     in a medium uninteresting or ---                 
    ## [116]       --- *slow*, loud emphasis, bending her      head     toward him significantly. _b_ _b_ ---            
    ## [117]                     --- Tom put out his pink      palm    , and Bob was not *slow* ---                      
    ## [118]           --- said Mr. Tulliver, shaking his      head     *slowly* _b_ _b_ _b_ _b_ ---                     
    ## [119]     --- was reading with *slowly* travelling      eyes     Mrs. Tulliver entered the room, ---              
    ## [120]                 --- _b_ _b_ Maggie shook her      head     *slowly*, and was silent, under ---              
    ## [121]         --- but rode *slowly*, with uplifted      head     and free glances, along the ---                  
    ## [122]             --- chest heaved, the loud, hard   breathing   continued, getting gradually *slower*, as ---    
    ## [123]             --- _b_ said Maggie, shaking her      head     *slowly* _b_ _b_ _b_ _b_ ---                     
    ## [124]     --- the *slowly* rounding sun. Something     roused    Stephen too, and getting up ---                  
    ## [125]            --- other things sank blooding to     sleep     the heath appeared *slowly* to ---               
    ## [126]           --- the heath appeared *slowly* to     awake     and listen. Every night its ---                  
    ## [127]              --- merely, a *creeping* of the     flesh     of somnolence. But here, away ---                
    ## [128]               --- *creeping* of the flesh of   somnolence . But here, away from comparisons, ---            
    ## [129]           --- *slowly*, and expressed by his      face     that he expected her to ---                      
    ## [130]               --- and puckered mirror a dark      body     was *slowly* borne by one ---                    
    ## [131]                 --- eyes as his daughter, --      eyes     which moved *slowly* and almost ---              
    ## [132]                     --- he looked her in the      face    , and said in a *slow*, ---                       
    ## [133]              --- an instant on the shadowing   eye-lashes  before rolling *slowly* *down* her ---           
    ## [134]       --- before rolling *slowly* *down* her     cheeks   , and dropping, unheeded, on her ---              
    ## [135]          --- massive, rather than heavy. Her      face     moved *slowly* from one decided ---              
    ## [136]             --- hear the one great straining     breath   ; the creak of wood *slowly* ---                  
    ## [137]        --- heavier, *slower* plash than even     tears    , came the drip of blood ---                      
    ## [138]                     --- _b_ _b_ _b_ _b_ said     Fanny    , drawing nearer by *slow* degrees, ---           
    ## [139]    --- Thornton, smiling *slowly*, while the     tears     stood in her eyes _b_ ---                        
    ## [140]         --- more distinct to his inattentive      ear      than her *slow* movements, in ---                
    ## [141]             --- their curve. Her *slow* deep   breathings  dilated her thin and beautiful ---               
    ## [142]                 --- rest upon it. The *slow*     tears     gathered into Margaret 's eyes, ---              
    ## [143]          --- engaged; she *slowly* moved her      head     round on the pillow, and ---                     
    ## [144]            --- one distinct, *slow* tramp of      feet    , which made itself a clear ---                   
    ## [145]           --- ideas came *slowly*, for their     brains    were dull and languid of ---                     
    ## [146]                --- Nydia; and, guided by her      ear     , she walked *slowly* to the ---                  
    ## [147]           --- gently and *slowly* passed her      hand     over the bending and half-averted ---            
    ## [148]           --- with *slow* steps and downcast      eyes     he went his way. _b_ ---                         
    ## [149]               --- even pride, he glanced his      eyes     over the *rolling* and rushing ---               
    ## [150]                 --- entered the den, and his      feet     were dabbled in the *slow* ---                   
    ## [151]                 --- in the *slow* streams of     blood     that gushed from the corpses ---                 
    ## [152]            --- ashamed, I *slowly* joined my     hands    , and ejaculated in a deep ---                    
    ## [153]          --- of abundant but somewhat coarse      hair     over her *rolling* black eyes; ---               
    ## [154]        --- *rolling* black eyes; parting her      lips    , as full as those of ---                         
    ## [155]          --- found him staggering about, his      eyes     in a fine frenzy *rolling* ---                   
    ## [156]          --- assisted a reviving nature. She    breathed  , she sighed, *slowly* opened her ---             
    ## [157]       --- *slowly* opened her beautiful dark      eyes    , and looked around. Her father ---               
    ## [158]             --- *Slowly* came over Sybil the consciousness of the dreadful eve that ---                     
    ## [159]              --- a *slower* process, and her      face    , as it rose into the ---                         
    ## [160]                --- force in the gentleman 's      face    , and in his bold *rolling* ---                   
    ## [161]                --- and in his bold *rolling*      eye      _b_ _b_ _b_ _b_ _b_ ---                          
    ## [162]      --- white centre-teeth, and allowed his      lips     to smile *slowly* of themselves ---              
    ## [163]          --- that, beginning with one *slow*      tear    , and then following with another, ---            
    ## [164]        --- The conviction bred serenity, her     pulse     *slowed*, and she was able ---                   
    ## [165]            --- watching them by moving their     heads     round in a *slow*, horizontal, ---               
    ## [166]             --- Knibbs, with her wooly black      hair     and *rolling* eyes; and flaxen ---               
    ## [167]           --- wooly black hair and *rolling*      eyes    ; and flaxen Frances, consumptive from ---        
    ## [168]               --- She hardly observed that a      tear     descended *slowly* upon his cheek, ---           
    ## [169]         --- tear descended *slowly* upon his     cheek    , a tear so large that ---                        
    ## [170]               --- *slowly* upon his cheek, a      tear     so large that it magnified ---                   
    ## [171]  --- Paganism, Paulinism; the bold *rolling*      eye      that had flashed upon her ---                    
    ## [172]           --- here and there. While *slowly*   breasting   this ascent Tess became conscious ---            
    ## [173]         --- *slow*, malicious tone, with his      neck     extended, and his hand with ---                  
    ## [174]                 --- dagger with a *slow* and   tremulous   hand, and starts from the ---                    
    ## [175]              --- with a *slow* and tremulous      hand    , and starts from the contact ---                 
    ## [176]            --- precious charge pressed to my     heart    . Hindley descended more *leisurely*, sobered --- 
    ## [177]                   --- head of the grave. Her      face     turned towards me *slowly*, with ---             
    ## [178]         --- *slowly* without rising from her     knees    , so as to face me. ---                           
    ## [179]               --- eyes, and dropped over her     cheeks    *slowly* as she paused and ---                   
    ## [180]                      --- I hear the horses '      feet     -- I hear the *rolling* ---                      
    ## [181]          --- responsive *creeping* in my own     nerves   , and suggests hideous ideas of ---               
    ## [182]               --- passion. The Count 's firm      hand     *slowly* tightened its grasp on ---              
    ## [183]           --- Sir Percival *slowly* drew his    shoulder   from under the Count 's ---                      
    ## [184]                  --- from under the Count 's      hand    , *slowly* turned his face away ---               
    ## [185]             --- 's hand, *slowly* turned his      face     away from the Count 's ---                       
    ## [186]                   --- hand from the Count 's      arm     , and *slowly* ascended the steps. ---            
    ## [187]            --- and *slowly* nodded her addle      head     at me _b_ _b_ _b_ ---                            
    ## [188]            --- mourning, with his big solemn      face    , and his *slow* walk, and ---                    
    ## [189]                     --- was pity in the kind      hand     that *slowly* and fondly strengthened ---        
    ## [190]               --- and fall *slowly* over her     cheeks    as she looked at me. ---                         
    ## [191]         --- cruel smile *slowly* widened her      lips     -- she eyed me, with ---                         
    ## [192]            --- -- they dropped *slowly* from     mouth     to mouth till they reached ---                   
    ## [193]           --- dropped *slowly* from mouth to     mouth     till they reached the place ---                  
    ## [194]                       --- _b_ _b_ _b_ _b_ My      eyes     dropped *slowly*. At first I ---                 
    ## [195]                       --- at rest, I saw the     tears     come *slowly* through her closed ---             
    ## [196]         --- come *slowly* through her closed    eyelids   , I heard the faint murmuring ---                 
    ## [197]             --- the large opera-glass to his      eyes    , and moved it *slowly* all ---                   
    ## [198]         --- from me *slowly*, trembling from      head     to foot _b_ _b_ _b_ ---                          
    ## [199]         --- *slowly*, trembling from head to      foot     _b_ _b_ _b_ _b_ _b_ ---

``` r
# N3.6 ["Measurement: Area"]
y <- corp_concordance(non_quotes_surface, nodes = nodes, collocates= c("N3.6"), context = 0)
y
```

    ## [  1]                       --- were shifted on to my   shoulders ; such as *stretching* the frames, ---       
    ## [  2]                  --- lie on the rug, *stretch*,     yawn    , talk to each other, or ---                 
    ## [  3]           --- trees that *stretched* their long     arms     over the park-palings; with her ---         
    ## [  4]                --- wheels no longer reached her     ears    , *stretching* her eyes in the ---           
    ## [  5]          --- reached her ears, *stretching* her     eyes     in the direction they had ---               
    ## [  6]           --- the tedium courageously. While he    yawned   , *stretched* himself, and went in ---       
    ## [  7]                 --- quivered under him, and his    fingers   *stretched* themselves nearer to the ---    
    ## [  8]                      --- away his head over the     back     of it, and *stretched* his ---              
    ## [  9]                  --- of it, and *stretched* his finger-nails almost down to the carpet ---               
    ## [ 10]   --- mechanically *stretched* forth his little     arms     towards the dead cold branches ---          
    ## [ 11]    --- discerned Hermanric, she *stretched* her     body     out still farther over the ---              
    ## [ 12]               --- yet, *stretched* in an uneasy    slumber   on a silken couch, lay ---                  
    ## [ 13]             --- wherever he could *stretch* his     hand    . At length he paused at ---                 
    ## [ 14]                   --- cleared a *space* of some     feet     in extent before the base ---               
    ## [ 15]            --- have presented themselves to his     eyes    ; not *stretching* forth in dismal ---       
    ## [ 16]                   --- tenantless. In one of the   sleeping   apartments, *stretched* on his couch, ---   
    ## [ 17]            --- its unnatural position, with its    skinny    arms *stretched* forth, with its ---        
    ## [ 18]         --- unnatural position, with its skinny     arms     *stretched* forth, with its ghastly ---     
    ## [ 19]               --- turned towards them, its bare     arms     were still *stretched* forth as ---         
    ## [ 20]                     --- The knife was under her     hand    ; the streets *stretched* before her; ---    
    ## [ 21]                   --- the hidden *space* at the     back     of the pile, when his ---                   
    ## [ 22]                --- friend. Half asleep and half     awake   , Midwinter was still *stretched* on ---     
    ## [ 23]                      --- the cold wind upon our     faces    and the dark, void *spaces* ---             
    ## [ 24]          --- touching a bony, yellow, crab-like     hand     *stretching* a bared wrist to ---           
    ## [ 25]         --- crab-like hand *stretching* a bared     wrist    to clutch a heap of ---                     
    ## [ 26]                  --- specimen of a lower order,    roused    a tingling resentment which *stretched* --- 
    ## [ 27]              --- the croupier: and Gwendolen 's      arm     was *stretched* to deposit her ---          
    ## [ 28]            --- ground while she *stretched* her     head     forward and fixed her eyes ---              
    ## [ 29]          --- again, rising and *stretching* her     arms     _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 30]                         --- set the sole of his     foot     on an *acre* of his ---                     
    ## [ 31]                   --- pressed his hand upon his    breast   , and then *stretched* its wasted ---        
    ## [ 32]             --- and then *stretched* its wasted    fingers   out before him _b_ _b_ ---                  
    ## [ 33]            --- _b_ Mordecai had *stretched* his     arms     upward, and his long thin ---               
    ## [ 34]         --- nothing; she rose, *stretching* her     arms     upward and clasping her hands ---           
    ## [ 35]                 --- the summit of her whitening     hair     to the long train *stretching* ---          
    ## [ 36]              --- a smaller *space*, packing her     arms     across her chest and leaning ---            
    ## [ 37]         --- would *stretch* forth her wonderful     hand     and arm to mix youth-potions ---            
    ## [ 38]             --- cigar, and then *stretched* his     hand     toward the hat that lay ---                 
    ## [ 39]             --- _b_ Suddenly loosing Deronda 's     hand    , she started up, *stretching* her ---       
    ## [ 40]            --- she started up, *stretching* her     arms     to their full length upward, ---            
    ## [ 41]               --- she had been *stretching* her     arms     toward him from a forsaken ---              
    ## [ 42]               --- her, till she *stretched* her     arms     out straight, and cried with ---            
    ## [ 43]          --- misshapen cloud *stretched* a long      arm     across and hid it. The ---                  
    ## [ 44]        --- looked into *space* with lack-luster     eyes    . _b_ _b_ _b_ _b_ _b_ ---                    
    ## [ 45]               --- latter words through his shut     teeth   . For a *space* of perhaps ---               
    ## [ 46]            --- Clerval *stretched* before me. I    gasped    for breath, and throwing myself ---         
    ## [ 47]               --- have I *stretched* my failing     limbs    upon the sandy plain and ---                
    ## [ 48]         --- lay *stretched* motionless, in deep     sleep    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 49]               --- half rose, and *stretched* my      arm     to draw the curtain. _b_ ---                
    ## [ 50]                    --- _b_ My pulse stopped: my     heart    stood still; my *stretched* arm ---         
    ## [ 51]           --- heart stood still; my *stretched*      arm     was paralysed. The cry died, ---            
    ## [ 52]               --- a moment, was proceeding: his     hand     was already *stretched* towards Mr. ---     
    ## [ 53]               --- hat: he *stretched* forth his     hand     as if to feel whether ---                   
    ## [ 54]          --- darkness. He *stretched* his right     hand     (the left arm, the mutilated ---            
    ## [ 55]  --- furnished house afforded, *stretching* his     feet     upon another, and pulling off ---           
    ## [ 56]                --- a long time *stretching* his     arms     and legs in various directions ---          
    ## [ 57]              --- time *stretching* his arms and     legs     in various directions to convince ---       
    ## [ 58]         --- fender, and *stretched* his cramped     legs     upon the hearth-rug, while the ---          
    ## [ 59]                       --- sun. Far away on each     hand     *stretch* the rich pastures, and ---        
    ## [ 60]                --- See how they *stretch* their   shoulders  up the slope toward the ---                 
    ## [ 61]          --- however they might *stretch* their     necks    and listen; but on this ---                 
    ## [ 62]               --- locks hanging down behind her     ears    , looking into *space*, with strange, ---    
    ## [ 63]          --- into *space*, with strange, dreamy     eyes    . It was a water-color sketch, ---           
    ## [ 64]            --- then again *stretched* forth her     hands    in the darkness _b_ _b_ ---                 
    ## [ 65]          --- old man frequently *stretched* his     eyes     ahead to gaze over the ---                  
    ## [ 66]           --- forward and *stretching* her soft     hands    over the warmth _b_ _b_ ---                 
    ## [ 67]                  --- the view of these feminine     eyes     were practicable *spaces* whereon to ---    
    ## [ 68] --- direction onwards. Eustacia *stretched* her     neck     forward till she caught a ---               
    ## [ 69]           --- and *stretching* himself till his    joints    creaked _b_ _b_ _b_ _b_ ---                 
    ## [ 70]                 --- junctures in her progress a     hand     was invariably *stretched* forward to ---   
    ## [ 71]                    --- shone into each of their     faces    from the bank *stretching* breast-high ---  
    ## [ 72]          --- crowd made battering-rams of their    bodies   , and retreated a short *space* ---          
    ## [ 73]                       --- in which she had left     Fanny    *stretched* on the bed. She ---             
    ## [ 74]                     --- And I *stretch* my fond     arms     around, And I catch but ---                 
    ## [ 75]          --- the threshold; she *stretched* her     hands    towards it, and murmured _b_ ---            
    ## [ 76]                     --- locked under the ice of     sleep   . From the huge *space* of ---               
    ## [ 77]               --- the old man, *stretching* his     arms    ; and as he spoke the ---                    
    ## [ 78]                       --- his brow, he felt the     veins    in the temples *stretch* and ---            
    ## [ 79]                --- away, and felt with extended     arms     along the pillared *space* until ---        
    ## [ 80]               --- the *space*, turning its vast     head     from side to side with ---                  
    ## [ 81]                  --- _b_ _b_ He *stretched* his     hand     on high; over his lofty ---                 
    ## [ 82]            --- Mother *stretch* forth her azure     arms    , and know them not -- ---                   
    ## [ 83]            --- He *stretched* himself and again    yawned    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 84]                   --- hungry; narrow as was her     brow    , it presented *space* enough for ---        
    ## [ 85]                       --- her eyes rested on my     hand    , which, *stretched* over her shoulder, ---  
    ## [ 86]           --- hand, which, *stretched* over her   shoulder  , was writing some directions with ---       
    ## [ 87]                     --- the whole *space* of my     heart   ; I pent them, on the ---                    
    ## [ 88]                   --- upon; an ample *space* of     brow     and a large, dark, and ---                  
    ## [ 89]           --- _b_ _b_ *Stretching* his powerful     arms     in the air, and delivering ---              
    ## [ 90]                 --- as he *stretched* his great     limbs    in the air and inhaled ---                  
    ## [ 91]              --- of corn, and *stretched* their     limbs   , and extinguished their pipes. The ---      
    ## [ 92]              --- of cows *stretching* under her     eyes     from the far east to ---                    
    ## [ 93]                --- at last and *stretching* his     arms     _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 94]             --- *stretched* before him, and his     eyes     were upon it; but they ---                  
    ## [ 95]                 --- 's. She had *stretched* one      arm     so high above her coiled-up ---             
    ## [ 96]          --- _b_ he continued, *stretching* his      arm     towards her waist _b_ _b_ ---               
    ## [ 97]            --- *stretching* his arm towards her     waist    _b_ _b_ _b_ _b_ _b_ ---                     
    ## [ 98]            --- below rose and *stretched* their     arms    , and shook down the beer ---                
    ## [ 99]                --- could not *stretch* her weak     arms     across it, or draw her ---                  
    ## [100]              --- white parasol swaying over her     head    , and old Steyne *stretched* at ---          
    ## [101]       --- the Chevalier were *stretching* their     legs     and composing their minds in ---            
    ## [102]        --- child, *stretching* forth its tender     hands    from its mother 's bosom, ---               
    ## [103]         --- gaunt thorns all *stretching* their     limbs    one way, as if craving ---                  
    ## [104]                 --- _b_ I muttered, knocking my   knuckles   through the glass, and *stretching* ---     
    ## [105]              --- the glass, and *stretching* an      arm     out to seize the importunate ---            
    ## [106]               --- her occupation. It changed to    yawning  , and *stretching*, and _b_ _b_ ---          
    ## [107]                         --- With a sweep of his     hand     he cleared a vacant *space* ---             
    ## [108]                 --- leave no *space* for common   breathing  between _b_ _b_ _b_ _b_ ---                 
    ## [109]                  --- The girl 's fat, shapeless     face     actually *stretched* into a broad ---       
    ## [110]                  --- the open window, and their     feet     *stretched* on the zinc garden ---          
    ## [111]                  --- the cab and *stretched* my     head     out of the window, to ---                   
    ## [112]              --- _b_ he cried, *stretching* his     arms     luxuriously _b_ _b_ _b_ _b_ ---             
    ## [113]                         --- so large and bold a     hand    , and with such wide *spaces* ---

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
Rdev -e "rmarkdown::render('19C_quotes_non-quotes.Rmd')"
```
