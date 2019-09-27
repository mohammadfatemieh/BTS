/**
 * File:	netif.c
 * Author:	Patrick Leyman
 *
 * Date:	25/05/2014
 */

#include <stdlib.h>
#include "netif.h"
#include "arp.h"
#include "ip.h"

netif_t *netif_list;
netif_t *netif_default;
static uint8_t netif_num;

void netif_init(void) {
}

/**
 * Set a network interface as the default network interface (used to output all packets for which no specific route is found)
 *
 * @param netif the default network interface
 */
void netif_set_default(netif_t*netif) {
	netif_default = netif;
}

/**
 * Add a network interface to the list of network interfaces.
 *
 * @param netif a pre-allocated netif structure
 * @param ipaddr IP address for the new netif
 * @param netmask network mask for the new netif
 * @param gw default gateway IP address for the new netif
 * @param state opaque data passed to the new netif
 * @param init callback function that initializes the interface
 * @param input callback function that is called to passing packets up in the protocol layer stack.
 *
 * @return netif, or NULL if failed.
 */

netif_t *netif_add(netif_t *netif, uint32_t ipaddr, uint32_t netmask, uint32_t gw, void *state, netif_init_fn init, netif_input_fn input) {
	/* reset new interface configuration state */
	netif->ip_addr = 0;
	netif->netmask = 0;
	netif->gateway = 0;
	netif->flags = 0;
	netif->dhcp = NULL;
	netif->status_callback = NULL;
	netif->link_callback = NULL;

	/* remember netif specific state information data */
	netif->state = state;
	netif->num = netif_num++;
	netif->input = input;

	netif_set_addr(netif, ipaddr, netmask, gw);
	if (init(netif) != ERR_OK) {
		return NULL;
	}

	/* add this netif to the list */
	netif->next = netif_list;
	netif_list = netif;

	return netif;
}

/**
 * Bring an interface up, available for processing traffic.
 *
 * @note: Enabling DHCP on a down interface will make it come up once configured.
 *
 * @see dhcp_start()
 */
void netif_set_up(netif_t *netif) {
	if (!(netif->flags & NETIF_FLAG_UP)) {
		netif->flags |= NETIF_FLAG_UP;

		if (netif->flags & NETIF_FLAG_LINK_UP) {
			// For Ethernet network interfaces, we would like to send a "gratuitous ARP"
			if (netif->flags & (NETIF_FLAG_ETHARP)) {
				arp_gratuitous(netif);
			}
		}
	}
}

/**
 * Bring an interface down, disabling any traffic processing.
 *
 * @note: Enabling DHCP on a down interface will make it come up once configured.
 *
 * @see dhcp_start()
 */
void netif_set_down(netif_t *netif) {
	if (netif->flags & NETIF_FLAG_UP) {
		netif->flags &= ~NETIF_FLAG_UP;
	}
	if (netif->flags & NETIF_FLAG_ETHARP) {
		arp_cleanup_netif(netif);
	}
}

/**
 * Change IP address configuration for a network interface (including netmask and default gateway).
 *
 * @param netif the network interface to change
 * @param ipaddr the new IP address
 * @param netmask the new netmask
 * @param gw the new default gateway
 */
void netif_set_addr(netif_t *netif, uint32_t ipaddr, uint32_t netmask, uint32_t gw) {
	netif->ip_addr = ipaddr;
	netif->netmask = netmask;
	netif->gateway = gw;
}

/**
 * Call netif_poll() in the main loop of your application. This is to prevent reentering non-reentrant functions like tcp_input(). Packets passed to
 * netif_loop_output() are put on a list that is passed to netif->input() by netif_poll().
 */
void netif_poll(netif_t *netif) {
	pbuf_t *in;
	err_t status;

	in = pbuf_alloc();
	if (in != NULL) {
		status = netif->hw_input(in);
		switch (status) {
		case 0:
			netif->rx_packets++;
			netif->rx_bytes += in->length;
			netif->input(in, netif);
			break;
		case ERR_IF:
			netif->rx_drop_packets++;
		}
		pbuf_free(in);
	}
}

/**
 * Calls netif_poll() for every netif on the netif_list.
 */
void netif_poll_all(void) {
	netif_t *netif = netif_list;
	/* loop through netifs */
	while (netif != NULL) {
		netif_poll(netif);
		/* proceed to next network interface */
		netif = netif->next;
	}
}

