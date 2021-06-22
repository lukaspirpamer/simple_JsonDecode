# simple json-decode
*simple_JsonDecode.m* is a json-file parser written in MATLAB. It reads a json-file and returns the fields as a MATLAB-struct. This script is suited for oder MATLAB versions (&lt;2017)
In newer MATLAB versions, the 'jsondecode'-command should be available as a built-in function. \
Advantage: No compilation needed!

## Useage: 
```simple_JsonDecode(jsonFilePath)```

Input:  *jsonFilePath*: full path of json file \
Output: *MATLAB-struct*

## Assumed format of json-file:
```
  "FIELDNAME1": DOUBLE,
  "FIELDNAME2": "STRING",
  "FIELDNAME3": [ARRAYVALUE1,ARRAYVALUE2],
  ```
  
 ## See also:
 If you are looking for a faster mexfile based version, please give a look at: [matlab-json](https://github.com/leastrobino/matlab-json)


[![View simple_JsonDecode on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://de.mathworks.com/matlabcentral/fileexchange/94595-simple_jsondecode)

