load("common.js")

// on add handler
var onAdd = function(foo) {
  print("Hello from JavaScript, added " + foo.name);
};

// on delete handler
var onDelete = function(foo) {
  print("Hello from JavaScript, deleted " + foo.name);
};

// start the operator
startOperator(onAdd, onDelete);

// sleep 10 years
java.lang.Thread.sleep(1000 * 60 * 60 * 24 * 365 * 10);