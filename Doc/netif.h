/**
 * File:	netif.h
 * Author:	Patrick Leyman
 *
 * Date:	24/05/2014
 */

#ifndef __NETIF_H__
#define __NETIF_H__

#include <stdint.h>
#include "pbuf.h"
#include "err.h"

struct dhcp;
struct netif;

/** must be the maximum of all used hardware address lengths across all types of interfaces in use */
#define NETIF_MAX_HWADDR_LEN 6U

/** Whether the network interface is 'up'. This is a software flag used to control whether this network
 * interface is enabled and processes traffic. It is set by the startup code (for static IP configuration) or
 * by dhcp/autoip when an address has been assigned.
 */
#define NETIF_FLAG_UP						0x01U
/** If set, the netif has broadcast capability. Set by the netif driver in its init function. */
#define NETIF_FLAG_BROADCAST		0x02U
/** If set, the netif is one end of a point-to-point connection. Set by the netif driver in its init function. */
#define NETIF_FLAG_POINTTOPOINT	0x04U
/** If set, the interface is configured using DHCP. Set by the DHCP code when starting or stopping DHCP. */
#define NETIF_FLAG_DHCP					0x08U
/** If set, the interface has an active link  (set by the network interface driver).
 * Either set by the netif driver in its init function (if the link is up at that time) or at a later point once the link comes up
 * (if link detection is supported by the hardware). */
#define NETIF_FLAG_LINK_UP				0x10U
/** If set, the netif is an ethernet device using ARP. Set by the netif driver in its init function.
 * Used to check input packet types and use of DHCP. */
#define NETIF_FLAG_ETHARP				0x20U
/** If set, the netif is an ethernet device. It might not use ARP or TCP/IP if it is used for PPPoE only. */
#define NETIF_FLAG_ETHERNET			0x40U
/** If set, the netif has IGMP capability. Set by the netif driver in its init function. */
#define NETIF_FLAG_IGMP					0x80U

#define netif_is_up(netif) (((netif)->flags & NETIF_FLAG_UP) ? (uint8_t)1 : (uint8_t)0)

/**
 * @see RFC1213, "MIB-II, 6. Definitions"
 */
enum snmp_ifType {
	snmp_ifType_other = 1, /* none of the following */
	snmp_ifType_regular1822,
	snmp_ifType_hdh1822,
	snmp_ifType_ddn_x25,
	snmp_ifType_rfc877_x25,
	snmp_ifType_ethernet_csmacd,
	snmp_ifType_iso88023_csmacd,
	snmp_ifType_iso88024_tokenBus,
	snmp_ifType_iso88025_tokenRing,
	snmp_ifType_iso88026_man,
	snmp_ifType_starLan,
	snmp_ifType_proteon_10Mbit,
	snmp_ifType_proteon_80Mbit,
	snmp_ifType_hyperchannel,
	snmp_ifType_fddi,
	snmp_ifType_lapb,
	snmp_ifType_sdlc,
	snmp_ifType_ds1, /* T-1 */
	snmp_ifType_e1, /* european equiv. of T-1 */
	snmp_ifType_basicISDN,
	snmp_ifType_primaryISDN, /* proprietary serial */
	snmp_ifType_propPointToPointSerial,
	snmp_ifType_ppp,
	snmp_ifType_softwareLoopback,
	snmp_ifType_eon, /* CLNP over IP [11] */
	snmp_ifType_ethernet_3Mbit,
	snmp_ifType_nsip, /* XNS over IP */
	snmp_ifType_slip, /* generic SLIP */
	snmp_ifType_ultra, /* ULTRA technologies */
	snmp_ifType_ds3, /* T-3 */
	snmp_ifType_sip, /* SMDS */
	snmp_ifType_frame_relay
};

/** Function prototype for netif init functions. Set up flags and output/linkoutput
 * callback functions in this function.
 *
 * @param netif The netif to initialize
 */
typedef err_t (*netif_init_fn)(struct netif *netif);

typedef err_t (*netif_hw_input_fn)(pbuf_t *p);

