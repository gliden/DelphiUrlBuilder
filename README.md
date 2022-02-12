# DelphiUrlBuilder
 
With this class there is an easy way to build URLs. 

Create a new instance with the base url, including parameters.
```
url := TUrlBuilder.Create('http://localhost/:param1/:param2');
``` 

Then set the values for the params:
```
url.SetParam('param1', 'value1');
url.SetParam('param2', 'value2');
``` 

If you want to add some query-parameters do it like that: 
```
url.AddQueryParam('query1', 'queryValue1');
url.AddQueryParam('query2', 'param3');
```
To get the generated url use the ToString-Function:
```
url.ToString;
```
