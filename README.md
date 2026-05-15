# CheesyCSV
A lightweight and minimalist lua CSV Parser, not the best, but it gets the job done.

Just simply require it and use it.

# Functions:

## parse(value) - parses the value, value is a multi-line string
## cleanTable() - cleans the csvTable, not required per parse as it automatically cleans
## getTable() - returns the csvTable
## parseValue(value) - changes the datatype of value, value is a string ("\"Hello"\" -> "Hello", "123" -> 123, etc)
