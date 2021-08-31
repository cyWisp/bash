#!/bin/bash

function hello(){
	echo "This is hello saying hello..."
	hello_again
}

function hello_again(){
	echo "This is hello_again saying hello..."
}

hello
