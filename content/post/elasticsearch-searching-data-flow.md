---
title: "Understanding Elasticsearch searching data flow"
date: 2023-01-11T22:32:29+07:00
lastmod: 2023-01-11T22:32:29+07:00
draft: false
tags: ["elasticsearch", "engineering"]
series: ["Elasticsearch Basic Data Flows"]



# Uncomment to pin article to front page
# weight: 1
# You can also close(false) or open(true) something for this content.
# P.S. comment can only be closed
# Uncomment to add to the homepage's dropdown menu; weight = order of article
# menu:
#   main:
#     parent: "docs"
#     weight: 1
---

**Search** is a generic term for information retrieval. Elasticsearch provides various retrieval capabilities, including 
full-text searches, geo searches, range searches, scripted searches, and aggregations.

How does Elasticsearch execute a search query behind the scenes? The following diagram shows data flow for searching
operations.

{{<imgcap title="Elasticsearch Searching Data Flow" src="/images/posts/es-searching-data-flow.png">}}

<!--more-->

Elasticsearch executes searches in phases known informally as **scatter**, **search**, **gather**, and **merge**.


### Phase 1: Scatter

The client makes a search request to the cluster, a coordinator node in the cluster takes the request to 
process. Based on the index's information, the coordinator node routes the search request to all data nodes
which contain index's data.

### Phase 2: Search
Each data node, which received the search request in "Phase 1", parses the request to check if any query clauses in 
search query needs to be applied *text analysis process*. If `yes`, the text analysis is get stared. Finally, the data node
execute the search on every segment of index's shards.

### Phase 3: Gather & Merge
The coordinator node in "Phase 1" gathers all search results from the data nodes that it routed the search request to.
After the gathering processing is done, the merging processing gets started. It merges, ranking and sorting the search 
results then returning back to the client.




