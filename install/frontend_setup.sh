#!/bin/sh

cd frontend
./build.sh
cd ..
cp -r ./frontend/build ./backend/api/static
cp ./backend/mkcert/certs/rootCA.pem ./backend/api/static
