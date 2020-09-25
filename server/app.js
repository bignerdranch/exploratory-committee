var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require('cors')
var bodyParser = require('body-parser')

const mongoose = require('mongoose');
const connectionString = "mongodb+srv://budaminof:Jesus212!@cluster0.g2ll0.mongodb.net/giraffe?retryWrites=true&w=majority"

var indexRouter = require('./routes/index');
var screens = require('./routes/screens');

var app = express();

app.use(cors())
// view engine setup
app.set('views', path.join(__dirname, 'views'));

app.use(logger('dev'));
app.use(express.json());
app.use(bodyParser.json())
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

mongoose.connect(connectionString, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});

app.use('/screens', screens);
app.use('/', indexRouter);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  console.log('something went wrong');
  next(createError(404));
});

// error handler
app.use(function (err, req, res, next) {
  // render the error page
  res.status(err.status || 500);
});

module.exports = app;
