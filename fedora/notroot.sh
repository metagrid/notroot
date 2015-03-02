#!/bin/bash
#
# <meta:header>
#   <meta:licence>
#     Copyright (c) 2015, MetaGrid (http://www.metagrid.co.uk/)
#     Based on original from FireThorn project (http://www.roe.ac.uk/)
#
#     This information is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#
#     This information is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#  
#     You should have received a copy of the GNU General Public License
#     along with this program.  If not, see <http://www.gnu.org/licenses/>.
#   </meta:licence>
# </meta:header>
#
# Shell script to create a non-root user.
#

useruid=${useruid:-1000}
usergid=${usergid:-${useruid}}
username=${username:-notroot}
userhome=${userhome:-/home/${username}}
usertype=${usertype:-normal}
usershell=${usershell:-/bin/bash}

#
# Check the user group.
echo "Checking group [${usergid}]"
if [ -z "$(getent group "${usergid}")" ] 
then
    echo "Creating group [${username}][${usergid}]"
    groupadd \
        --gid "${usergid:?}" \
        "${username}"
fi

#
# Check the user account.
echo "Checking user [${useruid}]"
if [ -z "$(getent passwd "${useruid}")" ] 
then

    case "${usertype}" in

        normal)

            echo "Creating user [${username}][${useruid}][${usergid}]"
            useradd \
                --create-home \
                --uid   "${useruid:?}" \
                --gid   "${usergid:?}" \
                --home  "${userhome:?}" \
                --shell "${usershell:?}" \
                "${username:?}"

            ;;

        system)

            echo "Creating system user [${username}][${useruid}][${usergid}]"
            useradd \
                --system \
                --uid   "${useruid:?}" \
                --gid   "${usergid:?}" \
                --home  "${userhome:?}" \
                --shell "${usershell:?}" \
                "${username:?}"
            ;;


        *)
            echo $"Unknown user type : [${usertype}] {normal|system}"
            exit 1

    esac
fi

#
# Run the container command.
if [ -z "$@" ]
then
    sudo -u "#${useruid:?}" -i
else
    sudo -u "#${useruid:?}" -i "$@"
fi

