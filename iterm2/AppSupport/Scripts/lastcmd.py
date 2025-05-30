#!/usr/bin/env python3
import iterm2

async def main(connection):
    @iterm2.StatusBarRPC(
        short_description="Last Cmd",
        detailed_description="Shows your last zsh command",
        update_cadence=1,
        identifier="com.user.lastcmd",
    )
    async def last_cmd(knobs, session_id):
        app = await iterm2.async_get_app(connection)
        session = app.get_session_by_id(session_id)
        # the shell‐integration puts your last input into a session var called "user_input"
        val = await session.async_get_variable("user_input", default="")  
        return f"▶ {val}"

    await last_cmd.async_register(connection)

iterm2.run_forever(main)
