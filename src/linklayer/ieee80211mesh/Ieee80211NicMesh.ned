//
// Copyright (C) 2008 Alfonso Ariza
//
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 2
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
//
//

package inet.linklayer.ieee80211mesh;

import inet.linklayer.ieee80211mesh.mgmt.Ieee80211Mesh;
import inet.linklayer.ieee80211.radio.Ieee80211Radio;
import inet.linklayer.ieee80211.mac.Ieee80211Mac;
import inet.linklayer.IWirelessNic;


//
// This NIC implements an 802.11 network interface card in ad-hoc mode.
//
module Ieee80211NicMesh like IWirelessNic
{
    parameters:
        @display("i=block/ifcard");
        string mgmtType = "Ieee80211Mesh";
        int numMac = default(1);
    gates:
        input upperLayerIn; // to upper layers
        output upperLayerOut; // from upper layers
        input radioIn; // to receive AirFrames
        input fromEthernet @labels(Ieee80211Frame);   // to Ethernet MAC
        output toEthernet @labels(Ieee80211Frame); // to Ethernet MAC

    submodules:
        mgmt: Ieee80211Mesh {
            parameters:
                @display("p=96,69;q=wlanDataQueue");
        }
        mac[numMac]: Ieee80211Mac {
            parameters:
                queueModule = "mgmt";
                @display("p=96,155");
        }
        radio: Ieee80211Radio {
            parameters:
                @display("p=96,240");
        }
    connections allowunconnected:
        radioIn --> radio.radioIn;
        for i=0..numMac-1 {
            radio.upperLayerIn <-- mac[i].lowerLayerOut;
            radio.upperLayerOut --> mac[i].lowerLayerIn;

            mac[i].upperLayerOut --> mgmt.macIn[i];
            mac[i].upperLayerIn <-- mgmt.macOut[i];
        }

        mgmt.upperLayerOut --> upperLayerOut;
        mgmt.upperLayerIn <-- upperLayerIn;
        mgmt.toEthernet --> toEthernet;
        mgmt.fromEthernet <-- fromEthernet;
}

