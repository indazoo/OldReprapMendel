
#include <util/crc16.h>

// packet states
typedef enum {
  PS_START =0,
  PS_LEN,
  PS_CRC,
  PS_PAYLOAD,

  PS_LAST
} PacketState;

typedef enum {
  RC_GENERIC_ERROR   =0,
  RC_OK              =1,
  RC_BUFFER_OVERFLOW =2,
  RC_CRC_MISMATCH    =3,

  RC_LAST
} ResponseCode;


PacketState packet_state = PS_START;
byte packet_target_len = 0;
byte packet_len = 0;
byte packet_target_crc = 0;
byte packet_crc = 0;
ResponseCode packet_response_code = RC_OK;

#define START_BYTE 0xD5

bool process_packet_byte(byte b) {
  if (packet_state == PS_START) {
    if (b == START_BYTE) {
      packet_state = PS_LEN;
      packet_response_code = RC_OK;
    } else {
      // throw an error message?
    }
  } else if (packet_state == PS_LEN) {
    packet_target_len = b;
    packet_len = 0;
    packet_state = PS_CRC;
  } else if (packet_state == PS_CRC) {
    packet_target_crc = b;
    packet_crc = 0;
    packet_state  = PS_PAYLOAD;
  } else if (packet_state == PS_PAYLOAD) {
    if (packet_len < packet_target_len) {
      packet_len++;
      _crc_ibutton_update(packet_crc, b);
      if (commandBuffer.remainingCapacity() == 0) {
	packet_response_code = RC_BUFFER_OVERFLOW;
      } else {
	commandBuffer.append(b);
      }
    }
    if (packet_len >= packet_target_len) {
      packet_state = PS_START;
      // prepare reply packet
      if (packet_crc != packet_target_crc) {
	packet_response_code = RC_CRC_MISMATCH;
      }
      // add reply code here
    }
  }
}

void process_packets() {
}
