#! /usr/bin/ksh -p
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
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# ident	"@(#)smf_installed.ksh	1.2	07/04/12 SMI"
#

# Some debugging stuff....

[[ :${__DEBUG}: == *:smf_cmd_FMRI_wait:* ]] && \
    set -o verbose && \
    set -o xtrace

typeset me=$(whence -p $0)
typeset wai=${me%/*}
typeset self=${me##*/}

. ${STF_TOOLS}/contrib/include/libsmf.shlib

${self%.ksh}_fn "${@}"
