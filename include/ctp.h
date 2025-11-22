// include/ctp.h
#ifndef CTP_H
#define CTP_H

#include <cstddef>
#include <cstdint>
#include <string>

// CTP constants from protocol docs
constexpr uint8_t CTP_PTYPE_DATA = 1;
constexpr uint8_t CTP_PTYPE_ACK  = 2;
constexpr uint8_t CTP_PTYPE_NACK = 3;

constexpr std::size_t CTP_MAX_PAYLOAD = 512;
constexpr std::size_t CTP_HEADER_LEN  = 12;  // Type/TR/Window + Seq + Length + Timestamp + CRC1

// Build a CTP DATA segment into out_buffer.
//  - payload_len <= 512
//  - If payload_len > 0, CRC2 is appended (4 bytes).
//  - Returns total packet length (header + payload + optional CRC2), or 0 on error.
std::size_t build_ctp_data_packet(
    uint8_t* out_buffer,
    std::size_t out_capacity,
    const uint8_t* payload,
    std::size_t payload_len,
    uint8_t seqnum,
    uint8_t window = 1
);

// Parse and verify an ACK packet received from the reference receiver.
//  - Returns true on success, false on error (bad type, too short, CRC1 mismatch, etc.).
bool parse_and_verify_ack(
    const uint8_t* buffer,
    std::size_t length,
    uint8_t& out_window,
    uint8_t& out_seqnum
);

// The main sender routine to be called from main().
int run_sender(int argc, char* argv[]);

#endif // CTP_H
