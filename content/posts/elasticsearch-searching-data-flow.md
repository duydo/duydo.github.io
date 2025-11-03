---
title: "Understanding Elasticsearch searching data flow"
date: 2023-01-11T22:32:29+07:00
lastmod: 2023-01-11T22:32:29+07:00
tags: ["elasticsearch", "engineering"]
series: ["Elasticsearch Basic Data Flows"]
cover:
    image: "images/posts/es-searching-data-flow.png" # image path/url
    caption: "Elasticsearch Searching Data Flow" # display caption under cover
---

**Search** is a generic term for information retrieval. Elasticsearch provides various retrieval capabilities, including 
full-text searches, geo searches, range searches, scripted searches, and aggregations.

How does Elasticsearch execute a search query behind the scenes? The following diagram shows data flow for searching
operations.
<!-- 
{{<figure caption="Elasticsearch Searching Data Flow" src="/images/posts/es-searching-data-flow.png">}} -->

<!--more-->

Elasticsearch executes searches in phases known informally as **scatter**, **search**, **gather**, and **merge**.

### Phase 1: Scatter
The client makes a search request to the cluster, a coordinator node in the cluster takes the request to 
process. Based on the index's information, the coordinator node routes the search request to all data nodes
which contain index's data.

### Phase 2: Search
Each data node, which received the search request in "Phase 1", parses the request to check if any query clauses in 
search query needs to be applied *text analysis process*. If `yes`, the text analysis processing gets started. Finally, the data node
executes the search request on every segment of the index's shards.

### Phase 3: Gather & Merge
The coordinator node in "Phase 1" gathers the search results from all data nodes that it routed the search request to.
After the gathering processing is done, the merging processing gets started. It merges, ranks and sorts the search 
results then returning them back to the client.

