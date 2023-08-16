#include <iostream>
#include <pcap.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netinet/if_ether.h>
#include <netinet/ip.h>

#define MAC_ADDR_LEN 20
#define ETHER_HEADER_LEN sizeof(ether_header)

void processPacket(const u_char* packet) {
    //解析源MAC地址和目的MAC地址
    struct ether_header* eth_header = (struct ether_header*)packet;
    const u_char* src_mac = eth_header->ether_shost;
    const u_char* dst_mac = eth_header->ether_dhost;

    char src_mac_str[MAC_ADDR_LEN];
    char dst_mac_str[MAC_ADDR_LEN];
    sprintf(src_mac_str, "%02x:%02x:%02x:%02x:%02x:%02x",
            src_mac[0], src_mac[1], src_mac[2],
            src_mac[3], src_mac[4], src_mac[5]);
    sprintf(dst_mac_str, "%02x:%02x:%02x:%02x:%02x:%02x",
            dst_mac[0], dst_mac[1], dst_mac[2],
            dst_mac[3], dst_mac[4], dst_mac[5]);
    std::cout << "Source MAC: " << src_mac_str << std::endl;
    std::cout << "Destination MAC: " << dst_mac_str << std::endl;

    //协议类型解析
    struct ip* ip_header = (struct ip*)(packet + ETHER_HEADER_LEN);
    int protocol = ip_header->ip_p;

    if (protocol == IPPROTO_TCP) {
        
    } else if(protocol == IPPROTO_TCP) {
    }
}

int main(int argc, char *argv[])
{
    pcap_t* pcap;
    char errbuf[PCAP_ERRBUF_SIZE];

    pcap = pcap_open_offline("nd_packet.cap", errbuf);
    if (pcap == NULL) {
        std::cout << "Failed to open .cap file: " << "nd_packet.cap, "
                  << errbuf << std::endl;
        return 1;
    }

    struct pcap_pkthdr header;
    const u_char* packet;
    while((packet = pcap_next(pcap, &header)) != NULL) {
        processPacket(packet);
    }

    pcap_close(pcap);
    return 0;
}

