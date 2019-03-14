class m8f_at_EventHandler : EventHandler
{

  // override section //////////////////////////////////////////////////////////

  override void WorldThingSpawned(WorldEvent e)
  {
    if (e == null) { return; }

    Actor thing = e.thing;
    if (thing == null) { return; }

    MaybeDisableGibbing(thing);

    Weapon w = Weapon(thing);
    if (w != null)
    {
      CVar   kickbackMultiplierCVar = CVar.FindCVar("m8f_wm_KickbackMultiplier");
      double kickbackMultiplier     = kickbackMultiplierCVar.GetFloat();
      w.Kickback = int(w.Kickback * kickBackMultiplier);

      CVar   bobMultiplierCVar = CVar.FindCVar("m8f_wm_BobMultiplier");
      double bobMultiplier     = bobMultiplierCVar.GetFloat();
      w.BobRangeX *= bobMultiplier;
      w.BobRangeY *= bobMultiplier;

      MaybeDisableWeaponCrushing(thing);
    }

    if (thing.bMISSILE)
    {
      double missileSizeMultiplier = CVar.FindCVar("m8f_wm_MissileSizeMultiplier").GetFloat();
      thing.scale *= missileSizeMultiplier;
    }

    Inventory i = Inventory(thing);
    if (i == null) { return; }
    if (i.owner) { return; }

    MaybeDisableItemCrushing(i);

    Ammo a = Ammo(thing);
    if (a != null)
    {
      CVar   ammoMultiplierCVar = CVar.FindCVar("m8f_wm_AmmoMultiplier");
      double ammoMultiplier     = ammoMultiplierCVar.GetFloat();
      if (a.Amount != 0) // why there would be ammo not giving ammo? I don't know.
      {
        a.Amount = int(a.Amount * ammoMultiplier);
        if (a.Amount == 0) { a.Amount = 1; }
      }

      MaybeDisableAmmoCrushing(thing);
      MaybeBrightAmmo(thing);
    }
    else
    {
      Weapon w = Weapon(thing);
      if (w != null)
      {
        CVar   ammoMultiplierCVar = CVar.FindCVar("m8f_wm_AmmoMultiplier");
        double ammoMultiplier     = ammoMultiplierCVar.GetFloat();

        if (w.AmmoGive1 != 0)
        {
          w.AmmoGive1 = int(w.AmmoGive1 * ammoMultiplier);
          if (w.AmmoGive1 == 0 ) { w.AmmoGive1 = 1; }
        }

        if (w.AmmoGive2 != 0)
        {
          w.AmmoGive2 = int(w.AmmoGive2 * ammoMultiplier);
          if (w.AmmoGive2 == 0 ) { w.AmmoGive2 = 1; }
        }

        // spawn light
        CVar lightUpCVar = CVar.FindCVar("m8f_wm_LightNotAcquiredWeapons");
        bool lightUp     = lightUpCVar.GetInt();
        if (lightUp)
        {
          vector3 p = w.SpawnPoint;
          WM_Lighter light = WM_Lighter(Actor.Spawn("WM_Lighter", p));
          light.checkedWeapon = w.GetClassName();
        }
      }
    }
  }

  Override Void NetworkProcess(ConsoleEvent e)
  {
    if(e.name == 'm8f_at_givethisammo')
    {
      PlayerInfo player = players[consolePlayer];
      Weapon w = player.ReadyWeapon;
      if (!w) { return; }

      Ammo amm1 = w.Ammo1;
      Ammo amm2 = w.Ammo2;
      if (amm1) { player.mo.GiveInventory(amm1.GetClassName(), 10); }
      if (amm2) { player.mo.GiveInventory(amm2.GetClassName(), 10); }
    }
  }

  // private methods section ///////////////////////////////////////////////////

  private void MaybeDisableWeaponCrushing(Actor a)
  {
    bool disableCrushing = CVar.FindCVar("m8f_wm_DisableWeaponCrushing").GetInt();
    if (disableCrushing) { a.bDONTGIB = true; }
  }

  private void MaybeDisableAmmoCrushing(Actor a)
  {
    bool disableCrushing = CVar.FindCVar("m8f_wm_DisableAmmoCrushing").GetInt();
    if (disableCrushing) { a.bDONTGIB = true; }
  }

  private void MaybeDisableGibbing(Actor a)
  {
    bool disableGibbing = CVar.FindCVar("m8f_wm_DisableGibbing").GetInt();
    if (disableGibbing) { a.bNOEXTREMEDEATH = true; }
  }

  private void MaybeDisableItemCrushing(Inventory item)
  {
    bool disableCrushing = CVar.FindCVar("m8f_wm_DisableItemCrushing").GetInt();
    if (disableCrushing) { item.bDONTGIB = true; }
  }

  private void MaybeBrightAmmo(Actor a)
  {
    bool brightAmmo = CVar.GetCVar("m8f_at_BrightAmmo").GetInt();
    if (brightAmmo) { a.bBRIGHT = true; }
  }

} // class m8f_at_EventHandler
