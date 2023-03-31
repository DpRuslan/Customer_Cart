On "main" branch the program was implemented without CoreData.
On "DevBranch" the program was implemented with CoreData.
The program looks like Customer Cart. I had test
database. I did a request on backend by RestAPI(GET request). Firstly, I parsed 
JSON to structures, saved it to CoreData. Secondly, I fetched the list of data back 
from CoreData by NSFetchedResultsController and showed it on tableView. This 
project contains detail info of each cart. We can perform various manipulations 
on the carts.

