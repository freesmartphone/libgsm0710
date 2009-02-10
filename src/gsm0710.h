/*
 * gsm0710_p.h - low level 3GPP 07.10 protocol implementation
 *
 * (C) 2000-2008 TROLLTECH ASA.
 * (C) 2009 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 2 of the License.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 */

#ifndef GSM0710_P_H
#define GSM0710_P_H

#ifdef __cplusplus
extern "C" {
#endif

#define GSM0710_BUFFER_SIZE             4096
#define GSM0710_DEFAULT_FRAME_SIZE      31
#define GSM0710_MAX_CHANNELS            63

#define GSM0710_MODE_BASIC              0
#define GSM0710_MODE_ADVANCED           1

/* Atoms */
#define GSM0710_CMD_TEST 0x20
#define GSM0710_PF 0x10
#define GSM0710_CR 0x02
#define GSM0710_EA 0x01

/* Frame types and subtypes */
#define GSM0710_OPEN_CHANNEL            0x3F
#define GSM0710_CLOSE_CHANNEL           0x53
#define GSM0710_DATA                    0xEF
#define GSM0710_DATA_ALT                0x03
#define GSM0710_STATUS_SET              0xE3
#define GSM0710_STATUS_ACK              0xE1
#define GSM0710_TERMINATE_BYTE1         0xC3
#define GSM0710_TERMINATE_BYTE2         0x01


/* Additional Frame types and subtypes */
#define GSM0710_SABM                    0x2F
#define GSM0710_UNNUMBERED_ACK          0x63
#define GSM0710_DISCONNECT_MODE         0x0F
#define GSM0710_DISCONNECT              0x43

/* Status flags */
#define GSM0710_FC                      0x02
#define GSM0710_DTR                     0x04
#define GSM0710_DSR                     0x04
#define GSM0710_RTS                     0x08
#define GSM0710_CTS                     0x08
#define GSM0710_RING                    0x40
#define GSM0710_DCD                     0x80

struct gsm0710_context;

typedef    int     (*gsm0710_context_at_command_callback)(struct gsm0710_context *ctx, const char *cmd);
typedef    int     (*gsm0710_context_read_callback)(struct gsm0710_context *ctx, void *data, int len);
typedef    int     (*gsm0710_context_write_callback)(struct gsm0710_context *ctx, const void *data, int len);
typedef    void    (*gsm0710_context_deliver_data_callback)(struct gsm0710_context *ctx, int channel, const void *data, int len);
typedef    void    (*gsm0710_context_deliver_status_callback)(struct gsm0710_context *ctx, int channel, int status);
typedef    void    (*gsm0710_context_debug_message_callback)(struct gsm0710_context *ctx, const char *msg);
typedef    void    (*gsm0710_context_open_channel_callback)(struct gsm0710_context *ctx, int channel);
typedef    void    (*gsm0710_context_close_channel_callback)(struct gsm0710_context *ctx, int channel);
typedef    void    (*gsm0710_context_terminate_callback)(struct gsm0710_context *ctx);
typedef    int     (*gsm0710_context_packet_filter_callback)(struct gsm0710_context *ctx, int channel, int type, const char *data, int len);
typedef    void     (*gsm0710_context_response_to_test_callback)(struct gsm0710_context *ctx, const char *data, int len);

struct gsm0710_context
{
    /* GSM 07.10 implementation details */
    int     mode;
    int     frame_size;
    int     port_speed;
    int     server;
    char    buffer[GSM0710_BUFFER_SIZE];
    int     buffer_used;
    unsigned long used_channels[(GSM0710_MAX_CHANNELS + 31) / 32];
    const char *reinit_detect;
    int     reinit_detect_len;

    /* Hooks to upper layers */
    void   *user_data;
    int     fd;

    gsm0710_context_at_command_callback at_command;
    gsm0710_context_read_callback read;
    gsm0710_context_write_callback write;
    gsm0710_context_deliver_data_callback deliver_data;
    gsm0710_context_deliver_status_callback deliver_status;
    gsm0710_context_debug_message_callback debug_message;
    gsm0710_context_open_channel_callback open_channel;
    gsm0710_context_close_channel_callback close_channel;
    gsm0710_context_terminate_callback terminate;
    gsm0710_context_packet_filter_callback packet_filter;
    gsm0710_context_response_to_test_callback response_to_test;
};

void gsm0710_initialize(struct gsm0710_context *ctx);
void gsm0710_set_reinit_detect(struct gsm0710_context *ctx, const char *str);
int gsm0710_startup(struct gsm0710_context *ctx, int send_cmux);
void gsm0710_shutdown(struct gsm0710_context *ctx);
int gsm0710_open_channel(struct gsm0710_context *ctx, int channel);
void gsm0710_close_channel(struct gsm0710_context *ctx, int channel);
int gsm0710_is_channel_open(struct gsm0710_context *ctx, int channel);
void gsm0710_ready_read(struct gsm0710_context *ctx);
void gsm0710_write_frame(struct gsm0710_context *ctx, int channel, int type, const char *data, int len);
void gsm0710_write_data(struct gsm0710_context *ctx, int channel, const void *data, int len);
void gsm0710_set_status(struct gsm0710_context *ctx, int channel, int status);
int gsm0710_compute_crc(const char *data, int len);

void gsm0710_send_test(struct gsm0710_context* ctx, const void* testdata, int len);

#ifdef __cplusplus
};
#endif

#endif
