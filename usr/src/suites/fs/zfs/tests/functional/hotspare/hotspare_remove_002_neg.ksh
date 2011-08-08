#!/bin/ksh -p
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#

#
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# ident	"@(#)hotspare_remove_002_neg.ksh	1.3	09/06/22 SMI"
#
. $STF_SUITE/tests/functional/hotspare/hotspare.kshlib

################################################################################
#
# __stc_assertion_start
#
# ID: hotspare_remove_002_neg
#
# DESCRIPTION: 
# 	'zpool remove <pool> <vdev> ...' should return fail if
#		- notexist device
#		- not within the hot spares of this pool
#		- hot spares that currently spared in
#
# STRATEGY:
#	1. Create a storage pool
#	2. Add hot spare devices to the pool
#	3. For each scenario, try to remove the hot spares
#	4. Verify the the remove operation get failed 
#
# TESTABILITY: explicit
#
# TEST_AUTOMATION_LEVEL: automated
#
# CODING STATUS: COMPLETED (2005-09-27)
#
# __stc_assertion_end
#
###############################################################################

verify_runnable "global"

function cleanup
{
	poolexists $TESTPOOL && \
		destroy_pool $TESTPOOL

	partition_cleanup
}

function verify_assertion # dev
{
	typeset dev=$1

	for odev in $pooldevs ; do
		log_must $ZPOOL replace $TESTPOOL $odev $dev
		log_mustnot $ZPOOL remove $TESTPOOL $dev
		log_must $ZPOOL detach $TESTPOOL $dev
	done
}

log_assert "'zpool remove <pool> <vdev> ...' should fail with inapplicable scenarios." 

log_onexit cleanup

typeset dev_nonexist dev_notinlist

case $DISK_ARRAY_NUM in
0|1)
	dev_nonexist=/dev/dsk/${disk}s8
	dev_notinlist=${disk}s${SLICE6}
	;;
2|*)
	dev_nonexist=/dev/dsk/${DISK0}s8
	dev_notinlist="${DISK0}s{SLICE6} ${DISK1}s{SLICE6}"
	;;
esac

set_devs

for keyword in "${keywords[@]}" ; do
	setup_hotspares "$keyword"

	for dev in $dev_nonexist ; do
		log_mustnot $ZPOOL remove $TESTPOOL $dev
	done

	for dev in $dev_notinclude ; do
		log_mustnot $ZPOOL remove $TESTPOOL $dev
	done

	iterate_over_hotspares verify_assertion

	destroy_pool "$TESTPOOL"
done

log_pass "'zpool remove <pool> <vdev> ...' fail with inapplicable scenarios."
