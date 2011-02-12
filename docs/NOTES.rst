QC-IMAGE NOTES
--------------

Research Needed
---------------

- Can we use VSS to build consistent disk state without booting Linux?

Goals
-----

Don't expose Linux

     Linux *may* be required, but it's confusing to players. Linux mode
     should not be interactive

Don't rely on netboot 

     NICs are often shitty, if at all possible boot local OS for
     routine operations. This doesn't include one time operations
     (e.g. clonezilla)

Make it pretty

     Players will respect the system more if it is polished. Consider
     soliciting artwork (id collab) for splash screens.

Make network config flexible 

     It should be easy to move a node (to a different location), add a
     node, remove a node, group nodes, and rename (hostname & ip)
     nodes.

     Our weakest areas are Quick Draw stage and the Tourney Stage,
     being able to identify and group machines, get status and preload
     profiles should fix this.

Make sure it gets used

     Get the capability list to tourney early so they plan for machine
     grouping. Write documentation so they know how to use it.
    

Parts
-----

1. NetSNMP + Extension (Client, Linux & Win)
   
   * NetSNMP provides
   
     * OS
     * Processor Load
     * NIC stats and MAC
     * Process stats (monitor Firefox or QL?)
   
   * SNMP Extension needs to provide
     
     * Gets
   
       * Which image is loaded
       * Current match (how?)

     * Sets
   
       * Reboot system
       * Trigger Save, Load, or Wipe
       * Set identify (blink screen, or beep)

2. SNMP Manager (Server)
   
   * Needs to intereact with *dnsmasq* to:

     * Detect DHCP clients
     * Assign and change static DHCP / hostname
   
   * Establish API frontend for active SNMP operations (set or
     manually update gets)

     * Accessible via Message Queue (for web ui requests)
     * CLI app (admin requests)
     * RPC / ReST (stats, aggregation, fun?)

   * Query client machines at regular intervals, populate status
     database for web-ui

3. Web Frontend (Server)

   The main use case for the web ui are going to be for setup. On the
   primary client status listing I plan to integrate detected, but
   unconfigured (no name or static DHCP) clients and allow for easy
   name / ip / group assignment. After setup the focus will be on:

   * Grouping Clients (CTF teams?)
   * Efficiently reporting status of clients
   * Triggering events (load, save, clear, reboot)

4. Client UI (Client, Windows)

   * Account Creation / Login
   * Save Image
   * Load Image
   * Write status for NetSNMP extension (file, named pipe)
   * Read commands from NetSNMP extension

     * Prompt user for before destructive changes
     * Supported commands: start wipe, start save, start load, reboot

API Functions:
--------------

**Machine Operations**

node_reboot(node)
        Send reboot notification to Client UI under Windows, or force
        a reboot under Linux.

node_info(node)
         Returns the node basic info package (os, load, ip, mac, user, revision)

node_refresh(node)
        Invalidate any cache and enqueue an update request

node_refresh_all
        Same as above, but for all nodes

node_clean(node)
        Return True if no significant changes to image since boot,
        else False

node_revert_image(node)
        reset the node to Account Creation / Login state

node_save_image(node) 
        Check node_clean, if image is dirty send a patch
        (warn user), else noop

node_load_image(node, user, revision=latest)
        Check user() and __user_clean(), if needed load the requested
        image. Warn user

node_net_reload(ip)
        tell ip to release/renew DHCP to get new address/hostname

node_refresh(node)
        

**Group Operations**

group_create(*node)
        Create a node group

group_delete(group)
        Delete a group

group_add_node(group, *node)
        Add node(s) to group

group_del_node(group, *node)
        Remove node(s)

**User Operations**

user_add(name, password)

user_del(name)

user_change_password(name)

user_list_patches(name)

user_get_patch(user, revision='latest')

user_del_patch(user, revision='latest')

user_find_node(user)
        Find node(s) where user's image is loaded

user_stats(user) *[Optional]*
        If we get around to it, it'd be nice to scrape some info from
        QL and report it in the admin interface or via the external
        ReST API.

Open Problems
-------------

How can we eliminate PXE all together? Even in the best case, it add
too much time to the boot process. My initial thought, is loading
images via a bunch of USB disks.. Can windows boot from USB disk? 







