/*
 * This file is part of libgsm0710
 *
 * (C) 2008-2010 Michael 'Mickey' Lauer <mlauer@vanille-media.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 */

[CCode (cheader_filename = "gsm/gsm0710.h")]
namespace Gsm0710
{
    [CCode (cname = "GSM0710StatusType", cprefix="GSM0710_")]
    public enum SerialStatus
    {
        FC, RTC, RTR, RING, DCD
    }

    [CCode (cheader_filename = "errno.h")]
    public const int MAX_CHANNELS;

    [CCode (has_target = false)]
    public delegate bool at_command_t( Context ctx, string command );
    [CCode (has_target = false)]
    public delegate int read_t( Context ctx, void* data, int len );
    [CCode (has_target = false)]
    public delegate bool write_t( Context ctx, void* data, int len );
    [CCode (has_target = false)]
    public delegate void deliver_data_t( Context ctx, int channel, void* data, int len );
    [CCode (has_target = false)]
    public delegate void deliver_status_t( Context ctx, int channel, int status );
    [CCode (has_target = false)]
    public delegate void debug_message_t( Context ctx, string msg );
    [CCode (has_target = false)]
    public delegate void open_channel_t( Context ctx, int channel );
    [CCode (has_target = false)]
    public delegate void close_channel_t( Context ctx, int channel );
    [CCode (has_target = false)]
    public delegate void terminate_t( Context ctx );
    [CCode (has_target = false)]
    public delegate bool packet_filter_t( Context ctx, int channel, int type, char* data, int len );
    [CCode (has_target = false)]
    public delegate void response_to_test_t( Context ctx, char[] data ); /*char* data, int len );*/

    [CCode (cname = "struct gsm0710_context", free_function = "gsm0710_context_free")]
    [Compact]
    public class Context
    {
        /* Internal */
        public int mode;
        public int frame_size;
        public int port_speed;
        // not mapping char buffer[];
        // not mapping int buffer_used;
        // not mapping unsingedl long used_channels[];
        // not mapping const char* reinit_detect;
        // not mapping int reinit_detect_len;
        public void* user_data;
        public int fd;

        /* Callbacks */
        public at_command_t at_command;
        public read_t read;
        public write_t write;
        public deliver_data_t deliver_data;
        public deliver_status_t deliver_status;
        public debug_message_t debug_message;
        public open_channel_t open_channel;
        public close_channel_t close_channel;
        public terminate_t terminate;
        public packet_filter_t packet_filter;
        public response_to_test_t response_to_test;

        /* Commands */
        [CCode (cname = "gsm0710_context_new")]
        public Context();

        [CCode (cname = "gsm0710_startup")]
        public bool startup( bool send_cmux );

        [CCode (cname = "gsm0710_shutdown")]
        public void shutdown();

        [CCode (cname = "gsm0710_open_channel")]
        public bool openChannel( int channel );

        [CCode (cname = "gsm0710_close_channel")]
        public void closeChannel( int channel );

        [CCode (cname = "gsm0710_is_channel_open")]
        public bool isChannelOpen( int channel );

        [CCode (cname = "gsm0710_ready_read")]
        public void readyRead();

        [CCode (cname = "gsm0710_write_data")]
        public void writeDataForChannel( int channel, void* data, int len );

        [CCode (cname = "gsm0710_set_status")]
        public void setStatus( int channel, int status );

        [CCode (cname = "gsm0710_send_test")]
        public void sendTest( void* data, int len );
    }
}
