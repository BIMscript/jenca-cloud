var utils = require('./server-utils')
var path = require('path')

var DEFAULT_LIBRARY_FILE = path.resolve(path.join(__dirname, '..', 'data', 'library.json'))
var DEFAULT_DATA_FILE = '/data/file.json'

var args = require('minimist')(process.argv, {
  alias:{
    p:'port',
    s:'storage',
    l:'library',
    d:'datafile',
    f:'libraryfile'
  },
  default:{
    port:80,
    storage:process.env.STORAGE || 'jsonfile',
    library:process.env.LIBRARY || 'jsonfile',
    datafile:process.env.DATA_FILE || DEFAULT_DATA_FILE,
    libraryfile:process.env.LIBRARY_FILE || DEFAULT_LIBRARY_FILE
  }
})

utils.bind_server(args, function(error, server){
  console.log('server listening on port: ' + args.port)
})