typedef err_t (*netif_hw_output_fn)(pbuf_t *p);

/** Function prototype for netif->input functions. This function is saved as 'input'
 * callback function in the netif struct. Call it when a packet has been received.
 *
 * @param p The received packet, copied into a buffer
 * @param inp The netif which received the packet
 */
typedef err_t (*netif_input_fn)(pbuf_t *p, struct netif *inp);

/** Function prototype for netif->output functions. Called by lwIP when a packet
 * shall be sent. For ethernet netif, set this to 'etharp_output' and set 'linkoutput'.
 *
 * @param netif The netif which shall send a packet
 * @param p The packet to send
 * @param ipaddr The IP address to which the packet shall be sent
 */
typedef err_t (*netif_output_fn)(struct netif *netif, pbuf_t *p, uint32_t ipaddr);

/** Function prototype for netif->linkoutput functions. Only used for ethernet
 * netifs. This function is called by ARP when a packet shall be sent.
 *
 * @param netif The netif which shall send a packet
 * @param p The packet to send (raw ethernet packet)
 */
typedef err_t (*netif_linkoutput_fn)(pbuf_t *p);

/** Function prototype for netif status- or link-callback functions. */
typedef void (*netif_status_callback_fn)(struct netif *netif);

/** Function prototype for netif igmp_mac_filter functions */
typedef err_t (*netif_igmp_mac_filter_fn)(struct netif *netif, uint32_t *group, uint8_t action);

/** Generic data structure used for all lwIP network interfaces.  The following fields should be filled in by the initialization
 *  function for the device driver: hwaddr_len, hwaddr[], mtu, flags */
typedef struct __attribute__((__packed__)) netif {
	struct netif *next; // Pointer to next network interface in linked list
	uint32_t ip_addr;
	uint32_t netmask;
	uint32_t gateway;

	netif_hw_input_fn hw_input; // Get a packet from the network adapter
	netif_input_fn input; // This function is called by the network device driver to pass a packet up the TCP/IP stack
	netif_output_fn output; // This function is called by the IP module when it wants to send a packet on the interface (incl. MAC resolving).
	netif_linkoutput_fn linkoutput; // This function is called by the ARP module when it wants to send a packet as-is on the interface.
	netif_status_callback_fn status_callback; // This function is called when the netif state is set to up or down (optional)
	netif_status_callback_fn link_callback; // This function is called when the netif link is set to up or down (optional)
	netif_status_callback_fn remove_callback; // This function is called when the netif has been removed (optional)

	void *state; // This field can be set by the device driver and could point  to state information for the device.
	struct dhcp *dhcp;  // the DHCP client state information for this netif
	uint8_t *hostname;
	uint16_t mtu;  // maximum transfer unit (in bytes)
	uint8_t hwaddr_len; // number of bytes used in hwaddr
	uint8_t hwaddr[NETIF_MAX_HWADDR_LEN]; // link level hardware address of this interface
	uint8_t flags; // flags (see NETIF_FLAG_ above)
	uint8_t name[2]; // descriptive abbreviation
	uint8_t num; // number of this interface
	uint8_t link_type;
	uint32_t link_speed;

	/* counters */
	uint32_t rx_bytes;
	uint32_t rx_packets;
	uint32_t rx_drop_packets;
	uint32_t tx_bytes;
	uint32_t tx_packets;
	uint32_t tx_drop_packets;
} netif_t;

extern netif_t *netif_list;
extern netif_t *netif_default;

void netif_init(void);
void netif_set_default(netif_t*netif);
netif_t *netif_add(netif_t *netif, uint32_t ipaddr, uint32_t netmask, uint32_t gw, void *state, netif_init_fn init, netif_input_fn input);
void netif_set_addr(netif_t *netif, uint32_t ipaddr, uint32_t netmask, uint32_t gw);
void netif_set_up(netif_t *netif);
void netif_set_down(netif_t *netif);
void netif_poll(netif_t *netif);
void netif_poll_all(void);

#endif /* __NET_IF_H__ */
