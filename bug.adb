--  Bug handling
--  Copyright (C) 2002, 2003, 2004, 2005 Tristan Gingold
--
--  GHDL is free software; you can redistribute it and/or modify it under
--  the terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 2, or (at your option) any later
--  version.
--
--  GHDL is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or
--  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with GCC; see the file COPYING.  If not, write to the Free
--  Software Foundation, 59 Temple Place - Suite 330, Boston, MA
--  02111-1307, USA.
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with GNAT.Directory_Operations;
with Version; use Version;

package body Bug is
   --  Declared in the files generated by gnatbind.
   --  Note: since the string is exported with C convension, there is no way
   --  to know the length (gnat1 crashes if the string is unconstrained).
   --  Hopefully, the format of the string seems to be fixed.
   --  We don't use GNAT.Compiler_Version because it doesn't exist
   --   in gnat 3.15p
   GNAT_Version : constant String (1 .. 31 + 15);
   pragma Import (C, GNAT_Version, "__gnat_version");

   function Get_Gnat_Version return String is
   begin
      for I in GNAT_Version'Range loop
         if GNAT_Version (I) = ')' then
            return GNAT_Version (1 .. I);
         end if;
      end loop;
      return GNAT_Version;
   end Get_Gnat_Version;

   procedure Disp_Bug_Box (Except : Exception_Occurrence)
   is
      Id : Exception_Id;
   begin
      New_Line (Standard_Error);
      Put_Line
        (Standard_Error,
         "******************** GHDL Bug occured ****************************");
      Put_Line
        (Standard_Error,
         "Please, report this bug to ghdl@free.fr, with all the output.");
      Put_Line (Standard_Error, "GHDL version: " & Ghdl_Version);
      Put_Line (Standard_Error, "Compiled with " & Get_Gnat_Version);
      Put_Line (Standard_Error, "In directory: " &
                GNAT.Directory_Operations.Get_Current_Dir);
      --Put_Line
      --  ("Program name: " & Command_Name);
      --Put_Line
      --  ("Program arguments:");
      --for I in 1 .. Argument_Count loop
      --   Put_Line ("  " & Argument (I));
      --end loop;
      Put_Line (Standard_Error, "Command line:");
      Put (Standard_Error, Command_Name);
      for I in 1 .. Argument_Count loop
         Put (Standard_Error, ' ');
         Put (Standard_Error, Argument (I));
      end loop;
      New_Line (Standard_Error);
      Id := Exception_Identity (Except);
      if Id /= Null_Id then
         Put_Line (Standard_Error,
                   "Exception " & Exception_Name (Id) & " raised");
         --Put_Line ("exception message: " & Exception_Message (Except));
         Put_Line (Standard_Error,
                   "Exception information:");
         Put (Standard_Error, Exception_Information (Except));
      end if;
      Put_Line
        (Standard_Error,
         "******************************************************************");
   end Disp_Bug_Box;
end Bug;
