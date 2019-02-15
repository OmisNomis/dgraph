# dgraph
dgraph examples

## General queries

```
// Set initial data
{
  set {
    _:steve <name> "Steve" .
    _:mark <name> "Mark" .
    _:bill <name> "Bill" .

    _:admin <name> "Admin" .
    _:writer <name> "Writer" .
    _:reader <name> "Reader" .


    _:read <name> "Read" .
    _:write <name> "Write" .
    _:delete <name> "Delete" .

    _:steve <member_of> _:admin .
    _:mark <member_of> _:writer .
    _:mark <member_of> _:reader .
    _:bill <member_of> _:reader .

    _:mark <friends_with> _:steve .
    _:mark <friends_with> _:bill .
    _:bill <friends_with> _:steve .
    _:steve <friends_with> _:bill .

    _:admin <can_do> _:read .
    _:admin <can_do> _:write .
    _:admin <can_do> _:delete .

    _:writer <can_do> _:read .
    _:writer <can_do> _:write .

    _:reader <can_do> _:read .

  }
}
```

```
// Update existing nodes
// (Bill -> member_of -> Admin)
{
  set {
    <0x37> <member_of> <0x32>
  }
}
```

```
// Query relationships
{
  q(func: eq(name, "Mark")) {
    uid
    name
    friends_with {
      name
      friends_with {
        name
        member_of {
          name
          can_do {
            name
          }
        }
      }
    }
    member_of {
      name
      can_do {
        name
      }
    }
  }
}
```

```
// Multi Query
{
  m(func: eq(name, "Mark")) {
    uid
    name
    member_of {
      name
      can_do {
        name
      }
    }
  }
  s(func: eq(name, "Steve")) {
    uid
    name
    member_of {
      name
      can_do {
        name
      }
    }
  }
}
```

```
// Has Query
{
  q(func: has(name)) {
  	uid
    name
  }
}
```

```
// Check Password
{
  q(func: eq(name, "SimonO")){
    uid
    password
    checkpwd(password2, "abc122")
    can_access @filter(eq(name, "PowerhashWeb")) {
      name 
    }
  }
}
```

```
// Multiple filters
{
  q(func: eq(name, "SimonO")) @filter(eq(password, "abc") OR eq(password, "aaa")) {
    uid
    can_access @filter(eq(name, "PowerhashWeb")) {
      name 
    }
  }
}
```

```
// Filter on lower-level
{
  q(func: eq(name, "SimonO")) {
    uid
    can_read @filter(eq(type, "Workergroup")) {
      name
      type
    }
  }
}
```
