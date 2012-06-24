#!/bin/sh
ant clean
ant
cp output/apps.war /data/apps/
ant clean
