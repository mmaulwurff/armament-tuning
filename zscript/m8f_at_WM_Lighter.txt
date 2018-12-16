class WM_Lighter : Actor
{

  string checkedWeapon;

  Default
  {
    +NOGRAVITY;
  }

  States
  {
  Spawn:
    TNT1 A 0;
    TNT1 A 0 a_jumpifinventory(checkedWeapon, 1, "NoLight", AAPTR_PLAYER1);
  Light:
    TNT1 A 10;// A_Log("light");
    goto Spawn;
  NoLight:
    TNT1 B 35;// A_Log("no light");
    loop;
  }

} // class WM_Lighter
