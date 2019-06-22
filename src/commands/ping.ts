import { Message } from "discord.js";

export default async function(message: Message): Promise<void> {
  await message.reply("pong");
}
