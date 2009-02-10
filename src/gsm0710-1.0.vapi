/*
 * gsm0710.vapi
 *
 * Authored by Michael 'Mickey' Lauer <mlauer@vanille-media.de>
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

[CCode (cheader_filename = "gsm0710/gsm0710_p.h")]
namespace Gsm0710
{
    [CCode (cname = "GSM0710StatusType", cprefix="GSM0710_")]
    public enum SerialStatus
    {
        FC, DTR, DSR, RTS, CTS, RING, DCD
    }

    [CCode (cheader_filename = "errno.h")]
    public const int MAX_CHANNELS;

    //[CCode (instance_pos = 0)] only for non-static delegates
    public static delegate bool at_command_t( Context ctx, string command );
    public static delegate int read_t( Context ctx, void* data, int len );
    public static delegate bool write_t( Context ctx, void* data, int len );
    public static delegate void deliver_data_t( Context ctx, int channel, void* data, int len );
    public static delegate void deliver_status_t( Context ctx, int channel, int status );
    public static delegate void debug_message_t( Context ctx, string msg );
    public static delegate void open_channel_t( Context ctx, int channel );
    public static delegate void close_channel_t( Context ctx, int channel );
    public static delegate void terminate_t( Context ctx );
    public static delegate bool packet_filter_t( Context ctx, int channel, int type, char* data, int len );
    public static delegate void response_to_test_t( Context ctx, char[] data ); /*char* data, int len );*/

    [CCode (cname = "struct gsm0710_context", free_function = "")]
    [Compact]
    public class Context
    {
        /* Internal */
        public int mode;
        public int frame_size;
        public int port_speed;
        public int server;
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
        [CCode (cname = "gsm0710_initialize")]
        public void initialize();

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
