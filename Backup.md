## Creating a backup

```
// See the export location in the service file. Change 8280 to your Dgraph Alpha port if needed
curl localhost:8280/admin/export
```

```
// Import export using the bulk loaded
dgraph bulk -r goldendata.rdf.gz -s goldendata.schema --map_shards=4 --reduce_shards=2 --http localhost:8000 --zero=localhost:5080
```