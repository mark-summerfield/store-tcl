#!/bin/bash
nagelfar.sh \
    | grep -v Unknown.command \
    | grep -v Unknown.variable \
    | grep -v No.info.on.package.*found \
    | grep -v Bad.option.-striped.to..ttk::treeview. \
    | grep -v Variable.*is.never.read \
    | grep -v Found.constant.*which.is.also.a.variable \
    | grep -v Suspicious.variable.name...my.varname \
    | grep -v test_store.tcl.*Found.constant..filename
echo --- Tests ---
./test_store.tcl
echo -------------
du -sh .git
ls -sh .store.str
clc -s -l tcl
str s
git st
