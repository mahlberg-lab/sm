# imports

# define list of subsets
# define list of corpora to use

# get all corpora from api   

# loop through each corpus based on list
        # loop through each book belonging to each corpora
            # loop through each subset
                # get data from api using url using looped corpora/book/subset
                # write data to .txt file using corpora/subset/book structure


import requests
import os

corpora_desired = ["DNov", "19C", "ChiLit", "AAW"]
subsets_desired = ["quote", "nonquote", "longsus", "shortsus"]

corpora_all = requests.get("https://clic.bham.ac.uk/api/corpora").json()

# Loop through all corpora from API
for corpus in corpora_all['corpora']:
    
    # Remove 'corpus:' from the id (if possible)
    try:
        corpus_id = corpus['id'].replace("corpus:", "")
    except:
        corpus_id = corpus['id']
    
    # Only continue if current corpus is in corpora_desired list
    if corpus_id in corpora_desired:

        # Loop through each book in each corpus
        for book in corpus['children']:

            # Loop through each desired subset
            for subset in subsets_desired:

                # Build URL using looped variables (in query corpora actually means book)
                url = "https://clic.bham.ac.uk/api/subset?corpora={}&subset={}".format(book['id'], subset)

                # Get data from API using above URL, storing in json format
                text_data = requests.get(url).json()

                # Loop through each text item, converting from array to a string and formatting as desired
                output = ""
                for text_item in text_data['data']:
                    output += "{}\n".format(''.join(text_item[0][0:-1]))

                # Build directory path and file name using looped variables
                filename = "api-output/{}/{}/{}.txt".format(corpus_id, subset, book['id'])
            

                # Create directories, ready to write file
                os.makedirs(os.path.dirname(filename), exist_ok=True)

                # Write file
                with open(filename, "w") as f:
                     f.write(output)
                     print("File written to: {}".format(filename))
                