function parseDate(str)
{
  var dd  = new Number(str.substring(0,2)); 
  var mm = new Number(str.substring(3,5)); 
  var yyyy = new Number(str.substring(6,10));  
  return new Date(yyyy, mm-1, dd, 0, 0, 0, 0);
}