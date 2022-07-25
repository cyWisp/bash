#!/bin/bash

unset pass
read -p 'Pass: ' -s pass
echo -n "password: ${pass}"
