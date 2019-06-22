import { Client, Message } from "discord.js";
import fs from "fs";
import path from "path";

type Command = {
  command: string;
  run: (message: Message) => Promise<void>;
};

export async function start(): Promise<void> {
  const client = new Client();
  const commands: Command[] = [];

  for (let file of fs.readdirSync(path.join(__dirname, "commands"))) {
    const mod = await import(path.join(__dirname, "commands", file));
    const command = file
      .split(".")
      .slice(0, -1)
      .join(".");
    commands.push({ command, run: mod.default });
  }

  client.on("ready", () => {
    console.log(`application logged in as ${client.user.tag}`);
  });

  client.on("message", async message => {
    if (message.channel.type != "text") {
      return;
    }

    if (!message.content.startsWith("/")) {
      return; // is not command
    }

    const command = message.content.match(/^\/(.*)/);
    if (command) {
      const handler = commands.find(w => w.command === command[1]);
      handler && (await handler.run(message));
    }
  });

  client.login(process.env.DISCORD_TOKEN);
}
