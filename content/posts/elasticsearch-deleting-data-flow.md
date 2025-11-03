---
title: "Understanding Elasticsearch deleting data flow"
date: 2023-01-10T12:51:30+07:00
lastmod: 2023-01-13T12:51:30+07:00
draft: false
tags: ["elasticsearch","engineering"]
series: ["Elasticsearch Basic Data Flows"]
cover:
    image: "/images/posts/es-deleting-data-flow.png"
    caption: "Elasticsearch Indexing Data Flow"
---

How is a document deleted from Elasticsearch? The following diagram shows data flow behinds the scene of deleting a single document.

<!-- {{<figure caption="Elasticsearch Deleting Data Flow" src="/images/posts/es-deleting-data-flow.png">}} -->

<!--more-->

**Step 1**: The client makes a request to delete a document from the cluster, a coordinator node in the cluster takes the request to 
process.

**Step 2**: Based on shard information and the document ID, the coordinator node routes the delete request to a data node
which contains primary shard that stored the document.

**Step 3**: The data node doesn't delete the document immediately, it marks the document as deleted then adding it to 
the memory buffer and appending it to the transaction log. At this time, the document is unsearchable.

When the buffer fills up, the changes are written to a segment and the buffer is clear. In the meantime, the
transaction log still keeps the deleted documents until it gets too big, a full commit is performed. The changes are flushed to
disk, the document is deleted permanently.

If replication is enabled for the index, the replication data process gets started. This data node sends the delete request
to a data node which contains replicas shards of the index. The whole deleting process here will be done on that node to
delete the document from the replica shards completely.
