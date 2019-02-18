# Sub Relationships

### Goal
Create a system that can get the `<can_eat>` predicate, from multiple levels of predicates. 

We will use the following pattern:

```
Steve --> Pear & Apple

Steve --> Admin --> Banana

Steve --> Admin --> Eater --> Satsuma
```

Where `Steve` has direct relationships to `Pear` & `Apple` and indirect relationships to `Banana` and `Satsuma`. 


### Setting the Data
To start off with we need some data to play with:

```
{
  set {
    # Users
    _:p1 <name> "Steve" .
    _:p1 <type> "User" .
    
    # Groups
    _:g1 <name> "Admin" .
    _:g1 <type> "Group" .
    
    _:g2 <name> "Eater" .
    _:g2 <type> "Group" .
    
    # Fruit
    _:f1 <name> "Apple" .
    _:f1 <type> "Fruit" .
    
    _:f2 <name> "Pear" .
    _:f2 <type> "Fruit" .
    
    _:f3 <name> "Banana" .
    _:f3 <type> "Fruit" .
    
    _:f4 <name> "Satsuma" .
    _:f4 <type> "Fruit" .
    
    _:f5 <name> "Cherry" .
    _:f6 <type> "Fruit" .
    
    _:f7 <name> "Coconut" .
    _:f7 <type> "Fruit" .
    
    _:f8 <name> "Strawberry" .
    _:f8 <type> "Fruit" .
    
    _:f9 <name> "Kiwi" .
    _:f9 <type> "Fruit" .
    
    # User --> can_eat --> Fruit
    _:p1 <can_eat> _:f1 .
    _:p1 <can_eat> _:f2 .
    
    # User --> member_of --> Group
    _:p1 <member_of> _:g1 .
    
    # Group --> member_of --> Group
    _:g1 <member_of> _:g2 .
    
    # Group --> can_eat --> Fruit
    _:g1 <can_eat> _:f3 .
    _:g2 <can_eat> _:f4 .
  }
}
```

We've intentionally added Fruits that `Steve` does not have a relationship to (`Coconut`, `Kiwi` etc) to make sure it works properly. 


### The Query

```
{
  # Query for a particular user, Steve. Store as variable "A".
  # A = the UID of user "Steve"
  A as var(func: eq(name, "Steve")) {
    uid
  }

  # Recurse over <member_of> and get all group UIDs
  # of user A as the variable "Agroups".
  # "Agroups" holds the uid's for:
  # "Admin" and "Eater" UIDs from their relationship to Steve.
  var(func: uid(A)) @recurse {
    Agroups as uid
    member_of
  }
  
  # Queries all uid's that are in 'A' or 'Agroups'
  # ("Steve", "Admin", "Eater") and returns the name
	# of the <can_eat> edge for each.
	# @normalize only returns aliased predicate (name)
  permissibleDiet(func: uid(A, Agroups)) @normalize {
    can_eat {
      name: name
    }
  }
}
```

### Output

```json
{
  "data": {
    "permissibleDiet": [
      {
        "name": "Apple",
        "uid": "0x2715"
      },
      {
        "name": "Pear",
        "uid": "0x2716"
      },
      {
        "name": "Banana",
        "uid": "0x2717"
      },
      {
        "name": "Satsuma",
        "uid": "0x2711"
      }
    ]
  },
  "extensions": {
    "server_latency": {
      "parsing_ns": 26188,
      "processing_ns": 6480309,
      "encoding_ns": 625902
    },
    "txn": {
      "start_ts": 10109
    }
  }
}
```
