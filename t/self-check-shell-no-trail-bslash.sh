#! /bin/sh
# Copyright (C) 2012 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Check that our fake "shell" used to guard against use of trailing
# backslashes in recipes actually complains when those are used.

# Our hack doesn't work with some make implementations (see comments
# in 't/ax/shell-no-trail-bslash.in' for more details).
required=GNUmake
am_create_testdir=empty
. test-init.sh

cat >> Makefile <<'END'
am__backslash = \\ # foo
.PHONY: good bad
good:
	@printf '%s\n' OK
.PHONY: bad
bad:
	@echo $(am__backslash)
END

SHELL=$am_testaux_builddir/shell-no-trail-bslash
$SHELL -c 'exit 0'
test "$($SHELL -c 'echo is  o\k')" = "is ok"

$MAKE good

$MAKE bad SHELL="$SHELL" 2>stderr && { cat stderr >&2; exit 1; }
cat stderr >&2
$FGREP "recipe ends with backslash character" stderr

: